
append.cor.prj<-function(X,.by,order.var,select,pattern,center=ceiling(length(pattern)/2),subset=TRUE,QC.filter=TRUE
			,correlation.prefix="cor.",projection.prefix="prj."){

	subset=substitute(subset)
	on.exit(gc())

	#selecting variables
	select<-Rcell:::.select(X$variables,select) #retrieving names of selected variables
	select.vars<-unique(c("ucid","t.frame",select,order.var,names(.by))) #adding names of id.vars and splitting vars

	#getting the data
	if(QC.filter && class(X$data$QC)=="logical")
		data<-X$data[X$data$QC,]
	else
		data<-X$data

	data<-data[eval(subset,data),select.vars]

	#creating the pattern matrix
	mpdim<-length(unique(data[,order.var]))
	mp<-matrix(0,mpdim,mpdim)
	for(i in 1:mpdim) mp[max(1,i-center+1):min(mpdim,i+center-1),i]<-pattern[max(1,center-i+1):min(length(pattern),mpdim-i+center)]
	norm2<-function(x)sqrt(sum(x^2))
	mp.norm<-apply(mp,2,norm2)*(norm2(pattern)/pattern[center])

	#creating correlation and projection variable names
	cor.prj.var.names<-paste0(rep(c(correlation.prefix,projection.prefix),each=length(select)),rep(select,2))

	#calculate correlation and projectio of a single element
	cor.prj.df<-function(df){
		df<-df[order(df[,order.var]),]
		m<-as.matrix(df[,select])
		dm1<-dim(m)[1]
		db<-as.data.frame(cbind(
			t(cor(m,mp[1:dm1,1:dm1]))
			,t(t(m) %*% mp[1:dm1,1:dm1]) / mp.norm[1:dm1]
			,df[,c(order.var,"ucid","t.frame")]))
		names(db)<-c(cor.prj.var.names,order.var,"ucid","t.frame")
		return(db)
	}

	#use plyr to apply to all elements
	db<-ddply(data,.by,cor.prj.df)

	for(i in intersect(cor.prj.var.names,names(X$data))) X$data[[i]]<-NULL #deleting old version of the variable
	join.by.vars<-c("ucid","t.frame") #setdiff(names(db),cor.prj.var.names)
	tmp<-join(subset(X$data,select=join.by.vars),db,by=join.by.vars) #adding created variables to the dataset
	for(i in cor.prj.var.names) X$data[[i]]<-tmp[[i]]
		
	X$variables$merged=unique(c(X$variables$merged,cor.prj.var.names))
	X$variables$all=unique(c(X$variables$all,cor.prj.var.names))
	
	return(X)
}


calculate.cor.prj<-function(data,.by,order.var,select,pattern,center=ceiling(length(pattern)/2)
			,correlation.prefix="cor.",projection.prefix="prj."){

	#creating the pattern matrix
	mpdim<-length(unique(data[,order.var]))
	mp<-matrix(0,mpdim,mpdim)
	for(i in 1:mpdim) mp[max(1,i-center+1):min(mpdim,i+center-1),i]<-pattern[max(1,center-i+1):min(length(pattern),mpdim-i+center)]
	norm2<-function(x)sqrt(sum(x^2))
	mp.norm<-apply(mp,2,norm2)*(norm2(pattern)/pattern[center])

	#creating correlation and projection variable names
	cor.prj.var.names<-paste0(rep(c(correlation.prefix,projection.prefix),each=length(select)),rep(select,2))
	join.by.vars<-c(order.var,names(.by))
	
	#calculate correlation and projectio of a single element
	cor.prj.df<-function(df){
		df<-df[order(df[,order.var]),]
		m<-as.matrix(df[,select])
		dm1<-dim(m)[1]
		db<-as.data.frame(cbind(
			t(cor(m,mp[1:dm1,1:dm1]))
			,t(t(m) %*% mp[1:dm1,1:dm1]) / mp.norm[1:dm1]
			,df[,join.by.vars]))
		names(db)<-c(cor.prj.var.names,join.by.vars)
		return(db)
	}

	#use plyr to apply to all elements
	db<-ddply(data,.by,cor.prj.df)

	for(i in intersect(cor.prj.var.names,names(data))) data[[i]]<-NULL #deleting old version of the variable
	tmp<-join(subset(data,select=join.by.vars),db,by=join.by.vars) #adding created variables to the dataset
	for(i in cor.prj.var.names) data[[i]]<-tmp[[i]]
	
	return(data)
}



