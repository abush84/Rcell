\name{reshape.cell.data}
\alias{reshape.cell.data}
\alias{reshape}
\alias{creshape}

\title{Reshape a Cell Data Object}

\description{
 Reshapes the data in a cell.data object and returns a data.frame
}
\usage{

reshape(data,...)

\method{reshape}{cell.data}(data,formula = pos + cellID ~ variable + t.frame
  ,fun.aggregate=NULL, ..., margins=FALSE, fill=NULL
  ,id.vars=NULL, measure.vars=NULL, variable_name = "variable", na.rm = FALSE
  ,subset=TRUE ,select=NULL ,exclude=NULL ,QC.filter=TRUE)
}

\arguments{
  \item{data}{ cell.data object }
  \item{formula}{	casting formula, see details for specifics }
  \item{fun.aggregate}{aggregation function}
  \item{\dots}{further arguments are passed to aggregating function}
  \item{margins}{vector of variable names (can include 'grand_col' and 'grand_row') to compute margins for, or TRUE to computer all margins}
  \item{fill}{value with which to fill in structural missing, defaults to value from applying \code{fun.aggregate} to 0 length vector}
  \item{id.vars}{character vector of id variables names, wildcard pattern or keyword. If NULL, will use all variables of the formula.}
  \item{measure.vars}{character vector of measure variables names, wildcard pattern or keyword. If NULL, will use all non id.vars variables.}
  \item{variable_name}{Name of the variable that will store the names of the original variables}
  \item{na.rm}{Should NA values be removed from the data set?}
   \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset¥s variable, that
  specifies which registers should be included}
  \item{select}{character vector defining variables names to be included in the returned data.frame}
  \item{exclude}{character vector defining variables names to be excluded from the returned data.frame}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
}


\details{
  This function is a wrapper over \code{\link{melt}} and \code{\link{cast}} from the reshape package of Hadley Wickham. 

The id variables are selected by default. You can use \code{\link{summary.cell.data}} to see which variables are used as defaults for \code{id.vars}. The measured variables can be specified with \code{select} and \code{exclude}, or with \code{measure.vars}.

The casting \code{formula} has the following format: \code{x_variable + x_2 ~ y_variable + y_2 ~ z_variable ~ ... | list_variable + ... }. The order of the variables makes a difference. The first varies slowest, and the last fastest. There are a couple of special variables: '\code{...}' represents all other variables not used in the formula and '.' represents no variable, so you can do \code{formula=var1 ~ .}

If the combination of variables you supply does not uniquely identify one row in the original data set, you will need to supply an aggregating function, \code{fun.aggregate}. This function should take a vector of numbers and return a summary statistic(s). It must return the same number of arguments regardless of the length of the input vector. If it returns multiple value you can use \code{result_variable} to control where they appear. By default they will appear as the last column variable.

The margins argument should be passed a vector of variable names, eg. c('pos','t.frame'). It will silently drop any variables that can not be margined over. You can also use 'grand_col' and 'grand_row' to get grand row and column margins respectively. 

 }
\value{
 a reshaped data.frame 
}
\author{ Alan Bush }
\seealso{ \code{\link{aggregate}} }
\examples{
#load example dataset
data(ACL394)

#rehape position 1 in pos + cellID ~ variable + t.frame for f.tot.y variable
reshape(X,select="f.tot.y",subset=pos==1)

#redefining the formula, reshape against time in minutes
X<-transform(X,time.min=10+t.frame*15) #calculating the time of each t.frame
reshape(X,pos+cellID~variable+time.min,select="f.tot.y",subset=pos==1&t.frame<10)

}
\keyword{manip}

