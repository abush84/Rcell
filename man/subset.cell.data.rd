\name{subset}
\alias{subset.cell.data}
\alias{[.cell.data}
\alias{remove.vars}

\title{Subset a Cell Data Objects}

\description{
  Returns subset of the cell.data object which meet conditions
}
\usage{

\method{subset}{cell.data}(x,subset=TRUE,select="all",exclude=NULL,QC.filter=FALSE,...)

remove.vars(X,select,exclude=NULL)
}

\arguments{
  \item{x}{ cell.data object }
  \item{X}{ cell.data object }
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset¥s variable, that
  specifies which registers should be included}
  \item{select}{character vector defining variables names to be included in the returned cell.data}
  \item{exclude}{character vector defining variables names to be excluded from the returned cell.data}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data before creating the new cell.data object}
  \item{\dots}{further arguments passed to or used by methods}  
}


\details{
  \code{\link{subset}} is a generic function. This version applies to cell.data objects. \code{subset} is a close function, meaning it returns an object of the same class as its first argument, in this case a cell.data object. Subsetting is useful to divide a large experiment into smaller dataset that are more easily analyzed. It can also be used to reduce the memory space a cell.data object occupies, for example eliminating the QC filtered registers ( \code{X<-subset(X,QC.filter=TRUE)} ) or eliminating unused variables ( \code{X<-subset(X,exclude=c("morpho","f.bg.y","f.*.c"))})
 
 The bracket (\code{\link{Extract}}) notation can also be used \code{Y<-X[pos==1]}
 
 \code{remove.vars} is a wrapper over subset, it eliminates the specified variables. 
   
 A record of the subset history of the object is kept. Use \code{\link{summary.cell.data}} to see it.   
   
 }
\value{
  a subset cell.data object
}
\author{ Alan Bush }
\seealso{ \code{\link{subset}}, \code{\link{summary.cell.data}} }
\examples{
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

}
\keyword{manip}