append.in.focus<-function(X,focus.var,in.focus.var="in.focus"){
	id.vars=c("pos","t.frame","z.scan")
	
	utf.db<-X[[,c(id.vars,focus.var)]]
	names(utf.db)<-c(id.vars,"focus.var")
	utf.db<-recast(utf.db,pos+t.frame+z.scan~variable,fun.aggregate=mean,id.var=id.vars)
	utf.db<-transformBy(utf.db,.(pos,z.scan),in.focus=focus.var==max(focus.var))
	names(utf.db)<-c(id.vars,focus.var,in.focus.var)
	X=merge(X,subset(utf.db,select=c(id.vars,in.focus.var)),by=id.vars)
	return(X)
}

append.z.scan<-function(X
	,fun.z.scan=function(x)(as.numeric(as.factor((x-x%%100)/100))) 
	,fun.z.slice=function(x)(x%%100)
	,fun.oif=function(x)((x-x%%10000)/10000)
	,TIME.TOKEN="time",TIME.DIGITS=5
	,channel=X$channels$name[1]){
	#browser()
	on.exit(gc())	

	imgs1<-X$images[X$images$channel==channel,]
	
	tif.time.rx<-regexpr(paste(TIME.TOKEN,"[0-9]{",TIME.DIGITS,"}",sep=""),imgs1$image)
	tif.time.index<-as.numeric(substring(imgs1$image,tif.time.rx+nchar(TIME.TOKEN) 
										 ,tif.time.rx + attr(tif.time.rx,"match.length") - 1))
	imgs1$time.index<-tif.time.index 
							
	imgs1<-splat(rbind)(
		dlply(imgs1,.(pos),function(dd) {
			transform(dd,z.scan=fun.z.scan(time.index)
						,z.slice=fun.z.slice(time.index) 
						,oif=fun.oif(time.index))}))
	
	imgs1<-subset(imgs1,select=c(pos,t.frame,time.index,z.scan,z.slice,oif))

	#elimino variables si existen
	if(is.element("z.scan",names(X$data))) X$data$z.scan<-NULL
	if(is.element("z.slice",names(X$data))) X$data$z.slice<-NULL
	if(is.element("oif",names(X$data))) X$data$oif<-NULL
	
	if(is.element("z.scan",names(X$images))) X$images$z.scan<-NULL
	if(is.element("z.slice",names(X$images))) X$images$z.slice<-NULL
	if(is.element("oif",names(X$images))) X$images$oif<-NULL
	if(is.element("time.index",names(X$images))) X$images$time.index<-NULL
	
	gc()
	
	X$images<-join(X$images,imgs1,by=c("pos","t.frame"))
	
	#X=merge(X,imgs1,by=c("pos","t.frame"))
	
	tmp<-join(subset(X$data,select=c(pos,t.frame)),imgs1,by=c("pos","t.frame"))
	gc()
	tmp<-subset(tmp,select=c(-pos,-t.frame,-time.index))
	X$data<-cbind(X$data,tmp)
	X$variables$merged<-union(X$variables$merged,names(tmp))
	X$variables$all<-union(X$variables$all,names(tmp))
	
	return(X)
}

append.anular.y <- function(X) {

	#cantidades anulares                                                       
	X=transform(X	
		,f.p1.y = f.tot.p1.y - f.tot.y
		,f.m0.y = f.tot.y - f.tot.m1.y
		,f.m1.y = f.tot.m1.y - f.tot.m2.y
		,f.m2.y = f.tot.m2.y - f.tot.m3.y
		,a.p1 = a.tot.p1 - a.tot
		,a.m0 = a.tot - a.tot.m1
		,a.m1 = a.tot.m1 - a.tot.m2
		,a.m2 = a.tot.m2 - a.tot.m3
	)
	return(X)
}

append.anular.c <- function(X) {

	#cantidades anulares                                                       
	X=transform(X	
		,f.p1.c = f.tot.p1.c - f.tot.c
		,f.m0.c = f.tot.c - f.tot.m1.c
		,f.m1.c = f.tot.m1.c - f.tot.m2.c
		,f.m2.c = f.tot.m2.c - f.tot.m3.c
		,a.p1 = a.tot.p1 - a.tot
		,a.m0 = a.tot - a.tot.m1
		,a.m1 = a.tot.m1 - a.tot.m2
		,a.m2 = a.tot.m2 - a.tot.m3
	)
	return(X)
}

