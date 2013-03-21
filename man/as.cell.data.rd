\name{as.cell.data}
\alias{as.cell.data}
\alias{as.cell.data.list}
\alias{is.cell.data}

\title{Coerce to Cell Data}

\description{
 Coerces a list or data.frame to a cell.data object 
}
\usage{

as.cell.data(X,...)

\method{as.cell.data}{list}(X,path.images=NULL,...)

is.cell.data(X)

}

\arguments{
  \item{X}{ list to be coerced to (or test for) cell.data object }
  \item{path.images}{ string containing path to the image files }
  \item{\dots}{	additional arguments to be passed to or from methods}
}


\details{
\code{as.cell.data} coerces objects to class cell.data. If a list is coerced, it is expected to have components 'data', 'bf.fl.mapping' and others. It is specially usefull to coerce data loaded with previous versions of Rcell. 
\code{is.cell.data} test if a object inherits from class cell.data 
 
\code{path} is used to update the path of the image files. 
 
}
\value{
 a cell.data object
}
\author{ Alan Bush }
\seealso{ \code{\link{load.cellID.data}} }
\examples{
#load example dataset
data(ACL394)

#transforming dataset to list
Xlist<-as.list(X);class(Xlist)<-"list";

#re-coerce to cell.data
Y<-as.cell.data(Xlist)
}

\keyword{manip}
\keyword{methods}

