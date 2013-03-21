pkgname <- "Rcell"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('Rcell')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("QC.filter")
### * QC.filter

flush(stderr()); flush(stdout())

### Name: QC.filter
### Title: Quality Control Filter
### Aliases: QC.filter QC.reset QC.undo QC.execute
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394filtered)

#resetting all the filters
X<-QC.reset(X)

#filtering by fft.stat
cplot(X,~fft.stat) #see what cut to use
X<-QC.filter(X,fft.stat < 0.5) #apply the cut

#filtering by the total number of frames in which a cell appears
cplot(X,cellID~t.frame,fill=f.tot.y,geom="tile",facets=~pos) 
X<-update_n.tot(X) #updating n.tot variable
cplot(X,~n.tot) #define where to apply the cut
X<-QC.filter(X,n.tot==14) #keep cells that appear in all t.frames

#exclude cells by ucid (Unique Cell ID)
cplot(X,f.total.y~time.min,facets=~AF.nM,size=0.3,geom="jitter") 
#selecting cells that don't respond
c1=select.cells(X,f.total.y<10e4&t.frame>3,n.tot.subset=n.tot>=8)	
X<-QC.filter(X,!ucid %in% c1)

#undoing the last filter
X<-QC.undo(X)




cleanEx()
nameEx("aggregate.cell.data")
### * aggregate.cell.data

flush(stderr()); flush(stdout())

### Name: aggregate
### Title: Compute Summary Statistics of Cell Data Subsets
### Aliases: aggregate.cell.data
### Keywords: manip methods

### ** Examples

#load example dataset
data(ACL394)

#aggregate by pos and calculate mean f.tot.y
aggregate(X,.(pos),select="f.tot.y")

#do the same aggregation using the formula notation
aggregate(X,f.tot.y~pos)

#aggregate by pos and t.frame
aggregate(X,.(pos,t.frame),select="f.tot.y")
aggregate(X,f.tot.y~pos+t.frame) #formula notation

#aggregate several variables
aggregate(X,.(pos),select="f.tot.?") # using wildcard pattern matching
aggregate(X,cbind(f.tot.y,f.tot.c)~pos) #formula notation

#subset before aggregating
aggregate(X,.(pos),select="f.tot.y",subset=t.frame==13)

#calculate the median instead of the mean
aggregate(X,.(pos),select="f.tot.y",FUN=median)

#dont apply the QC filter to the daset before aggregation
aggregate(X,.(pos),select="f.tot.y",QC.filter=FALSE)




cleanEx()
nameEx("append")
### * append

flush(stderr()); flush(stdout())

### Name: append
### Title: Append Variables
### Aliases: append.in.focus append.z.scan append.anular.y append.anular.r
###   append.anular.c append.memRec.y append.memRec.r
### Keywords: manip

### ** Examples

## Not run: 
##D X<-append.anular.y(X)
##D X<-append.memRec.y(X)
##D X<-append.z.scan(X)
##D X<-append.in.focus(X,"f.obs.y")
## End(Not run)



cleanEx()
nameEx("append.oif")
### * append.oif

flush(stderr()); flush(stdout())

### Name: append.oif
### Title: Append Variables from OIF files
### Aliases: append.oif.time append.oif.interval OIF
### Keywords: manip

### ** Examples

## Not run: 
##D X<-append.oif.time(X)
## End(Not run)



cleanEx()
nameEx("as.cell.data")
### * as.cell.data

flush(stderr()); flush(stdout())

### Name: as.cell.data
### Title: Coerce to Cell Data
### Aliases: as.cell.data as.cell.data.list is.cell.data
### Keywords: manip methods

### ** Examples

#load example dataset
data(ACL394)

#transforming dataset to list
Xlist<-as.list(X);class(Xlist)<-"list";

#re-coerce to cell.data
Y<-as.cell.data(Xlist)



cleanEx()
nameEx("as.data.frame.cell.data")
### * as.data.frame.cell.data

flush(stderr()); flush(stdout())

### Name: as.data.frame
### Title: Coerce to a Data Frame
### Aliases: as.data.frame.cell.data Extract.cell.data [[.cell.data cdata
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#extract the dataset to a data.frame
df<-as.data.frame(X)
df<-X[[]]

#extract a subset of the data.frame
df<-X[[t.frame==13,]]

