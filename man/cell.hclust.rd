\name{cell.hclust}
\alias{cell.hclust}
\alias{chclust}

\title{Hierarchical Clustering of Cell Data}

\description{
 Hierarchical cluster analysis on cells of a cell.data object
}
\usage{

cell.hclust(X,select,metric="cosangle",method="average",plot="heatmap",main=NULL
				,heatmap.col=colorRampPalette(c("green", "black", "red"), space="rgb",bias=2)(128)
				,cutree="none",cutree.args=list(h=0.5),plot.dendrogram=cutree\%in\%c("height","cluster","clusters")
				,min.cluster.size=20,na.rm=FALSE,formula=ucid ~ variable + t.frame,subset=TRUE,exclude=NULL
        ,QC.filter=TRUE,col.select=NULL,col.exclude=NULL,labRow=NA,...)				
}

\arguments{
  \item{X}{ cell.data object }
  \item{select}{character vector defining variables names (before reshaping) to be included for the clustering}
  \item{metric}{character string specifying the metric to be used for calculating dissimilarities between vectors. The currently available options are "cosangle" (cosine angle or uncentered correlation distance), "abscosangle" (absolute cosine angle or absolute uncentered correlation distance), "euclid" (Euclidean distance), "abseuclid" (absolute Euclidean distance), "cor" (correlation distance), and "abscor" (absolute correlation distance).}
  \item{method}{the agglomeration method to be used. This should be (an unambiguous abbreviation of) one of "ward", "single", "complete", "average", "mcquitty", "median" or "centroid".}
  \item{plot}{type of plot to be printed to the active device. Currently available options are "heatmap" or "none".}
  \item{main}{title for the plot. If NULL metric, clsuter method and tree cut method are specified}
  \item{heatmap.col}{vector specifying colors to be used as the heatmap palette}
  \item{cutree}{method use to cut the hierarchical clustering tree. Currently available options are "none" or "height"}
  \item{cutree.args}{list of arguments to be passed to the cutree method}
  \item{plot.dendrogram}{boolean indicating if the dendrogram with the applied cut is to be shown.}
  \item{min.cluster.size}{minimal amount of cells of a cluster}
  \item{na.rm}{remove NAs from dataset}
  \item{formula}{casting formula, see details for specifics}
  \item{subset}{a boolean vector of length equal to the number of rows of the
  dataset, or a conditional statement using the dataset?s variable, that
  specifies which registers should be included}
  \item{exclude}{character vector defining variables names to be excluded from the clustering}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
  \item{col.select}{character vector defining variables names (after reshaping) to be included for the clustering. Wildcard patterns are also accepted}
  \item{col.exclude}{character vector defining variables names (after reshaping) to be excluded of the clustering. Wildcard patterns are also accepted}  
  \item{labRow}{character vectors with row labels to use; if NA (the default) no row labels are shown}
  \item{\dots}{further arguments for \code{\link{heatmap}} or plotting function}

}


\details{
This functions does a hierarchical clustering of the cells. For that it first reshapes the data with a call to \code{\link{creshape}}. The \code{formula} argument should a have a single variable in the left term (usually 'ucid' or 'cellID').

The function then calculates a distance matrix using the function \code{distancematrix} of the hopach package. The function \code{\link{hclust}} is used to calculate the clustering. If a \code{cutree} method is specified, the cells are grouped into clusters. The function then plots a \link{heatmap} to the current device.  

}
\value{
  a (invisible) list containing elements $data, $matrix, $dist, $hclust and $cell.subtree.
  $data is the reshaped data.frame. $matrix contains the same information as $data, coerced to matrix. $dist contains the distance matrix calculated with the method specified in \code{metric}. $hclust contains the output of the call to \code{\link{hclust}}. $cell.subtree contains a data.frame with the subtree that each cell belongs to.  
}
\author{ Alan Bush }
\seealso{ \code{distancematrix},\code{\link{hclust}},\code{\link{heatmap}} }
\examples{
  
if(require(hopach,quietly=TRUE)){  #suggested package hopach required for this function
  #load example dataset 
  #warning: Any object named 'X' will be replaced
  data(ACL394filtered)

  #Heriarchical clustering of cells by f.tot.y time course, 
  #using cosangle (uncentered correlation) metric and average linkage method.
  cell.hclust(X,"f.tot.y")

  #Heriarchical clustering of cells by f.tot.y time course, 
  #using euclid metric and complete linkage method.
  cell.hclust(X,"f.tot.y",metric="euclid",method="complete")

  #Cut the tree at constant height and show the clusters
  cell.hclust(X,"f.tot.y",cutree="height",cutree.args=list(h=0.005))

  #redefining the formula, plot against time in minutes
  X<-transform(X,time.min=10+t.frame*15) #calculating the time of each t.frame
  cell.hclust(X,"f.tot.y",formula=ucid~variable+time.min)
}
}
\keyword{ cluster }
\keyword{ hplot }
