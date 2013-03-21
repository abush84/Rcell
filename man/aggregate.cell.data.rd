\name{aggregate}
\alias{aggregate.cell.data}

\title{Compute Summary Statistics of Cell Data Subsets}

\description{
 Splits the data into subsets, computes summary statistics for each, and returns the result in a data frame
}
\usage{
\method{aggregate}{cell.data}(x, form.by, ..., FUN=mean, subset=TRUE, select=NULL
  ,exclude=NULL, QC.filter=TRUE)
}

\arguments{
  \item{x}{ cell.data object }
  \item{form.by}{either a formula or variables to split data frame by, as quoted variables or character vector}
  \item{\dots}{further arguments passed to or used by methods}
  \item{FUN}{a function to compute the summary statistics which can be applied to all data subsets}
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the datasets variable, that
  specifies which registers should be included}
  \item{select}{character vector defining variables names to be included in the returned data.frame}
  \item{exclude}{character vector defining variables names to be excluded from the returned data.frame}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
}


\details{
  \code{\link{aggregate}} is a generic function. This version applies to cell.data objects. Two notations are allowed. 
  If the second argument \code{form.by} is a formula it should be of the form
 \code{cbind(measure.var1,measure.var2)~group.var1+group.var2}
 Note that this notations differs from the one used by \code{\link{reshape.cell.data}}
  If the second argument \code{form.by} are quoted variables or a character vector with variable names, these variables are taken as group.vars to split the dataset. The measure variables over which to apply FUN should be selected using the \code{select} and \code{exclude} arguments.
 
 }
\value{
  a data frame with columns corresponding to the grouping variables followed by aggregated columns of the measure variables.
}
\author{ Alan Bush }
\seealso{ \code{\link{aggregate}} }
\examples{
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

}
\keyword{manip}
\keyword{methods}

