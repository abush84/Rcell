\name{select.cells}
\alias{select.cells}
\title{ Select Subset of Cells }
\description{
  Selects a subset of cells that satisfy the specified conditions. 
}
\usage{
select.cells(X, subset = TRUE, n.tot.subset=NULL ,QC.filter=TRUE)
}
\arguments{

  \item{X}{ cell.data object}
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset¥s variable, that
  specifies which registers should be included}
  \item{n.tot.subset}{a conditional statement usually involving n.tot, to filter the cells by the total number of frames in which they appear.}
  \item{QC.filter}{a boolean value indicating if the QC.filter should be applied 
  over the data}
}


\details{
 select a group of cells be a criteria specified in \code{subset}. 
 After the first subset is applied the number of frames in which a selected cell appears (n.tot) is calculated and an additional filter (\code{n.tot.subset}) is applied. This can be useful to select cells that satisfy the specified \code{subset} filter in all the time frames, or a fraction of them. 
  
 You can do union, intersection and difference of these sets.
}
\value{
 Returns a vector of the selected cells 'ucid'. The ucid (or 'unique cell id') is 
 defined as pos*100000+cellID. Because the returned value is an integer vector
 all the set operations may be applied directly over subsets of cells selected
 by select.cells. The returned vector should be assigned to a variable 
 for further usage. 
}
\author{ Alan Bush}
\seealso{\code{\link{intersect}},\code{\link{union}},\code{\link{setdiff}} }
\examples{
#load example dataset
data(ACL394)

#select cells that have f.tot.y>1e7 in at least one t.frame
c1<-select.cells(X,f.tot.y>1e7)
cplot(X,f.tot.y~t.frame,color="gray",size=0.5) +  #plotting the cells
  clayer(X,f.tot.y~t.frame,color=ucid,geom="line",subset=ucid\%in\%c1)

#select cells that have f.tot.y<6e5 in all t.frames
c1<-select.cells(X,f.tot.y<6e5,n.tot.subset=n.tot==14)  
cplot(X,f.tot.y~t.frame,color="gray",size=0.5) +  #plotting the cells
  clayer(X,f.tot.y~t.frame,color=ucid,geom="line",subset=ucid\%in\%c1)

}
\keyword{manip}