\name{with}
\alias{with.cell.data}
\title{Evaluates an Expression in a Cell Data Object.}
\description{
  Evaluate an R expression in an environment constructed from the cell.data object. 
}
\usage{
  \method{with}{cell.data}(data,expr,subset=TRUE,select=NULL,exclude=NULL,QC.filter=TRUE,...)
}

\arguments{
  \item{data}{ cell.data object}
  \item{expr}{expression to evaluate}
  \item{\dots}{arguments to be passed to future methods}
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset¥s variable, that
  specifies which registers should be included}
  \item{select}{character vector defining variables names to be included}
  \item{exclude}{character vector defining variables names to be excluded}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}

}
\details{
  \code{\link{with}} is a generic function. The version for cell.data objects is a wrapper over the version for data.frame, calling \code{\link{as.data.frame.cell.data}} with the specified arguments. 
}

\value{
   The value of the evaluated \code{expr}
}
\author{Alan Bush}
\seealso{ \code{\link{with}}}
\examples{
#load example dataset
data(ACL394)

#calculate the mean f.tot.y from pos 2
with(X,mean(f.tot.y[pos==2]))

#use base plotting
with(X,plot(f.tot.y~f.tot.c))
}
\keyword{data}
