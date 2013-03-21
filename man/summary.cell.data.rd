\name{summary}
\alias{summary.cell.data}

\title{Cell Data Object Summary}

\description{
  Returns a summary of the cell.data object content.
}
\usage{

\method{summary}{cell.data}(object,...)

}

\arguments{
  \item{object}{ cell.data object }
  \item{\dots}{further arguments passed to or used by methods}    
}


\details{
 Returns a description of the cell.data object, including from where and when it was loaded, the number of positions and time frames and information about the default, transformed and merged variables. It also returns a history of the QC filters and subsets applied.

 The function returns a list of class summary.cell.data that is printed by print.summary.cell.data. 
}
\value{
  a list of class summary.cell.data
}
\author{ Alan Bush }
\seealso{\code{\link{summary}} }
\examples{
#load example dataset
data(ACL394)

#see the object summary
summary(X)

#assign the object summary
X.sum<-summary(X)
names(X.sum)
}
\keyword{manip}

