\name{merge}
\alias{merge.cell.data}
\alias{load.pdata}

\title{Merge a Data Frame to a Cell Data Object}

\description{
 Merges the variables in a data.frame to a cell.data object, using common variables to do the merging
}

\usage{

\method{merge}{cell.data}(x,y,by=NULL,na.rm=FALSE,add=FALSE,warn=TRUE,pos.offset=NULL,...)

load.pdata(X,pdata="pdata.txt",by=NULL,path=getwd())

}

\arguments{
  \item{X}{ cell.data object }
  \item{x}{ cell.data object }
  \item{y}{ a data.frame with at least one common variable with x }
  \item{by}{character vector indicating which variables to use for the merging}
  \item{na.rm}{should NAs be removed before merging}
  \item{add}{boolean indicating if new values should be added to previously merged ones}
  \item{warn}{boolean indicating if warnings should be issued}
  \item{pos.offset}{position offset used when merginf cell.data objects}
  \item{pdata}{either a string with the filename of a tab delimited text file containing the data to be merged, or a data.frame to merge}
  \item{path}{string containing the path to the location of the tab delimited file to be loaded}
  \item{\dots}{additional arguments to be passed to or from methods}
}


\details{
\code{merge} is used to add the variables in a data.frame to the cell.data object. It uses common variables to do the merging. The variables can be specified with the \code{by} argument.

\code{load.pdata} is a wrapper over merge, used to load position information to the cell.data object. By default it looks for a file named 'pdata.txt' in the working directory. This file should have a 'pos' column.  

 }
\value{
 a cell.data object with the merged variables. 
}
\author{ Alan Bush }
\seealso{ \code{\link{merge}} }
\examples{
#load example dataset
data(ACL394)
#creating data frame with information about each poistion
#AF.nM: dose of alpha-factor yeast pheromone in nM
pdata<-data.frame(pos=1:35,AF.nM=rep(c(1.25,2.5,5,10,20),each=7))

#merging the data frame with the cell.data object
X<-merge(X,pdata)

}

\keyword{IO}
\keyword{methods}