#extract a selected group of variables
df<-X[[,c("id.vars","f.tot.?","a.tot")]]
#note the use of keywords, patterns and variable names

#extract the dataset without applying the QC filter
df<-cdata(X,QC.filter=FALSE)




cleanEx()
nameEx("cell.counter")
### * cell.counter

flush(stderr()); flush(stdout())

### Name: cell.counter
### Title: Map Cell Counter Tags to Cells
### Aliases: cell.counter cardinality.plot map.cells.points
### Keywords: manip

### ** Examples

#load the example dataset
data(ACL394)

#pos1.cell.counter is a cell counter output file for position 1
str(pos1.cell.counter)

#plotting cardinality
cardinality.plot(X,pos1.cell.counter,pos=1)

#do the mapping
X<-map.cells.points(X,pos1.cell.counter,pos=1,radius=10,var.name="cell.type")

#use the new variable for plotting
cplot(X,f.tot.y~t.frame,color=cell.type,subset=pos==1)




cleanEx()
nameEx("cell.hclust")
### * cell.hclust

flush(stderr()); flush(stdout())

### Name: cell.hclust
### Title: Hierarchical Clustering of Cell Data
### Aliases: cell.hclust chclust
### Keywords: cluster hplot

### ** Examples

  
if(require(hopach,quietly=TRUE)){  #suggested package hopach required for this function
  #load example dataset 
  #warning: Any object named 'X' will be replaced
  data(ACL394filtered)

  #Heriarchical clustering of cells by f.tot.y time course, 
  #using cosangle (uncentered correlation) metric and average linkage method.
  cell.hclust(X,"f.tot.y")

  #Heriarchical clustering of cells by f.tot.y time course, 
  #using euclid metric and complete linkage method.
  cell.hclust(X,"f.tot.y",metric="euclid",method="complete")

  #Cut the tree at constant height and show the clusters
  cell.hclust(X,"f.tot.y",cutree="height",cutree.args=list(h=0.005))

  #redefining the formula, plot against time in minutes
  X<-transform(X,time.min=10+t.frame*15) #calculating the time of each t.frame
  cell.hclust(X,"f.tot.y",formula=ucid~variable+time.min)
}



cleanEx()
nameEx("cimage")
### * cimage

flush(stderr()); flush(stdout())

### Name: cimage
### Title: Images Layout
### Aliases: cimage cimage.cell.image cimage.cell.data cimage.default
### Keywords: manip methods

### ** Examples


if(interactive()&require(EBImage,quietly=TRUE)){
	#load example dataset
	data(ACL394filtered)
  
	#display timecourse strip of cell 5 of pos 29, channels BF and YFP
	cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'))

	#display 7 cells (default value for N) of pos 29
	cimage(X,...+channel~t.frame,subset=pos==29,channel=c('BF','YFP'))

	#display 3 cells from each pos in a different facet
	cimage(X,channel~...,facets=~pos,channel=c('BF.out','YFP'),N=3,
		subset=t.frame==11&match(pos,c(1,8,15,22,29),nomatch=0)>0)

	#select one BF and many YFP images
	cimage(X,...~channel+t.frame,subset=pos==29,N=3,
		channel.subset=channel=='YFP'|(channel=='BF.out'&t.frame==11))
}




cleanEx()
nameEx("cplot")
### * cplot

flush(stderr()); flush(stdout())

### Name: cplot
### Title: Plotting Cell Data Objects
### Aliases: cplot cplotmean cplotmeans cplotmedian clayer clayermean
###   clayermeans clayermedian plot.cell.data
### Keywords: hplot aplot

### ** Examples

#load example dataset
data(ACL394)

#plotting YFP vs CFP fluorescence
cplot(X,f.tot.y~f.tot.c)

#reduce point size (and alpha blending) to eliminating overplotting
cplot(X,f.tot.y~f.tot.c,size=0.5) #add alpha=0.3 for 30% transparency

#subset the data before plotting
cplot(X,f.tot.y~f.tot.c,subset=t.frame==13)

#color by pos variable
cplot(X,f.tot.y~f.tot.c,subset=t.frame==13,color=pos)

#map the size aesthetic to the the cell area a.tot
cplot(X,f.tot.y~f.tot.c,subset=t.frame==13,color=pos,size=a.tot)

#adding description of the positions for futher plotting 
#	(AF.nM: dose of alpha-factor yeast pheromone in nM)
X<-merge(X,data.frame(pos=1:35,AF.nM=rep(c(1.25,2.5,5,10,20),each=7)))

