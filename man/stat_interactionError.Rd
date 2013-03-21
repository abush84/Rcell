\name{stat_interactionError}
\alias{stat_interactionError}
\alias{StatInteractionError}

\title{Calculate summary statistic after correcting for the 'sample effect'.}
\usage{
stat_interactionError(mapping = NULL, data = NULL, geom = "pointrange", position = "identity", ...) 
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
  \code{stat_interactionError} corrects the data for the 'sample effect', and then applies a summary statistic. In statistical linear model jargon, the remaining error is the 'interaction error', i.e. the variability not explain by the combination of the 'time effect' and 'sample effect'. If you have 'parallel' traces for each sample (cell), and you are intereset in the 'shape' of the curves and not in the difference in 'height', this stat can be useful. You need good justification to use this correction. If you don't understand what this stat does, don't use it!
  
}
\examples{

#load example dataset
data(ACL394)

#plotting time courses for position 15
cplot(X,f.tot.y~t.frame,subset=pos==15,geom="line",group=ucid)

#using stat summary ignores the fact that the same cells are sampled at different times
cplot(X,f.tot.y~t.frame,subset=pos==15,stat="summary",fun.data="mean_cl_normal"
	,geom=c("point","errorbar","line"))

#the interactioError stat eliminates the 'cell effect' before calculating the confidence
#intervals. This works better if there are no missing values. Check for this with n.tot.
X<-update_n.tot(X)
cplot(X,f.tot.y~t.frame,subset=pos==15&n.tot==14
	,stat="interactionError",fun.data="mean_cl_normal"
	,geom=c("point","errorbar","line"),sample=ucid,group=pos)

}
\seealso{
  \code{\link{stat_summary}}
}

