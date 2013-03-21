\name{transform.cell.image.rd}
\alias{cnormalize}
\alias{ciciply}
\alias{add.nucleus.boundary}
\alias{add.maj.min.axis}

\title{Transform Cell Image}

\description{funcionts that transforms a cell image object before plotting}
\usage{

cnormalize(X=NULL,normalize.group=c("channel"),...)

ciciply(X=NULL,group=c("pos","cellID","channel"),FUN=sum,MARGIN=c(1,2),warn=TRUE)

add.nucleus.boundary(X=NULL,radii=c(2,3,4,5,6,7),pos.nucl.channel="YFP",col=0.75,...)

add.maj.min.axis(X=NULL,col=0.75,angle.var=NA,...)

}

\arguments{
  \item{X}{cell.image object to transform}
  \item{normalize.group}{character vector indicating which variables should be used to group the images for normalization}
  \item{\dots}{further arguments for methods}
  \item{group}{character vector indicating which variables should be used to group the images before applying FUN}
  \item{FUN}{function to apply to the grouped imaged matrix}
  \item{MARGIN}{a vector giving the subscripts which the function will be applied over. 1 indicates rows, 
  2 indicates columns, c(1, 2) indicates rows and columns.}
  \item{warn}{boolean indicating if warnings should be issued.}
  
  \item{radii}{radii of the concentric circles to be plot around the nucleus found position. 
  The defaults correspond to Cell-ID default values}
  \item{pos.nucl.channel}{string indicating channel from which the nucleus coordinates should be extracted}
  \item{col}{color to use for the nucleus boundary}
  
  \item{angle.var}{string indicating variable that measures the angle between the major axis and a horizontal 
  line (not calculated by Cell-ID)}
 
}
\details{

	All these functions take a cell.image object as their first argument, and return a modified cell.image object. 
	In combination with \code{get.cell.image} and \code{cimage.cell.image} they can be used to do custom manipulation to the cell's images.

  \code{cnormalize} is called from \code{\link{cimage}} to normalize the images before plotting. It normalizes the images to enhance contrast. The normalization groups (defined by \code{normalize.group}) are applied the same normalization, so the intensities can be compared within a group.

	\code{ciciply} is inspired on the plyr package. It divides the cell.image object into groups defined by the \code{group} argument, combines the images within a group in a stack (or array) and applyies the \code{FUN} function, over the defined margins. For example if FUN=sum and MARGIN=c(1,2), several images are add up together. This can be used to create Z-projections.  

	\code{add.nucleus.boundary} and \code{add.maj.min.axis} overlay the nucleous boundary and the major and minor axis respectively on the cell's images.

  if \code{X} is NULL, the funcion returns a character indicating with variables of the dataset it requires.
      
 }
\value{
  The transformed cell.image object
}
\author{ Alan Bush }
\seealso{\code{\link{cimage}}}
\examples{

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
}
\keyword{manip}
\keyword{methods}

