\name{load.cellID.data}
\alias{load.cellID.data}
\alias{load.cell.data}
\title{Load Cell-ID Data}
\description{
 load.cellID.data searches a specified directory (the working directory by default) 
 for folders that match a customizable pattern, usually PositionXX where XX is the 
 position number. This folders should contain the Cell-ID output files output_all
 and the output_bf_fl_mapping for each position. The function 
 loads this files and generates a data structure suitable for filtering and 
 plotting. The function 
 returns a cell.data object that contains all the required 
 information for the analysis. All the functions included in the package 
 operate over this object, and its components should not be modified directly, 
 but through the provided functions. Remember to assign the returned value to a
 variable (e.g. X<-load.cellID.data() )

}
\usage{
load.cellID.data(pattern="^[Pp]{1}os[:alpha:]*[:digit:]*",path=getwd()
  ,basename="out",select=NULL,exclude=NULL,load.vars="all",split.image=FALSE)
}


\arguments{
   \item{pattern}{regular expression (see \link{regexp}) pattern of the position folders, where 
   the images and cell ID output files for each position are stored.}
   \item{path}{character containing path from where to apply the pos.pattern to the existing 
   folders. It should point to the folder that contains the PosXX folders.}
   \item{basename}{character containing basename of the cell ID output files, should match the -o 
   option passed to cellID when executed. 'out' by default.}
   \item{select}{character vector defining variables names to be included in the cell.data object}
   \item{exclude}{character vector defining variables names to be excluded of the cell.data object}
   \item{load.vars}{character specifying which variables or group of variables of the Cell-ID 
   		out_all file should be loaded.}
   \item{split.image}{boolean indicating if the images are split and upper cells should be matched 
      to lower cells. Set to TRUE if analyzing a FRET split image experiment.}
   		
}

\details{

reads Cell ID output files (basename)_all in folders that match pattern 
in path and loads them into a cell.data object.

It searches for the output_all files in folders of the form specified by 
pattern (regular expression). If the folder has a numeric value in its name
that number is taken as the position index (for example pos01 is given the index 1)
If no numeric value is found in the folder name, then a ordinal index is assign.

Possible values for load.vars are 'all', 'fl' or 'fluorescence',
'bg' or 'background', 'calc', 'morph' or 'morphological', 'vac' or 'vacuole',
'nucl' or 'nuclear', 'disc'. The group of variables can be specified in either a positive
form (i.e. '+fl+bg+morph') or in a negative form (i.e. '-nucl-vac').
Combination of positive and negative form is not allowed.
A character vector containing the variables names of the out_all file is 
also allowed. The selection of variables is done before restructuring, so the 
variable names should correspond to those of the out_all files. Using this argument can be useful 
if memory issues arise. 

Alternatively \code{select} and \code{exclude} can be used to subset the dataset. 
This arguments are applied after the reshaping, 
so variables names as returned by \code{\link{summary.cell.data}} are used. Wildcard patterns (e.g. 'f.*.y') 
and keywords (e.g. 'all', 'id.vars', 'YFP', etc.) can be used as components of these arguments. 

}

\value{
  a cell.data object
}
\author{ Alan Bush }
\note{
The restructuring of the data involves arranging the information for each 
time point of each cell into a single row. In the output of Cell-ID this information
appears in several rows, one for each channel. The restructured data 
'collapses' this rows into a single one, adding and modifying the column 
names by appending a channel specific postfix. If \code{split.image} is set to TRUE
a sub-image indentifier is also appended, 'u' for upper and 'l' for lower. 
When Cell-ID is run, the images it uses have to be named in a specific way.
The first three letters of the image name are used as a channel token, i.e. it
identifies the channel. If you have YFP and CFP channels, the images should be
named YFP_Position1, YFP_Position2,...,CFP_Position1, CFP_Postion2,...
The channel postfix is the shortest unambiguous substring of the channel token in
lower case. For example for the tokens 'YFP' and 'CFP', the selected postfix 
will be 'y' and 'c' respectively.
}
\seealso{
   \code{\link{read.table}},\code{\link{dir}},
   \code{\link{QC.filter}}, \code{\link{summary.cell.data}}
}
\examples{
\dontrun{
setwd(".")  #set the working directory to the folder with your images
X<-load.cellID.data()  #load the dataset to R

}
}
\keyword{IO}
\keyword{manip}
