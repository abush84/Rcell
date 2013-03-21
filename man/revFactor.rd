\name{revFactor}
\alias{revFactor}

\title{Reverse Factor Levels}
\description{
Reverse the order of the levels of a factor
}
\usage{
revFactor(x)
}
\arguments{
  \item{x}{a factor}
}
\details{
	Useful to use in calls to \code{\link{cimage}}         
}
\value{
  a ordered factor with the levels in the reverse order of \code{levels(x)}.
}
\author{Alan Bush}
\examples{

#create a factor
f<-factor(paste0("f",1:9))
levels(f)

#reverse the order of the levels
rf<-revFactor(f)
levels(rf)

}
\keyword{manip}