#plot time course for f.tot.y and facet by pheromone dose
cplot(X,f.tot.y~t.frame,facets=~AF.nM)

#jittering the points to reduce overplotting
cplot(X,f.tot.y~t.frame,facets=~AF.nM,size=0.5,geom="jitter")

#adding per t.frame mean to prevoius plot
cplot(X,f.tot.y~t.frame,facets=~AF.nM,size=0.5,geom="jitter")+
  clayermean(color="red")

#plot means for each dose in the same plot
cplotmean(X,f.tot.y~t.frame,color=AF.nM,as.factor="AF.nM",yzoom=c(0,6.2e6))

#plotting histograms
cplot(X,~f.tot.y)

#map fill aesthetic to AF.nM variable coerced as factor
cplot(X,~f.tot.y,fill=AF.nM,as.factor="AF.nM")

#use position 'dodge' instead of 'stack'
cplot(X,~f.tot.y,fill=AF.nM,as.factor="AF.nM",position="dodge")




cleanEx()
nameEx("get.cell.image")
### * get.cell.image

flush(stderr()); flush(stdout())

### Name: cell.image
### Title: Get Cells Images
### Aliases: cell.image get.cell.image get.cell.image.cell.data
###   get.cell.image.data.frame get.cell.image.default summary.cell.image
###   print.summary.cell.image print.cell.image img.desc is.cell.image
### Keywords: manip methods

### ** Examples


if(interactive()&require(EBImage,quietly=TRUE)){
  #load example dataset
  data(ACL394filtered)
  
  #select N=3 cells images from each pos (group), 
  #from the first t.frame and pos 1,8,15,22,29.
  ci<-get.cell.image(X,subset=match(pos,c(1,8,15,22,29),nomatch=0)>0&t.frame==11,
    group=.(pos),N=3,channel=c('BF.out','YFP'))
  print(ci) #print the cells images
  summary(ci) #get a summary of the content
  img.desc(ci) #get the image description data.frame

  #select the first 4 t.frames for YFP, and the first t.frame for BF
  ci<-get.cell.image(X,subset=pos==29,group='pos',
    channel.subset=channel=='YFP'|(t.frame==11&channel=='BF'))
  print(ci)
}




cleanEx()
nameEx("ggplot2.themes")
### * ggplot2.themes

flush(stderr()); flush(stdout())

### Name: ggplot2.themes
### Title: ggplot2 themes
### Aliases: ggplot2.themes ggplot2.theme ggplot.themes ggplot.theme
###   theme_minimal theme_minimal_cb theme_minimal_cb_L theme_minimal_light
###   theme_fullframe theme_black theme_complete_bw theme_invisible
### Keywords: manip

### ** Examples


#themes for ggplot2 version 0.9.1 or lower
if (as.numeric_version(utils::packageVersion("ggplot2"))< as.numeric_version("0.9.2")) {

	#creating example datset
	mdf <- data.frame(x <- seq(0, 10), y=rnorm(x), 
                   f=factor(rep(letters[1:2], each=3, length=length(x))))
	#base plot
	p <- qplot(x, y, data=mdf, colour=f, geom=c("line", "point")) 

	#compare themes
	p + theme_grey() + opts(title="theme_grey()")
	p + theme_bw() + opts(title="theme_bw()")
	p + theme_minimal() + opts(title="theme_minimal()")
	p + theme_minimal_cb() + opts(title="theme_minimal_cb()")
	p + theme_minimal_cb_L() + opts(title="theme_minimal_cb_L()")
	p + theme_minimal_light() + opts(title="theme_minimal_light()")
	p + theme_fullframe() + opts(title="theme_fullframe()")
	p + theme_black() + opts(title="theme_black()",plot.title = theme_text(colour = "white",size=14))
	p + theme_complete_bw() + opts(title="theme_complete_bw()")
	p + theme_invisible() + opts(title="theme_invisible()")
}



cleanEx()
nameEx("load.cellID.data")
### * load.cellID.data

flush(stderr()); flush(stdout())

### Name: load.cellID.data
### Title: Load Cell-ID Data
### Aliases: load.cellID.data load.cell.data
### Keywords: IO manip

### ** Examples

## Not run: 
##D setwd(".")  #set the working directory to the folder with your images
##D X<-load.cellID.data()  #load the dataset to R
##D 
## End(Not run)



