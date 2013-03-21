\name{as.data.frame}
\alias{as.data.frame.cell.data}
\alias{Extract.cell.data}
\alias{[[.cell.data}
\alias{cdata}

\title{Coerce to a Data Frame}

\description{
 Function for extracting a (subset) data.frame from a cell.data object
}
\usage{
\method{as.data.frame}{cell.data}(x,row.names=NULL,optional=FALSE,...,subset=TRUE
  ,select=NULL,exclude=NULL,QC.filter=TRUE,na.rm=FALSE)
 
 \method{[[}{cell.data}(x,subset=TRUE,select=NULL,exclude=NULL,QC.filter=TRUE,na.rm=TRUE,...)

 cdata(x,subset=TRUE,select=NULL,exclude=NULL,QC.filter=TRUE,na.rm=TRUE,...)

}

\arguments{
  \item{x}{ cell.data object }
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset?s variable, which 
  specifies which registers should be included in the returned data.frame}
  \item{select}{character vector defining variables names to be included in the returned data.frame}
  \item{exclude}{character vector defining variables names to be excluded from the returned data.frame}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
 	\item{na.rm}{boolean indicating if registers with NA should be removed from the data.frame}
 	\item{\dots}{further arguments passed to or used by methods}
  \item{row.names}{further arguments passed to or used by methods}
  \item{optional}{further arguments passed to or used by methods}

}


\details{
  as.data.frame.cell.data coerces a cell.data object to a data.frame, subsetting it as defined by the other arguments. This function will be called when the generic function \code{\link{as.data.frame}} is applied over a cell.data object.
 
 The extract ('[[') operator is an alias to this function. 

\code{select} and \code{exclude} can be used to choose which variables should be included in the returned data.frame. Wildcard patterns (e.g. 'f.*.y') 
and keywords (e.g. 'all', 'id.vars', 'YFP', etc.) can be used as components of these arguments. Use \code{\link{summary.cell.data}} to see available variables and keywords. Variable names starting with '-' in \code{select} will be excluded from the data.frame. 
 
 }
\value{
  A data.frame, subset as specified by the functions arguments.
}
\author{ Alan Bush }

\seealso{ \code{\link{as.data.frame}} }
\examples{
#load example dataset
data(ACL394)

#extract the dataset to a data.frame
df<-as.data.frame(X)
df<-X[[]]

#extract a subset of the data.frame
df<-X[[t.frame==13,]]

#extract a selected group of variables
df<-X[[,c("id.vars","f.tot.?","a.tot")]]
#note the use of keywords, patterns and variable names

#extract the dataset without applying the QC filter
df<-cdata(X,QC.filter=FALSE)

}
\keyword{manip}

