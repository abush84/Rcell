\name{ggplot2.themes}
\alias{ggplot2.themes}
\alias{ggplot2.theme}
\alias{ggplot.themes}
\alias{ggplot.theme}
\alias{theme_Rcell}
\alias{theme_invisible}

\title{ggplot2 themes}
\description{
Themes for ggplot2 graphics
}

\usage{
theme_Rcell()
theme_invisible()
}

\details{

  I found these functions posted at \url{https://github.com/hadley/ggplot2/wiki/Themes}. I included them here for convenience. 

  These functions provide more themes for ggplot2 graphics. They work just as \code{\link{theme_grey}} and \code{\link{theme_bw}}
}
\value{
  A list with theme elements
}
\examples{

#creating example datset
mdf <- data.frame(x <- seq(0, 10), y=rnorm(x), 
                  f=factor(rep(letters[1:2], each=3, length=length(x))))
#base plot
p <- qplot(x, y, data=mdf, colour=f, geom=c("line", "point")) 

#compare themes
p + theme_grey() + labs(title="theme_grey()")
p + theme_bw() + labs(title="theme_bw()")
p + theme_Rcell() + labs(title="theme_Rcell()")
p + theme_invisible() + labs(title="theme_invisible()")

}
\keyword{manip}