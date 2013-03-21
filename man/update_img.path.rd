\name{update_img.path}
\alias{update_img.path}
\title{ Update Image Path }
\description{
Updates the path to the images folder. Useful if the images are in a different location from the one they were run by Cell-ID. 
}
\usage{
update_img.path(X,img.path=getwd(),subset=NULL)
}

\arguments{
  \item{X}{cell.data object }
  \item{img.path}{character with the new path to the images}
  \item{subset}{conditional expression to update the paths of a subset of images}
}
\value{
  returns a cell.data object, with updated paths for the images
}
\author{Alan Bush}
\seealso{ \code{\link{cimage.cell.data}},\code{\link{img.desc}}}
\examples{
\dontrun{
#load example dataset 
data(ACL394data)
summary(X)

#the default path has to be updated
new.path<-system.file('img', package='Rcell')
X<-update_img.path(X,new.path)
#a warning is issued because not all images were found
#(not all images are included in the package to reduce the package size)

#cimage can now find the images
cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'))
}
}
\keyword{manip}