cleanEx()
nameEx("merge.cell.data")
### * merge.cell.data

flush(stderr()); flush(stdout())

### Name: merge
### Title: Merge a Data Frame to a Cell Data Object
### Aliases: merge.cell.data load.pdata
### Keywords: IO methods

### ** Examples

#load example dataset
data(ACL394)
#creating data frame with information about each poistion
#AF.nM: dose of alpha-factor yeast pheromone in nM
pdata<-data.frame(pos=1:35,AF.nM=rep(c(1.25,2.5,5,10,20),each=7))

#merging the data frame with the cell.data object
X<-merge(X,pdata)




cleanEx()
nameEx("misc")
### * misc

flush(stderr()); flush(stdout())

### Name: misc
### Title: Miscellaneous Functions
### Aliases: misc paste_data_error paste_parameter paste_intercept_slope
###   paste_EC50_n vplayout
### Keywords: manip

### ** Examples

paste_data_error(1.0,0.01)

#put several figures in a page
data(ACL394)
grid.newpage() #create a new plot
pushViewport(viewport(layout = grid.layout(1, 2))) #define the grid for the plots
print(cplot(X,f.tot.y~pos), vp = vplayout(1, 1))
print(cplot(X,f.tot.y~a.tot,color=pos), vp = vplayout(1, 2))




cleanEx()
nameEx("plot.Image")
### * plot.Image

flush(stderr()); flush(stdout())

### Name: plot.Image
### Title: Plot Image
### Aliases: plot.Image
### Keywords: manip methods

### ** Examples


if(interactive()&require(EBImage,quietly=TRUE)){

  #load example dataset
  data(ACL394filtered)
  
  #timecourse strip of cell 5 of pos 29, channels BF and YFP
  img<-cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'),display=FALSE)
  plot(img)	

}




cleanEx()
nameEx("reshape.cell.data")
### * reshape.cell.data

flush(stderr()); flush(stdout())

### Name: reshape.cell.data
### Title: Reshape a Cell Data Object
### Aliases: reshape.cell.data reshape creshape
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#rehape position 1 in pos + cellID ~ variable + t.frame for f.tot.y variable
reshape(X,select="f.tot.y",subset=pos==1)

#redefining the formula, reshape against time in minutes
X<-transform(X,time.min=10+t.frame*15) #calculating the time of each t.frame
reshape(X,pos+cellID~variable+time.min,select="f.tot.y",subset=pos==1&t.frame<10)




cleanEx()
nameEx("select.cells")
### * select.cells

flush(stderr()); flush(stdout())

### Name: select.cells
### Title: Select Subset of Cells
### Aliases: select.cells
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#select cells that have f.tot.y>1e7 in at least one t.frame
c1<-select.cells(X,f.tot.y>1e7)
cplot(X,f.tot.y~t.frame,color="gray",size=0.5) +  #plotting the cells
  clayer(X,f.tot.y~t.frame,color=ucid,geom="line",subset=ucid%in%c1)

#select cells that have f.tot.y<6e5 in all t.frames
c1<-select.cells(X,f.tot.y<6e5,n.tot.subset=n.tot==14)  
cplot(X,f.tot.y~t.frame,color="gray",size=0.5) +  #plotting the cells
  clayer(X,f.tot.y~t.frame,color=ucid,geom="line",subset=ucid%in%c1)




cleanEx()
nameEx("select.vars")
### * select.vars

flush(stderr()); flush(stdout())

### Name: select.vars
### Title: Select Variables
### Aliases: select.vars
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#select all variables
select.vars(X)

#select morphological variables
select.vars(X,"morpho")

#select variables of the YFP channel
select.vars(X,"*.y")

#select id vars, area vars and f.tot.y
select.vars(X,c("id.vars","a.*","f.tot.y"))

#select id vars, area vars and f.tot.y, exlude bg variables
select.vars(X,c("id.vars","a.*","f.tot.y"),exclude="*bg*")



cleanEx()
nameEx("show.img")
### * show.img

flush(stderr()); flush(stdout())

### Name: show.img
### Title: Show a Image
### Aliases: show.img show.image
### Keywords: manip methods

### ** Examples


