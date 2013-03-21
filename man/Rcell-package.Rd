\name{Rcell-package}
\docType{package}
\alias{Rcell-package}
\alias{Rcell}
\title{
  Microscopy Based Cytometry Data Analysis Package
}
\description{
 Microscopy based cytometry can produce huge amount of images to be analized. Several programs can segment the acquired images and create a dataset with the features of the segmented cells. This package contains functions design to analyze such datasets. It was created to analyze data from Cell-ID (\url{http://sourceforge.net/projects/cell-id/}), but can be extended to analyze datsets created by other segmentation programs.
 }
\details{
\tabular{ll}{
Package: \tab Rcell\cr
Type: \tab Package\cr
Version: \tab \Sexpr[stage=build]{packageDescription("Rcell")$Version} \cr
Date: \tab \Sexpr[stage=build]{packageDescription("Rcell")$Date} \cr
License: \tab GPL-2\cr
}
}

\section{Tutorials}{

For a introduction read the 'Getting Started with Rcell' vignette \cr
\code{vignette('Rcell')} \cr

To learn how to create complex plots read \cr
\code{vignette('cplot')} \cr

To see how to create layouts of cell's images read \cr
\code{vignette('cimage')} \cr

To lear how to normalize and manipulate your data read \cr
\code{vignette('transform')} \cr

To read a description of Cell-ID's variables and features  \cr
\code{vignette('Cell-ID-vars')} \cr

}
\section{Loading Cell-ID Data in R}{

Once you have processed the images with Cell-ID you will have to analyse the output dataset. The first thing you will have to do is load your data into R.

\code{\link{load.cellID.data}}: this function searches a specified directory (the working directory by default) for folders that match a customizable pattern, usually PositionXX where XX is the position number. The function loads these files and generates a suitable data structure. It returns a object of class \verb{cell.data} that contains all the required information for the analysis. All the functions included in the package operate over this object, and its components should not be modified directly, but through the provided functions.

}
\section{Quality Control and Filtering Cells}{

The algorithm used by Cell-ID to find the cells can occasionally make mistakes in the assignation of the cell boundaries and produce badly found and spurious cells (i.e. image structures erroneously scored as cells). Further more, the program does not discriminate out of focus and dead cells. 

Normally you will want to get rid of all the spurious, badly found, out of focus and dead cells (referred collectively as 'bad' cells), which would constitutes a 'quality control' of the data. The R package contains some functions to aid in this process.

\code{\link{QC.filter}}: applies quality control filters over the data. The purpose of this function is to eliminate from the dataset 'bad' cells. You should not use this function to differentiate sub-groups of 'good' cells. This function treats a cell in different time points independently (i.e. it operates on registers of the dataset). To eliminate cells that are not scored in all the time frames, call \code{\link{update.n.tot}} and then filter by n.tot.
Filters can be undone by \code{\link{QC.undo}}, or reseted by \code{\link{QC.reset}}. Use \code{\link{summary.cell.data}} to see a summary of the applied filters. 

}
\section{Plotting the Data}{

For plotting the data you can use the package plotting functions \code{\link{cplot}} and \code{\link{cplotmeans}}, which are wrappers over the \pkg{ggplot2} package functions. 
}

\section{Image Layout}{
To create image layouts (or montages) of your cells use the \code{\link{cimage}} functions. 
}

\section{Data Manipulation}{

Some common manipulations you can apply over a \verb{cell.data} object are subsetting (\code{\link{subset.cell.data}}) which returns a \verb{cell.data} object, extraction (\code{\link{[[.cell.data}}) and aggregation (\code{\link{aggregate.cell.data}}) which return a \verb{data.frame}.
You can also create new variables form existing ones. This can be done to save typing, or to normalize your data. To this end you can use the \code{\link{transform.cell.data}} and \code{\link{transform.by.cell.data}} functions. 
}

\author{
Alan Bush
Maintainer: Alan Bush <abush@fbmc.fcen.uba.ar>
}
\references{
\url{http://www.df.uba.ar/lbms}
\url{http://sourceforge.net/projects/cell-id}
}
\keyword{ Cell-ID }
\seealso{
  \pkg{EBImage}
  \pkg{ggplot2}  
}
\keyword{package}