append.anular.r <- function(X) {

	#cantidades anulares                                                       
	X=transform(X	
		,f.p1.r = f.tot.p1.r - f.tot.r
		,f.m0.r = f.tot.r - f.tot.m1.r
		,f.m1.r = f.tot.m1.r - f.tot.m2.r
		,f.m2.r = f.tot.m2.r - f.tot.m3.r
		,a.p1 = a.tot.p1 - a.tot
		,a.m0 = a.tot - a.tot.m1
		,a.m1 = a.tot.m1 - a.tot.m2
		,a.m2 = a.tot.m2 - a.tot.m3
	)
	return(X)
}

append.memRec.y<-function(X){
  on.exit(gc())
  
  cat("appending f.int.y \n")
	X=transform(X,
		f.int.y=
	  ((f.tot.m3.y/a.tot.m3-f.local.bg.y)*(4/3)*pi*(-3+(maj.axis+min.axis)/4)^3) +
	  ((f.m2.y/a.m2-f.local.bg.y)*4*pi*(-2+(maj.axis+min.axis)/4)^2) +
	  ((f.m1.y/a.m1-f.local.bg.y)*4*pi*(-1+(maj.axis+min.axis)/4)^2) +
	  ((f.m0.y/a.m0-f.local.bg.y)*4*pi*((maj.axis+min.axis)/4)^2) +
	  ((f.p1.y/a.p1-f.local.bg.y)*4*pi*(+1+(maj.axis+min.axis)/4)^2)
	)

  cat("appending f.mem.y \n")
	X=transform(X,
	  f.mem.y=
	  ((f.m0.y/a.m0-f.local.bg.y)*4*pi*((maj.axis+min.axis)/4)^2) +
	  ((f.p1.y/a.p1-f.local.bg.y)*4*pi*(+1+(maj.axis+min.axis)/4)^2)
	)
  
  cat("appending f.obs.y \n")
	X=transform(X, f.obs.y= f.mem.y/f.int.y )

  return(X)
}

append.memRec.r<-function(X){
  on.exit(gc())
  
  cat("appending f.int.r \n")
	X=transform(X,
		f.int.r=
	  ((f.tot.m3.r/a.tot.m3-f.local.bg.r)*(4/3)*pi*(-3+(maj.axis+min.axis)/4)^3) +
	  ((f.m2.r/a.m2-f.local.bg.r)*4*pi*(-2+(maj.axis+min.axis)/4)^2) +
	  ((f.m1.r/a.m1-f.local.bg.r)*4*pi*(-1+(maj.axis+min.axis)/4)^2) +
	  ((f.m0.r/a.m0-f.local.bg.r)*4*pi*((maj.axis+min.axis)/4)^2) +
	  ((f.p1.r/a.p1-f.local.bg.r)*4*pi*(+1+(maj.axis+min.axis)/4)^2)
	)

  cat("appending f.mem.r \n")
	X=transform(X,
	  f.mem.r=
	  ((f.m0.r/a.m0-f.local.bg.r)*4*pi*((maj.axis+min.axis)/4)^2) +
	  ((f.p1.r/a.p1-f.local.bg.r)*4*pi*(+1+(maj.axis+min.axis)/4)^2)
	)
  
  cat("appending f.obs.r \n")
	X=transform(X, f.obs.r= f.mem.r/f.int.r )

  return(X)
}


