#Funciones para mapear los tags asignados por cell counter entre las images de transmision
#y fluorescencia con cellID.data object
#plot.cardinality(X,pts.table,...,max.radius=30,max.cardinality=3)
#map.cells.points(X,pts.table,radius=10,var.name="pts",append.pts.XY=FALSE,...)
#Argumentos
#X          cell.data object 
#pts.table  data.frame de CellCounter
#...        Argumentos para seleccionar datos de X: pos, t.frame, filter, etc
#max.radius Hasta que radio se plotea los counts para cada cardinalidad
#max.cardinality  Hasta que cardinalidad se calcula
#radius     El radio con el cual se hace el mapeo (idealmente meseta de card=1 de plot.cardinality)
#var.name   Nombre de la variable agregada con el Type del punto si X es cellID.data object
#append.pts.XY  boolean indicando si agregar posicion XY del punto


#Calcula la distancia euclidiana entre una lista de puntos y la posicion XY
# de cada celula. La lista de puntos debe ser un data.frame, con columnas
#"Type", "X", "Y". Pensado para la salide de CellCounter de ImageJ.
#X  cell.data object. 
#cell.counter.table  el data.frame de la salida de CellCounter

calc.dist.matrix<-function(X,cell.counter.table,pos=NULL,t.frame=0,subset=TRUE,QC.filter=TRUE){
	subset<-substitute(subset)
	on.exit(gc())
  
	pts.xy<-data.frame(cell.counter.table,pid=1:dim(cell.counter.table)[1])

	if(isTRUE(QC.filter) && class(X$data$QC)=="logical"){
		X$data=subset(X$data,QC)
	}

	if(is.null(pos))stop("position argument required for Cell-Id data\n")
	
	X$data<-subset(X$data,eval(subset,X$data))
    
	cells.xy<-X$data[X$data$pos==pos&X$data$t.frame==t.frame,c("ucid","xpos","ypos")]
    names(cells.xy)<-c("cid","X","Y")

	dist.array<-array(0,dim=c(dim(cells.xy)[1],dim(pts.xy)[1]),dimnames=list(cells.xy$cid,pts.xy$pid))
	for(j in 1:dim(pts.xy)[1]){
		dist.array[,j]<-sqrt((cells.xy$X-pts.xy$X[j])^2+(cells.xy$Y-pts.xy$Y[j])^2)
	}

	return(dist.array)
}



#alias para plot.mapping.radius.count
#toma directamente las tablas en lugar de la matriz de distancias
cardinality.plot<-function(X,cell.counter,pos=NULL,t.frame=0,...,max.radius=30,max.cardinality=3){
  plot.mapping.radius.count(
    calc.dist.matrix(X,cell.counter,pos,t.frame,...)
    ,max.radius=max.radius
    ,max.cardinality=max.cardinality
   )
}

#Genera un plot con informacion util para elegir el radio de cutoff para el mapeo
#entre puntos y celulas.
#Algoritmo: para cada radio de cutoff, calcula de la matriz de distancias cuales
#valores quedan debtro (1) o fuera (0) del cutoff. Despues saca el total de las columnas y las
#filas por separado. Finalmente se fija cuantoas filas tienen un total igual a la
#cardinalidad dada. Lo mismo para columnas. Plotea estos valores en funcion del radio
#de cutoff, para varias cardinalidades.

#dist.matrix    matiz devuelta por calc.dist.matrix
#max.radius
#max.cardinality
plot.mapping.radius.count<-function(dist.matrix,max.radius=30,max.cardinality=3){

  legend.txt<-c("point cardinality","cell cardinality","cardinality=1")
  legend.pch<-c(16,17,15)
  legend.col<-c(1,1,2)

  rs<-c()
  cs<-c()
  for(i in 1:max.radius){
      rs<-c(rs,sum(as.numeric(rowSums(dist.matrix<=i)==1)))
      cs<-c(cs,sum(as.numeric(colSums(dist.matrix<=i)==1)))
  }
  plot(rs,col=2,pch=16,xlab="radius (px)",ylab="counts")
  points(cs,col=2,pch=17)

  for(card in 2:max.cardinality){
    rs<-c()
    cs<-c()
    for(i in 1:max.radius){
      rs<-c(rs,sum(as.numeric(rowSums(dist.matrix<=i)==card)))
      cs<-c(cs,sum(as.numeric(colSums(dist.matrix<=i)==card)))
    }
    points(rs,col=card+1,pch=16)
    points(cs,col=card+1,pch=17)

    legend.txt<-c(legend.txt,paste("cardinality=",card,sep=""))
    legend.pch<-c(legend.pch,15)
    legend.col<-c(legend.col,card+1)

  }

  legend("bottom",legend.txt,pch=legend.pch,col=legend.col,yjust=-1)

}

#mapea celulas de cellId con los puntos devueltos por cell counter. Asigna el
#valor del tag de cellcounter a una nueva variable del objeto
#X  cellID.data object
#cell.counter  data.frame levantado de la salida de cell counter
#var.name   el nombre de la variable agregada con la informacion del Type de los puntos

