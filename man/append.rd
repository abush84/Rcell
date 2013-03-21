\name{append}
\alias{append.in.focus}
\alias{append.z.scan}
\alias{append.anular.y}
\alias{append.anular.r}
\alias{append.anular.c}
\alias{append.memRec.y}
\alias{append.memRec.r}

\title{Append Variables}
\description{
This functions append some calculated variables to the cell.data object
}
\usage{
append.z.scan(X
  ,fun.z.scan=function(x)(as.numeric(as.factor((x-x\%\%100)/100))) 
  ,fun.z.slice=function(x)(x\%\%100)
  ,fun.oif=function(x)((x-x\%\%10000)/10000)
  ,TIME.TOKEN="time",TIME.DIGITS=5
  ,channel=X$channels$name[1])

append.in.focus(X,focus.var,in.focus.var="in.focus")

append.anular.y(X)	
append.anular.r(X)	
append.anular.c(X)	

append.memRec.y(X)	
append.memRec.r(X)	
}
\arguments{
  \item{X}{cell.data object }
  \item{focus.var}{character name of variable used to focus}
  \item{in.focus.var}{character name of appended variable}	
  \item{fun.z.scan}{function used to extract the z.scan from the image time token}	
  \item{fun.z.slice}{function used to extract the z.slice from the image time token}	
  \item{fun.oif}{function used to extract the oif number from the image time token}	
  \item{TIME.TOKEN}{Image time token}	
  \item{channel}{character specifying the channel to use to extract the relevant information from the filenames}
  \item{TIME.DIGITS}{numeric digits of the time token}	
}
\details{
  \code{append.z.scan} appends the variables 'z.scan', 'z.slice' and 'oif' to the dataset. 'z.scan' indicates the z stack a time frame blongs to. 'z.slice' indicates the slice within a z.scan. 'oif' indicates from wich file the image comes from.	
  \code{append.in.focus} appends a boolean vector that is TRUE when the position mean of the selected \code{focus.var} is maximum within a z.scan	
  \code{append.anular} functions append the variables 'f.p1', 'f.m0', 'f.m1', 'f.m2', 'f.m3' and the respective areas to the dataset, in a channel specific manner.
  \code{append.memRec.y} calcualates the membrane recruitment observable 'f.obs.y', for YFP channel
}
\value{
  returns a cell.data object, with appended variables
}
\author{Alan Bush}
\seealso{ \code{\link{transform.cell.data}}}
\examples{
\dontrun{
X<-append.anular.y(X)
X<-append.memRec.y(X)
X<-append.z.scan(X)
X<-append.in.focus(X,"f.obs.y")
}
}
\keyword{manip}