if(interactive()&require(EBImage,quietly=TRUE)){
  #load example dataset
  data(ACL394filtered)
  
  #display the BF out image from position 8 and t.frame 11
  show.img(X,pos=8,t.frame=11)

  #display a stack of the YFP images of position 29
  show.img(X,pos=29,t.frame=7:11,channel="YFP")
}




cleanEx()
nameEx("stat_bootstrap")
### * stat_bootstrap

flush(stderr()); flush(stdout())

### Name: stat_bootstrap
### Title: Calculate bootstraps confidence intervals of a time course
### Aliases: stat_bootstrap StatBootstrap

### ** Examples


#load example dataset
data(ACL394)

#plotting time courses for position 15
cplot(X,f.tot.y~t.frame,subset=pos==15,geom="line",group=ucid)

#using stat summary ignores the fact that the same cells are sampled at different times
cplot(X,f.tot.y~t.frame,subset=pos==15,stat="summary",fun.data="mean_cl_boot"
	,geom=c("point","errorbar","line"))

#the stat bootstrap samples cells, and therefore the lack of independece is taken into account.
#note that there can be no missing data for this to work. You can check this with the n.tot variable.
X<-update_n.tot(X)
cplot(X,f.tot.y~t.frame,subset=pos==15&n.tot==14,stat="bootstrap"
	,geom=c("point","errorbar","line"),sample=ucid,group=pos)




cleanEx()
nameEx("stat_interactionError")
### * stat_interactionError

flush(stderr()); flush(stdout())

### Name: stat_interactionError
### Title: Calculate summary statistic after correcting for the 'sample
###   effect'.
### Aliases: stat_interactionError StatInteractionError

### ** Examples


#load example dataset
data(ACL394)

#plotting time courses for position 15
cplot(X,f.tot.y~t.frame,subset=pos==15,geom="line",group=ucid)

#using stat summary ignores the fact that the same cells are sampled at different times
cplot(X,f.tot.y~t.frame,subset=pos==15,stat="summary",fun.data="mean_cl_normal"
	,geom=c("point","errorbar","line"))

#the interactioError stat eliminates the 'cell effect' before calculating the confidence
#intervals. This works better if there are no missing values. Check for this with n.tot.
X<-update_n.tot(X)
cplot(X,f.tot.y~t.frame,subset=pos==15&n.tot==14
	,stat="interactionError",fun.data="mean_cl_normal"
	,geom=c("point","errorbar","line"),sample=ucid,group=pos)




cleanEx()
nameEx("stat_summaryGroup")
### * stat_summaryGroup

flush(stderr()); flush(stdout())

### Name: stat_summaryGroup
### Title: Summarise y and x values according to user defined groups.
### Aliases: stat_summaryGroup StatSummaryGroup

### ** Examples


#load example dataset
data(ACL394)

#plotting all points of t.frame 12
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12)

#using stat summary groups by x position, that makes no sense.
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summary",fun.y=mean)

#stat summaryGroup groups by pos in this example
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,fun.y=mean,fun.x=mean)

#errorbars can be added with the fun.ymin, fun.ymax, fun.xmin and fun.xmax arguments.
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,geom=c("point","errorbar","errorbarh")
	,fun.y=mean,fun.x=mean
	,fun.ymax=function(x)mean(x)+sd(x),fun.ymin=function(x)mean(x)-sd(x)
	,fun.xmax=function(x)mean(x)+sd(x),fun.xmin=function(x)mean(x)-sd(x))

#use the fun.data for common summary functions
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,geom=c("point","errorbar","errorbarh")
	,fun.data="mean_cl_normal")





cleanEx()
nameEx("subset.cell.data")
### * subset.cell.data

flush(stderr()); flush(stdout())

### Name: subset
### Title: Subset a Cell Data Objects
### Aliases: subset.cell.data [.cell.data remove.vars
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#subset the cell.data by pos
X1<-subset(X,pos==1)
X1<-X[pos==1]

#subset by t.frame and select variables
#note the use of keywords and pattern matching to select the variables
X.t13<-X[t.frame==13,c("morpho","*.y","f.tot.c")]
summary(X.t13) #take a look at the new cell.data object

#eliminate registers that didn't pass the QC filter
X<-subset(X,QC.filter=TRUE)




cleanEx()
nameEx("summary.cell.data")
### * summary.cell.data

flush(stderr()); flush(stdout())

### Name: summary
### Title: Cell Data Object Summary
### Aliases: summary.cell.data
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#see the object summary
summary(X)

