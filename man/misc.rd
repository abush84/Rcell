\name{misc}
\alias{misc}
\alias{paste_data_error}
\alias{paste_parameter}
\alias{paste_intercept_slope}
\alias{paste_EC50_n}
\alias{vplayout}

\title{Miscellaneous Functions}
\description{
Miscellaneous functions to do stuff in less lines
}
\usage{
paste_data_error(data,error,error.signif=1,plotmath=FALSE)
paste_parameter(fit,param,error.signif=1)
paste_intercept_slope(fit,error.signif=1)
paste_EC50_n(fit,leading.str="",error.signif=2)
vplayout(x, y)
}
\arguments{
  \item{data}{a numeric vector of values }
  \item{error}{a numeric vector of errors for \code{data} values}
  \item{error.signif}{number of significant digits for the error}	
  \item{plotmath}{if TRUE the +- character for plotmath is used instead of the default}	
  \item{fit}{an object of class 'lm' or 'nlm'}	
  \item{param}{character name of the parameter from \code{fit} to paste}	
  \item{leading.str}{string to paste before the data and error}	
  \item{x}{x index of grid to use to print the ggplot2 figure}
  \item{y}{y index of grid to use to print the ggplot2 figure}
}
\details{
	the \code{paste_} functions are used to paste a value and its error (or uncetainty) in resonable way.  
}
\value{
	a character vector with the data and error
}
\author{Alan Bush}
\seealso{ \code{\link{transform.cell.data}}}
\examples{
paste_data_error(1.0,0.01)

#put several figures in a page
data(ACL394)
grid.newpage() #create a new plot
pushViewport(viewport(layout = grid.layout(1, 2))) #define the grid for the plots
print(cplot(X,f.tot.y~pos), vp = vplayout(1, 1))
print(cplot(X,f.tot.y~a.tot,color=pos), vp = vplayout(1, 2))

}
\keyword{manip}