append.oif.time<-function(X,OIF.date="OIF-date.txt",path=getwd(),pos.digits=2,oif.digits=2){
	#loads times from a OIF-date.txt file, generated by the following scripts
	#oif2txt.bat: for %%i in (*.oif) do type %%i > %%~ni.txt
	#selectLineFromOif.bat: sfk filter -ls+"ImageCaputre" -file .txt > OIF-date.txt
	#the first one changes the encoding of the .oif files, from unicode to ascii
	#the second one uses sfk (http://swissfileknife.sourceforge.net/) to extract the time line from the file
	#the OIF-date.txt should look like this

	#01_01_YPP3662_XYZ.txt :
	#	ImageCaputreDate='2011-08-20 11:15:59'
	#	ImageCaputreDate+MilliSec=984

	#the oif filename is expected to be of the form ##_##_* where # are digits [0-9]. 
	#the digits before the underscore are the position, and the digits after the underscore are the oif file 
	#arguments pos.digits and oif.digits specify the expected digits fot these numbers

	#to add seconds to a chron object
	#SECONDS.PER.DAY=60*60*24
	#oif.time+1/SECONDS.PER.DAY

	if(!"oif"%in%names(X$data)) 
		stop("oif variable required in cell.data, run append.z.scan before calling this function",call.=FALSE)	

	on.exit(gc())
	library(chron)
	
	oif=read.table(paste(path,"/",OIF.date,sep=""), sep="\t",as.is=T)
	oif.s=seq(1,dim(oif)[1]-2,3)
		
	oif.db=data.frame(
		pos=as.numeric(substring(oif[oif.s,],1,pos.digits))
		,oif=as.numeric(substring(oif[oif.s,],2+pos.digits,1+pos.digits+oif.digits))
		,oif.hour=chron(times.=substring(oif[oif.s+1,],32,40),format=c("h:m:s"))
		,oif.msec=as.numeric(substring(oif[oif.s+2,],30,nchar(oif[oif.s+2,])))
	)
	
	#oif.db<-transformBy(oif.db,.(pos),oif.time=oif.hour-oif.hour[oif==1])
	oif.db=transformBy(oif.db,.(pos)
		,D.oif.hour=oif.hour-oif.hour[oif==1]
		,D.oif.msec=oif.msec-oif.msec[oif==1])	

	oif.db=transform(oif.db
		,oif.time.s=3600*hours(D.oif.hour)+60*minutes(D.oif.hour)+seconds(D.oif.hour)+D.oif.msec/1000)

	oif.db.table<-with(oif.db,table(pos,oif))
	if(sum(oif.db.table>1)>0) 
		stop("some pos has repeated oif in ",OIF.date)

	tmp<-join(X$data[,c("pos","oif")],subset(oif.db,select=c(pos,oif,oif.time.s)),by=c("pos","oif"))
	tmp<-subset(tmp,select=c(-pos,-oif))
	X$data<-cbind(X$data,tmp)
	X$variables$merged<-union(X$variables$merged,names(tmp))
	X$variables$all<-union(X$variables$all,names(tmp))
	
	X$oif.time<-subset(oif.db,select=c(-D.oif.hour,-D.oif.msec)) #agrego esta table al objeto cell.data

	return(X)
}

append.oif.interval<-function(X,OIF.interval="OIF-Interval.txt",path=getwd(),pos.digits=2,oif.digits=2){
	#loads interval times from a OIF-Interval.txt file, generated by the following scripts
	#oif2txt.bat: for %%i in (*.oif) do type %%i > %%~ni.txt
	#selectLineFromOif.bat: sfk filter -ls+"Interval" -file .txt > OIF-Interval.txt
	#the first one changes the encoding of the .oif files, from unicode to ascii
	#the second one uses sfk (http://swissfileknife.sourceforge.net/) to extract the revelant lines from the file.
	#OIF-Interval.txt should look like this

	#01_01_YAB3789_XYZ.txt :
	#	Interval=500
	#	Interval=0
	#	Interval=10
	
	#the oif filename is expected to be of the form ##_##_* where # are digits [0-9]. 
	#the digits before the underscore are the position, and the digits after the underscore are the oif file 
	#arguments pos.digits and oif.digits specify the expected digits fot these numbers

	on.exit(gc())
	
	oif=read.table(paste(path,"/",OIF.interval,sep=""), sep="\t",as.is=T)
	oif.s=seq(1,dim(oif)[1]-3,4)
		
	oif.db=data.frame(
		pos=as.numeric(substring(oif[oif.s,],1,pos.digits))
		,oif=as.numeric(substring(oif[oif.s,],2+pos.digits,1+pos.digits+oif.digits))
		,oif.z.scan.delay.s=as.numeric(substring(oif[oif.s+2,],13,nchar(oif[oif.s+2,])))/1000
	)
	
	tmp<-join(subset(X$data,select=c(pos,oif)),oif.db,by=c("pos","oif"))
	tmp<-subset(tmp,select=c(-pos,-oif))
	X$data<-cbind(X$data,tmp)
	X$variables$merged<-union(X$variables$merged,names(tmp))
	X$variables$all<-union(X$variables$all,names(tmp))
	
	X$oif.interval<-oif.db #agrego esta table al objeto cell.data

	return(X)
}

#removes usually unused variables
CELLID_UNUSED_VARS=c("time","rot.vol","con.vol","a.tot.p1","a.tot.m1","a.tot.m2","a.tot.m3"
					,"a.local.bg","a.local","a.local.bg2","a.local2","a.surf","sphere.vol"
					,"a.p1","a.m0","a.m1","a.m2","f.tot.p1.y","f.tot.m1.y","f.tot.m2.y"
					,"f.tot.m3.y","xpos.nucl.y","xpos.nucl.y")
					
