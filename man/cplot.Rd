\name{cplot}
\alias{cplot}
\alias{cplotmean}
\alias{cplotmeans}
\alias{cplotmedian}
\alias{clayer}
\alias{clayermean}
\alias{clayermeans}
\alias{clayermedian}
\alias{plot.cell.data}

\title{ Plotting Cell Data Objects }

\description{
  Plotting functions for cell.data objects. These functions are wrappers over the functions of ggplot2 package. 
}

\usage{
cplot(X=NULL, x=NULL, subset = NULL, y=NULL, z=NULL, ... 
  ,facets = NULL, margins=FALSE, geom = "auto"
  ,stat=list(NULL), position=list(NULL), log = "", as.factor="as.factor"
  ,xlim = c(NA, NA), ylim = c(NA, NA), xzoom = c(NA,NA), yzoom = c(NA,NA)
  ,xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), asp = NA
  ,select = NULL, exclude = NULL, na.rm = TRUE, QC.filter = TRUE
  ,main = NULL, add = FALSE, layer = FALSE)

clayer(...,geom="auto") 

cplotmeans(...,geom=c("point","errorbar","line")) 

clayermeans(...,geom=c("point","errorbar","line"))

cplotmedian(...,geom=c("point","errorbar","line"))

clayermedian(...,geom=c("point","errorbar","line"))

\method{plot}{cell.data}(x,y,...)

}

\arguments{
  \item{X}{ cell.data object }
  \item{x}{ either a variable symbol or expression, or a formula of the form y~x or ~x}
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset?s variable, which 
  specifies which registers should be included in the plot}
  \item{y}{ a variable symbol or expression to be plot in the y axis. Ignored if x is a formula. A vector of symbols is allowed}
  \item{z}{ a variable symbol specifying the "z" aesthetic mapping }
  \item{\dots}{other arguments passed on to the geom functions}
  \item{facets}{faceting formula to use}
  \item{margins}{whether or not margins will be displayed}
  \item{geom}{geom to use (can be a vector of multiple names)}
  \item{stat}{statistic to use (can be a vector of multiple names)}
  \item{position}{position adjustment to use (can be a vector of multiple names)}
  \item{log}{	which variables to log transform ("x", "y", or "xy")}
  \item{as.factor}{variable names (wildcard pattern or keyword) to be treated as factors}
  \item{xlim}{limits for x axis c(min,max) (filters the x variable BEFORE applying the \code{stat} transformation)}
  \item{ylim}{limits for y axis c(min,max) (filters the y variable BEFORE applying the \code{stat} transformation)}
  \item{xzoom}{zoom range for x axis c(min,max) (resizes the plotting region AFTER the \code{stat} transformation)}
  \item{yzoom}{zoom range for y axis c(min,max) (resizes the plotting region AFTER the \code{stat} transformation)}
  \item{xlab}{character vector or expression for x axis label}
  \item{ylab}{character vector or expression for y axis label}
  \item{asp}{the y/x aspect ratio}
  \item{select}{character vector defining variables names to be included in the returned ggplot object, beside the ones required for the plot}
  \item{exclude}{character vector defining variables names to be excluded from the returned ggplot object}
  \item{na.rm}{boolean indicating if registers with NA should be removed from the data.frame}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data before plotting}
  \item{main}{character vector or expression for plot title}
  \item{add}{the plot is added as a layer to the last plot (returned by \code{\link{last_plot}})}
  \item{layer}{boolean. If TRUE a layer is returned instead of a new ggplot object. Mutually exclusive with \code{add}}
}


\details{

  Read the cplot vignette for a tutorial on how to use this function: vignette('cplot')

  cplot is a wrapper over the functions of ggplot2 package from Hadley Wickham. It is based on \code{\link{qplot}} and keeps many of its arguments. The main differences between cplot and qplot are the following:
\itemize{  
  \item cplot's first argument is a cell.data object (or a data.frame) 
  \item the 'x' and 'y' aesthetic mapping can be specified by a formula in cplot 
  \item a vector of variables can be specified for 'y' aesthetic mapping. This produces a data restructuring and sets the color aesthetic to variable 
  \item variables selected by \code{as.factors} are coerced to factors before plotting  
  \item the plotting region can be easily specified with xzoom and yzoom. Useful when stat='summary'.
  \item a subset of the dataset can be performed before plotting 
  \item only the required variables for the plot are included in the ggplot object, thus reducing the memory space it requires. Additional variables can be included with the \code{select} and \code{exclude} arguments. 
  \item if a logical QC variable is present in the dataset, it is used to filter it before plotting
  \item unused levels of factors can be drop with \code{droplevels} 
  \item the specified plot can be returned as a layer to add to other plots with the '+' operator 
}
  clayer is a wrapper for cplot with \code{layer}=TRUE. This function returns a layer that can be added to other ggplot objects with the '+' operator.
  
  cplotmeans (alias cplotmean) is a wrapper over cplot with \code{stat}='summary' and \code{fun.data}='mean_cl_normal'. This function plots the mean and confidence limits for the mean of the data, grouped by levels of the x variable. The default confidence interval is of 95\%, and can be modified with the \code{conf.int} argument (passed to \code{\link{smean.cl.normal}}).
  
  clayermeans (alias clayermean) is a wrapper over cplot with \code{stat}='summary', \code{fun.data}='mean_cl_normal' and  \code{layer}=TRUE. 

  cplotmedian (and clayermedian) is a wrapper over cplot with \code{stat}='summary', \code{fun.data}='median_hilow' and  \code{layer}=FALSE (TRUE). 
  
  plot.cell.data is a wrapper over cplot. It only accepts formula notation for the 'x' and 'y' aesthetics. It can be called by \code{plot} over a cell.data object.
  
}

\value{
  a ggplot object or a list specifying plots layers
}

\references{ 
H. Wickham. ggplot2: elegant graphics for data analysis. Springer New York, 2009.
}
\author{Alan Bush}
\seealso{ \code{\link{qplot}},\code{\link{ggplot}} }
\examples{
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

}
\keyword{ hplot }
\keyword{ aplot }
