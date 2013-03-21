\name{cell.data}
\alias{cell.data}

\title{Cell Data Object}

\description{
 cell.data object description
}

\details{
  \verb{cell.data} objects created by \code{\link{load.cellID.data}} and manipulated by the functions of the package. They are list with class 'cell.data' and contain the following elements 
  
\describe{
  \item{data}{main \verb{data.frame} containing all the variables created by Cell-ID, plus additional variables created in R. To see a full description of Cell-ID's variables read the 'Cell-ID-vars' vignette (\code{vignette('Cell-ID-vars')}). It also contains the special \verb{QC} variable, that contains the Quality Control filter created by \code{\link{QC.filter}}.}
  \item{QC.history}{\verb{list} containing the description of the different filters applied with \code{\link{QC.filter}} }
  \item{subset.history}{\verb{list} containing the description of the different subsets applied with \code{\link{subset.cell.data}}}
  \item{transform}{\verb{list} containing the description of the variables created with \code{\link{transform.cell.data}} or \code{\link{transformBy.cell.data}}}
  \item{channels}{\verb{data.frame} containing the names and posfix of the available fuorescence channels}
  \item{variables}{\verb{list} containing all the available variable names. The names of the items of the list work as a keyword. Each item contains a character vector with variable names (elements of data). Example of keywords ($variables elements) are 'id.vars', 'morpho', 'fluor', 'all', 'transformed', 'YFP', etc.}
  \item{images}{\verb{data.frame} containing information regarding the images run by Cell-ID. }
  \item{software}{character describing the segmentation software used}
  \item{load.date}{character containing the date in which the dataset was loaded to R.}
}  
 }
\author{ Alan Bush }
\keyword{manip}
\keyword{methods}

