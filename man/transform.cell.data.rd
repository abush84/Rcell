\name{transform}
\alias{transform.cell.data}
\alias{transform.by}
\alias{transform.by.cell.data}
\alias{transform.by.data.frame}
\alias{transform.by.default}
\alias{transformBy}
\alias{transformBy.cell.data}
\alias{transformBy.data.frame}
\alias{transformBy.default}

\title{Transform a Cell Data Object}

\description{
 Transforms a cell.data object adding new variables
}
\usage{

\method{transform}{cell.data}(`_data`,...,QC.filter=TRUE)

transformBy(`_data`,.by,...)

\method{transformBy}{cell.data}(`_data`,.by,...,QC.filter=TRUE)

\method{transformBy}{data.frame}(`_data`,.by,...,subset=NULL)

\method{transformBy}{default}(`_data`,.by,...,subset=NULL)

}

\arguments{
  \item{_data}{ cell.data object or data.frame to transform }
  \item{.by}{variables to split data frame by, as quoted variable}
  \item{\dots}{new variable definition in the form \code{tag=value}}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
  \item{subset}{logical expression indicating elements or rows to keep: missing values are taken as false. Only valid for \code{data.frame}s, not for \code{cell.data}}
}

\details{

	NOTE: \code{transform.by} had to be removed from the package. Use \code{transformBy} instead. 

  Read the transform vignette for a tutorial on the use of these functions
  \Sexpr[eval=FALSE,echo=TRUE,results=verbatim]{vignette('transform')}

  \code{transform.cell.data} is the implementation of the generic function \code{\link{transform}} to cell.data objects. It creates the new variables based on the \code{\dots} argument; a tagged vector expressions, which are evaluated in the dataset. 
  
  \code{transformBy} is a generic function. Before transforming the dataset, the function splits it by the variables specified in the \code{.by} argument. This argument should be a quoted list of variables, that can be easily created with the \code{\link{quoted}} function, for example \code{.(pos,t.frame)}. This can be useful to do group-wise normalizations.
  
  The transformed variables are summarized in the output of \code{\link{summary.cell.data}}.

 }
\value{
 for transform(By).cell.data a transformed cell.data object 
 
 for transformBy.data.frame a transformed data.frame
}
\author{ Alan Bush }
\seealso{ \code{\link{transform}} }
\examples{
#load example dataset
data(ACL394filtered)

#creating a new variable
X<-transform(X,f.total.y=f.tot.y-a.tot*f.local.bg.y)

#create a new variable normalizing by position
X<-transformBy(X,.(pos),norm.f.total.y=f.total.y/mean(f.total.y))

#create a new delta variable in sigle cells
X<-transformBy(X,.(pos,cellID),delta.f.total.y=f.total.y-f.total.y[t.frame==0])

#transformBy can also be used on a data.frame
df<-aggregate(X,f.total.y~t.frame+pos) #creates a aggregate data.frame from X
df<-transformBy(df,.(pos),delta.f.total.y=f.total.y-f.total.y[t.frame==0])

}
\keyword{manip}
\keyword{methods}

