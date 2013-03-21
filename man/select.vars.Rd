\name{select.vars}
\alias{select.vars}
\title{ Select Variables }
\description{
  Selects a group of variable names from the dataset. 
}
\usage{
select.vars(X,select="all",exclude=NULL)
}
\arguments{

  \item{X}{ cell.data object}
  \item{select}{character vector defining variables names, keywords or wildcard patters to be included in the returned vector}
  \item{exclude}{character vector defining variables names, keywords or wildcard patters to be excluded from the returned vector}
}


\details{
Selects a group of variables. If you only use the first argument it returns 'all' the columns of the dataset.
}
\value{
A character vector with variable names.
}
\author{ Alan Bush}
\seealso{\code{\link{names}} }
\examples{
#load example dataset
data(ACL394)

#select all variables
select.vars(X)

#select morphological variables
select.vars(X,"morpho")

#select variables of the YFP channel
select.vars(X,"*.y")

#select id vars, area vars and f.tot.y
select.vars(X,c("id.vars","a.*","f.tot.y"))

#select id vars, area vars and f.tot.y, exlude bg variables
select.vars(X,c("id.vars","a.*","f.tot.y"),exclude="*bg*")
}
\keyword{manip}