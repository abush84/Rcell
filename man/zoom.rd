\name{zoom}
\alias{zoom}
\alias{caxis}
\alias{xzoom}
\alias{yzoom}
\title{ Zoom in a ggplot Object }
\description{
  Sets the plotting region and axes breaks for a ggplot object
}
\usage{

zoom(xzoom=c(NA,NA),yzoom=c(NA,NA),expand.y=c(0,0),expand.x=c(0,0),nx.breaks=n.breaks
		,ny.breaks=n.breaks,n.breaks=7,...)
caxis(xzoom=c(NA,NA),yzoom=c(NA,NA),expand.y=c(0,0),expand.x=c(0,0),nx.breaks=n.breaks
		,ny.breaks=n.breaks,n.breaks=7,...)
xzoom(xzoom=c(NA,NA),nx.breaks=7,...)
yzoom(yzoom=c(NA,NA),ny.breaks=7,...)

}
\arguments{
  \item{xzoom}{numeric vector. If length=2 it specifies the range of the x axis, if length>2 it gives the braks to be used.}
  \item{yzoom}{numeric vector. If length=2 it specifies the range of the x axis, if length>2 it gives the braks to be used.}
  \item{expand.x}{numeric vector of length two, with x axis additive expansion. Note the first element is usually negative. This expansion does not modify the position of the ticks.}	
  \item{expand.y}{idem for y axis}	
  \item{nx.breaks}{number of breaks for the x axis}
  \item{ny.breaks}{number of breaks for the y axis}
  \item{n.breaks}{number of breaks for both axes, if not specified by nx.breaks or ny.breaks}
  \item{\dots}{further arguments for \code{pretty} or \code{scale_continuous}}
}

\details{

xzoom and yzoom are convenient functions to specify only one of the limits. 

}
\value{
  a layer to be added to a ggplot object, that specifies the plotting region after the statistical transformations have been done. 
}
\note{A zoom function exists in Hmisc package. Use \code{Rcell::zoom} or \code{caxis} if both package namespaces are loaded.}
\author{ Alan Bush}
\seealso{\code{\link{cplot}},\code{\link{limits}}}
\examples{
#load example dataset
data(ACL394)

#zoom in the y axis
cplotmeans(X,f.tot.y~t.frame,color=pos) + zoom(y=c(0,7e6))

#define plotting region and ticks
cplotmeans(X,f.tot.y~t.frame,color=pos) + caxis(y=c(0,7e6),x=c(0,13),nx=14,expand.x=c(-.75,.75))
}
\keyword{aplot}