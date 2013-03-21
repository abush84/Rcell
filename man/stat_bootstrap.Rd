\name{stat_bootstrap}
\alias{stat_bootstrap}
\alias{StatBootstrap}

\title{Calculate bootstraps confidence intervals of a time course}
\usage{
stat_bootstrap(mapping = NULL, data = NULL, geom = "pointrange", position = "identity", ...) 
}
\arguments{
  \item{mapping}{The aesthetic mapping, usually constructed
  with \code{\link{aes}} or \code{\link{aes_string}}. Aesthetics 'x', 'y','group' and 'sample' required.}

  \item{data}{A layer specific dataset - only needed if you
  want to override the plot defaults.}

  \item{geom}{The geometric object to use display the data}

  \item{position}{The position adjustment to use for
  overlappling points on this layer}

  \item{...}{other arguments passed on}
}
\description{
  \code{stat_bootstrap} calculates 95\% confidence intervals by the bootstrap method, with 1000 bootstrap replicates. The 'sample' aesthetic defines the sampling unit. The 'group' aesthetic defines the groups in which to sample the sampling units. Each groups standard error is calculated independently. If you don't understand what this stat does, don't use it!
}
\examples{

#load example dataset
data(ACL394)

#plotting time courses for position 15
cplot(X,f.tot.y~t.frame,subset=pos==15,geom="line",group=ucid)

#using stat summary ignores the fact that the same cells are sampled at different times
cplot(X,f.tot.y~t.frame,subset=pos==15,stat="summary",fun.data="mean_cl_boot"
	,geom=c("point","errorbar","line"))

#the stat bootstrap samples cells, and therefore the lack of independece is taken into account.
#note that there can be no missing data for this to work. You can check this with the n.tot variable.
X<-update_n.tot(X)
cplot(X,f.tot.y~t.frame,subset=pos==15&n.tot==14,stat="bootstrap"
	,geom=c("point","errorbar","line"),sample=ucid,group=pos)

}
\seealso{
  \code{\link{stat_summary}}
}