map.cells.points<-function(X,cell.counter,pos=NULL,t.frame=0,...,radius=10,var.name="tag"
	,init.value=NA,map.to.all.t=TRUE){
	
  on.exit(gc())	

  if(is.data.frame(cell.counter)){
	if(is.null(pos)) stop("position required when cell.counter is a data.frame")
	tmp<-cell.counter
	cell.counter<-list()
	cell.counter[[pos]]<-tmp
  }
  
  if(!is.list(cell.counter)) stop("cell.counter should be a data.frame or a pos named list of data.frames")
  
  if(!is.null(names(cell.counter))){
	list.pos.index=as.numeric(names(cell.counter))
  } else {
 	list.pos.index=which(sapply(cell.counter,FUN=is.data.frame))
  }
  if(! sum(is.element(list.pos.index,unique(X$data$pos)))==length(list.pos.index) ){
	stop("some elements of cell.counter list do not correspond to valid positions of the dataset")
  }

  dist.matrix<-list()
  mapping<-list()
  for(p in list.pos.index){
	cat("calculating  dist.matrix for position ",p,"\n")
	dist.matrix[[p]]<-calc.dist.matrix(X,cell.counter[[p]],pos=as.numeric(p),t.frame=t.frame,...)

	#creando tabla de mapeos
	cid<-as.numeric(names(dist.matrix[[p]][,1]))
	pid<-as.numeric(names(dist.matrix[[p]][1,]))

	map.cid<-integer(0)
	map.pid<-integer(0)
	map.pX<-integer(0)
	map.pY<-integer(0)
	map.pType<-integer(0)

	for(i in 1:length(cid)){ #for each cell
		pts.index<-as.numeric(which(dist.matrix[[p]][i,]<=radius))

		if(length(pts.index)==0){ #no match
			map.cid<-c(map.cid,cid[i])
			map.pid<-c(map.pid,NA)
			map.pX<-c(map.pX,NA)
			map.pY<-c(map.pY,NA)
			map.pType<-c(map.pType,init.value)

		}else if (length(pts.index)==1) { #unique match
			map.cid<-c(map.cid,cid[i])
			map.pid<-c(map.pid,pid[pts.index])
			map.pX<-c(map.pX,cell.counter[[p]]$X[pts.index])
			map.pY<-c(map.pY,cell.counter[[p]]$Y[pts.index])
			map.pType<-c(map.pType,cell.counter[[p]]$Type[pts.index])

		} else {  #several matches
			map.cid<-c(map.cid,cid[i])

			sel.index<-max(pts.index)  #selecting latest point
			cat("cell ",cid[i]," mapped to ",length(pts.index)," points. Arbitrary point assigned to latest point.\n")

			map.pid<-c(map.pid,pid[sel.index])
			map.pX<-c(map.pX,cell.counter[[p]]$X[sel.index])
			map.pY<-c(map.pY,cell.counter[[p]]$Y[sel.index])
			map.pType<-c(map.pType,cell.counter[[p]]$Type[sel.index])

		}
	}

	mapping[[p]]<-data.frame(ucid=map.cid,cell.counter.Type=map.pType)
  }
  gc()

  if(is.cell.data(X)){

	#splitting dataset into positions
	if(map.to.all.t){ #same mapping for all t.frames of the position
		cat("merging \n")
		########## ACA DEBERIA USAR merge.cell.data ##################
		# data.ucid<-split(subset(X$data,select=c(ucid,pos)),as.factor(X$data$pos))
		# output<-list()
		# for(p in unique(X$data$pos) ){
			# if(is.element(p,list.pos.index)){
				# output[[p]]<-merge(subset(data.ucid[[as.character(p)]],select=c(ucid,pos)),mapping[[p]],by="ucid",all.x=TRUE,all.y=FALSE)
			# } else {
				# output[[p]]<-data.frame(data.ucid[[as.character(p)]],cell.counter.Type=init.value)
			# }
		# }
		
		if(!is.element(var.name,names(X$data))) X$data[,var.name]<-rep(NA,dim(X$data)[1])
		
		pos.ucid<-subset(X$data,select=c("pos","ucid",var.name))
		for(p in list.pos.index){
			pos.ucid.map<-join(pos.ucid,mapping[[p]],by="ucid")
			pos.ucid[,var.name]<-ifelse(pos.ucid$pos==p,pos.ucid.map$cell.counter.Type,pos.ucid[,var.name])
		}
	} else {
		stop("map.to.all.t=FALSE not supported yet, sorry.")
	}
	
	#agrego las variables a X$variables
	X$data[,var.name]<-pos.ucid[,var.name]
	X$variables$merged=unique(c(X$variables$merged,var.name))
	X$variables$merged.by=c(X$variables$merged.by,"ucid")
	X$variables$all=union(X$variables$all,var.name)
	if(setequal("ucid",intersect("ucid",X$variables$as.factor)))
		X$variables$as.factor=union(X$variables$as.factor,var.name)
	
	gc()

  } else {
	stop("The function only works with cellid data at the time, sorry.")

  }
  return(X)
}
