#*************************************************************************#
#public
#herarchical clustering of cell data and heatmap plot
#ToDo: use flashClust when available
#ToDo: provide an as.hclust and as.dist method?
#ToDo: add a RowSideColors argument
#ToDo: add labRow argument. Use variable name to create correct strign vector.
#ToDo: use heatmap.2 from gplots package when available
cell.hclust <- function(X,select
				,metric="cosangle",method="average"
				,plot="heatmap",main=NULL
				,heatmap.col=colorRampPalette(c("green", "black", "red"), space="rgb",bias=2)(128)
				,cutree="none",cutree.args=list(h=0.5),plot.dendrogram=cutree%in%c("height","cluster","clusters")
				,min.cluster.size=20,na.rm=FALSE
				,formula=ucid ~ variable + t.frame
				,subset=TRUE,exclude=NULL,QC.filter=TRUE
				,col.select=NULL,col.exclude=NULL
				,labRow=NA,...){
	
	non.creshape.args=c("plot","col.select","col.exclude","metric","method","main"
						,"heatmap.col","cutree","cutree.args","min.cluster.size")
	
	if(!require(hopach)) stop("hopach package required")
	
	args=as.list(match.call(expand.dots=FALSE))
	form=formals()
	args[[1]]<-NULL
	args$data<-args$X
	args$X<-NULL
	rd=do.call("creshape",c(args,form[setdiff(names(form),c(names(args),non.creshape.args))]))			

	rd<-colwise(as.numeric)(rd)
	#check if 1st term of formula is ucid
	row.names=intersect(all.names(formula[2]),X$variables$all)
	if(length(row.names)>1) stop("a single variable expected in the left term of the formula")
	matrix.rd=data.matrix(data.frame(subset.data.frame(rd,select=setdiff(names(rd),row.names)),row.names=rd[,row.names])) 
	col.select=.select(list(all=colnames(matrix.rd)),col.select,col.exclude)
	
	if(isTRUE(col.select)){ ColSideColors = as.character(rep(NA,ncol(matrix.rd)))
	} else {ColSideColors =ifelse(colnames(matrix.rd) %in% col.select,NA,"gray")}
	
	if(is.null(main)) main=paste(metric,"metric,",method,"cluster method,",cutree,"tree cut")
	
	dmx=.asMatrixHdist(distancematrix(subset.matrix(matrix.rd,select=col.select),d=metric))
	dimnames(dmx)<-list(dimnames(matrix.rd)[[1]],dimnames(matrix.rd)[[1]])
	dmx=as.dist(dmx)
	
	hcx=hclust(dmx,method)

	cell.subtree=data.frame()	
	if(cutree%in%c("height","cluster","clusters")){

		pdev=dev.cur()
		dev.new(width=5,height=5)
		plot(hcx,hang=-1)
		c1=do.call("rect.hclust",c(list(tree=hcx),cutree.args))
		if(!isTRUE(plot.dendrogram)) dev.off()
		dev.set(pdev)
	
		for(i in 1:length(c1))
			cell.subtree=rbind(cell.subtree,data.frame(cell=as.numeric(names(c1[[i]])),subtree=i))
		names(cell.subtree)<-c(row.names,"subtree")

		cell.subtree=transformBy(cell.subtree,.(subtree),subtree.n.cell=length(subtree))	
		cell.subtree=transform(cell.subtree
						,subtree.index=match(subtree,unique(subtree[subtree.n.cell>min.cluster.size])))	
		
		rsc=join(data.frame(ucid=rd[,row.names])	
			,subset.data.frame(cell.subtree,select=c(row.names,"subtree.index"))
			,by=row.names)
		
		if("heatmap" %in% plot)
			heatmap(matrix.rd ,Colv=NA, Rowv=as.dendrogram(hcx) 
				,col = heatmap.col ,main=main
				,RowSideColors=as.character(rsc[,"subtree.index"])
				,ColSideColors=ColSideColors,labRow=labRow,...)
	} else if(cutree=="dynamic") {
		stop("cutree='dynamic' not implemented yet")
	} else if(cutree=="hybrid") {	
		stop("cutree='hybrid' not implemented yet")
	} else if(cutree=="none") {	
	
		#browser()
	
		if("heatmap" %in% plot)
			heatmap(matrix.rd ,Colv=NA, Rowv=as.dendrogram(hcx) 
				,col = heatmap.col ,main=main
				,ColSideColors=ColSideColors,labRow=labRow,...)
	} else stop("unknown cutree method")
	
	chc=list(
		data=rd
		,matrix=matrix.rd
		,dist=dmx
		,hclust=hcx
		,cell.subtree=cell.subtree
	)
	
	return(invisible(chc))
}
chclust<-cell.hclust

#*************************************************************************#
#private
#workarround R bug http://r.789695.n4.nabble.com/importing-S4-methods-using-a-namespace-td1566732.html
#code from hopach package hDistClass.R
.asMatrixHdist<-function(from){
	size <- from@Size
	df <- matrix(0,size,size)
	df[row(df) > col(df)] <- from@Data
	df <- df + t(df)
	labels <- from@Labels
	dimnames(df) <- if(is.null(labels))
			list(1:size,1:size)
		else	
			list(labels,labels)
	return(df)
}
