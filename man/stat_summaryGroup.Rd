\name{stat_summaryGroup}
\alias{stat_summaryGroup}
\alias{StatSummaryGroup}

\title{Summarise y and x values according to user defined groups.}
\usage{
	stat_summaryGroup(mapping = NULL, data = NULL, geom = "pointrange", position = "identity", ...)
}
\arguments{
  \item{mapping}{The aesthetic mapping, usually constructed
  with \code{\link{aes}} or \code{\link{aes_string}}. Aesthetics 'x', 'y' and 'group' required.}

  \item{data}{A layer specific dataset - only needed if you
  want to override the plot defaults.}

  \item{geom}{The geometric object to use display the data}

  \item{position}{The position adjustment to use for
  overlappling points on this layer}

  \item{...}{other arguments passed on}
}
\value{
  a data.frame with additional columns:
  \item{fun.data}{Complete summary function. Should take
  data frame as input and return data frame as output.}
  \item{fun.ymin}{ymin summary function (should take
  numeric vector and return single number)} 
  \item{fun.y}{y summary function (should take numeric vector and return
  single number)} 
  \item{fun.ymax}{ymax summary function
  (should take numeric vector and return single number)}
}
\description{
  \code{stat_summaryGroup} allows for tremendous flexibilty in
  the specification of summary functions.  The summary
  function can either operate on a data frame (with
  argument name \code{fun.data}) or on a vector
  (\code{fun.y}, \code{fun.ymax}, \code{fun.ymin}).
}
\details{
  A simple vector function is easiest to work with as you
  can return a single number, but is somewhat less
  flexible.  If your summary function operates on a
  data.frame it should return a data frame with variables
  that the geom can use.
}
\examples{

#load example dataset
data(ACL394)

#plotting all points of t.frame 12
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12)

#using stat summary groups by x position, that makes no sense.
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summary",fun.y=mean)

#stat summaryGroup groups by pos in this example
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,fun.y=mean,fun.x=mean)

#errorbars can be added with the fun.ymin, fun.ymax, fun.xmin and fun.xmax arguments.
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,geom=c("point","errorbar","errorbarh")
	,fun.y=mean,fun.x=mean
	,fun.ymax=function(x)mean(x)+sd(x),fun.ymin=function(x)mean(x)-sd(x)
	,fun.xmax=function(x)mean(x)+sd(x),fun.xmin=function(x)mean(x)-sd(x))

#use the fun.data for common summary functions
cplot(X,f.tot.y~f.tot.c,subset=t.frame==12,stat="summaryGroup",group=pos
	,geom=c("point","errorbar","errorbarh")
	,fun.data="mean_cl_normal")


}
\seealso{
  \code{\link{stat_summary}}
}

