\name{plot.Image}
\alias{plot.Image}

\title{Plot Image}

\description{
	Plots a EBImage Image to the active device
}
\usage{

\method{plot}{Image}(x,width=NULL,height=NULL,omi=1,interpolate=FALSE,vp=NULL,...)

}

\arguments{
  \item{x}{EBImage of class Image, as returned by cimage}
  \item{width}{the width in inches of the device. If width or height are NULL, both are replaced by the dimensions of the active device}
  \item{height}{the height in inches of the device. If width or height are NULL, both are replaced by the dimensions of the active device}
  \item{omi}{number between 0 and 1. Defines the outter margins. If set to 0.95, 5\% of the device in each side will be set as margin}
  \item{interpolate}{A logical value indicating whether to linearly interpolate the image}
  \item{vp}{A Grid viewport object (or NULL)}
  \item{\dots}{further arguments for \code{\link{grid.raster}}}
 }

\details{
  \code{plot.Image} is the S3 \code{\link{plot}} method for objects of class 'Image'. 
}
\value{
  none
}
\author{ Alan Bush }
\seealso{plot}
\examples{

if(interactive()&require(EBImage,quietly=TRUE)){

  #load example dataset
  data(ACL394filtered)
  
  #timecourse strip of cell 5 of pos 29, channels BF and YFP
  img<-cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'),display=FALSE)
  plot(img)	

}

}
\keyword{manip}
\keyword{methods}

