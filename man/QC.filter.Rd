\name{QC.filter}
\alias{QC.filter}
\alias{QC.reset}
\alias{QC.undo}
\alias{QC.execute}

\title{ Quality Control Filter }

\description{Create, undo, reset and execute quality control filters}

\usage{
QC.filter(X, filter, subset=NULL)

QC.undo(X)

QC.reset(X)

QC.execute(X)
}

\arguments{
  \item{X}{the cell.data object as returned by \code{\link{load.cellID.data}}
   make sure to save the object when it's returned by the function
   i.e. do the calls as X=QC.filter(X,...) )
  }
  \item{filter}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the datasetYens variable,
  that specifies which rows pass the quality control (TRUE), and which ones 
  don't (FALSE).
  }
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset variable, which 
  specifies over which registers \code{filter} should be applied.
  }
}
\details{
QC.filter function filters the cells based on a user define boolean vector filter Such vector can be obtained applying logical operations over the vectors (fft.stat<0.2, etc). The purpose of this filter is to eliminate from your dataset spurious, badly found, out of focus and dead cells. This filter is cumulative, meaning that each time one applies a QC.filter function it adds to the previous QC.filter, it does not replaced them. Many functions from 
the package have a \code{QC.filter} argument, that specifies if the created QC filter should be applied to the dataset before the function is executed.   
The filter treats the same cells in different time points independently. 
Don't use this function to select subgroups of cells (see \code{\link{select.cells}})
\code{\link{summary.cell.data}} returns a description of the applied filters.

QC.undo removes the last filter applied.
QC.reset eliminates all filters, restoring the cell.data object to its original state.
QC.execute permanently eliminates the filtered registers. This is recommended only if you have memory issues.
}
\value{
  Returns the cell.data with the specified filter applied.
}
\author{Alan Bush}
\note{ 
Some times it is useful to create additional filters to discriminate between cells. Dont use QC.filter for this. You can create a filter with \code{\link{transform.cell.data}} and use the \code{subset} argument of the function you want to apply. 
}
\seealso{ \code{\link{summary.cell.data}},\code{\link{transform.cell.data}},\code{\link{load.cellID.data}} }
\examples{
#load example dataset
data(ACL394filtered)

#resetting all the filters
X<-QC.reset(X)

#filtering by fft.stat
cplot(X,~fft.stat) #see what cut to use
X<-QC.filter(X,fft.stat < 0.5) #apply the cut

#filtering by the total number of frames in which a cell appears
cplot(X,cellID~t.frame,fill=f.tot.y,geom="tile",facets=~pos) 
X<-update_n.tot(X) #updating n.tot variable
cplot(X,~n.tot) #define where to apply the cut
X<-QC.filter(X,n.tot==14) #keep cells that appear in all t.frames

#exclude cells by ucid (Unique Cell ID)
cplot(X,f.total.y~time.min,facets=~AF.nM,size=0.3,geom="jitter") 
#selecting cells that don't respond
c1=select.cells(X,f.total.y<10e4&t.frame>3,n.tot.subset=n.tot>=8)	
X<-QC.filter(X,!ucid \%in\% c1)

#undoing the last filter
X<-QC.undo(X)

}
\keyword{manip}