#assign the object summary
X.sum<-summary(X)
names(X.sum)



cleanEx()
nameEx("transform.cell.data")
### * transform.cell.data

flush(stderr()); flush(stdout())

### Name: transform
### Title: Transform a Cell Data Object
### Aliases: transform.cell.data transform.by transform.by.cell.data
###   transform.by.data.frame transform.by.default transformBy
###   transformBy.cell.data transformBy.data.frame transformBy.default
### Keywords: manip methods

### ** Examples

#load example dataset
data(ACL394filtered)

#creating a new variable
X<-transform(X,f.total.y=f.tot.y-a.tot*f.local.bg.y)

#create a new variable normalizing by position
X<-transformBy(X,.(pos),norm.f.total.y=f.total.y/mean(f.total.y))

#create a new delta variable in sigle cells
X<-transformBy(X,.(pos,cellID),delta.f.total.y=f.total.y-f.total.y[t.frame==0])

#transformBy can also be used on a data.frame
df<-aggregate(X,f.total.y~t.frame+pos) #creates a aggregate data.frame from X
df<-transformBy(df,.(pos),delta.f.total.y=f.total.y-f.total.y[t.frame==0])




cleanEx()
nameEx("transform.cell.image")
### * transform.cell.image

flush(stderr()); flush(stdout())

### Name: transform.cell.image.rd
### Title: Transform Cell Image
### Aliases: cnormalize ciciply add.nucleus.boundary add.maj.min.axis
### Keywords: manip methods

### ** Examples


if(require(EBImage,quietly=TRUE)){ #suggested package EBImage required for these functions
  #load example dataset
  data(ACL394)

  #select N=3 cells images from each pos (group), 
  #from the first t.frame and pos 1,8,15,22,29.
  ci<-get.cell.image(X,subset=match(pos,c(1,8,15,22,29),nomatch=0)>0&t.frame==11,
  	group=.(pos),N=3,channel=c('BF','YFP'))
  
  #display a cell image without normalization
  if(interactive()) display(tile(combine(ci))) 
  
  ci<-cnormalize(ci) #apply normalization
  if(interactive()) display(tile(combine(ci))) #display again
}



cleanEx()
nameEx("update_img.path")
### * update_img.path

flush(stderr()); flush(stdout())

### Name: update_img.path
### Title: Update Image Path
### Aliases: update_img.path
### Keywords: manip

### ** Examples

## Not run: 
##D #load example dataset 
##D data(ACL394data)
##D summary(X)
##D 
##D #the default path has to be updated
##D new.path<-system.file('img', package='Rcell')
##D X<-update_img.path(X,new.path)
##D #a warning is issued because not all images were found
##D #(not all images are included in the package to reduce the package size)
##D 
##D #cimage can now find the images
##D cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'))
## End(Not run)



cleanEx()
nameEx("update_n.tot")
### * update_n.tot

flush(stderr()); flush(stdout())

### Name: update_n.tot
### Title: Calculate Total Number of Frames for Each Cell
### Aliases: update_n.tot update.n.tot
### Keywords: manip

### ** Examples

#load example dataset
data(ACL394)

#update n.tot variable
X<-update_n.tot(X)

#this command is equivalent to
X<-transformBy(X,.(ucid), n.tot=length(t.frame))




cleanEx()
nameEx("with.cell.data")
### * with.cell.data

flush(stderr()); flush(stdout())

### Name: with
### Title: Evaluates an Expression in a Cell Data Object.
### Aliases: with.cell.data
### Keywords: data

### ** Examples

#load example dataset
data(ACL394)

#calculate the mean f.tot.y from pos 2
with(X,mean(f.tot.y[pos==2]))

#use base plotting
with(X,plot(f.tot.y~f.tot.c))



cleanEx()
nameEx("zoom")
### * zoom

flush(stderr()); flush(stdout())

### Name: zoom
### Title: Zoom in a ggplot Object
### Aliases: zoom caxis xzoom yzoom
### Keywords: aplot

### ** Examples

#load example dataset
data(ACL394)

#zoom in the y axis
cplotmeans(X,f.tot.y~t.frame,color=pos) + zoom(y=c(0,7e6))

#define plotting region and ticks
cplotmeans(X,f.tot.y~t.frame,color=pos) + caxis(y=c(0,7e6),x=c(0,13),nx=14,expand.x=c(-.75,.75))



### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
