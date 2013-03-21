\name{cell.image}
\alias{cell.image}
\alias{get.cell.image}
\alias{get.cell.image.cell.data}
\alias{get.cell.image.data.frame}
\alias{get.cell.image.default}
\alias{summary.cell.image}
\alias{print.summary.cell.image}
\alias{print.cell.image}
\alias{img.desc}
\alias{is.cell.image}

\title{Get Cells Images}

\description{
 Retrieves the images from single cells in an cell.image object
}
\usage{

get.cell.image(X,...)

\method{get.cell.image}{cell.data}(X,subset=NULL,channel.subset=NULL,channel=NULL
  ,time.course=TRUE,group=NULL,N=7,select=NULL,exclude=NULL,QC.filter=TRUE,box.size=20,...)

\method{get.cell.image}{data.frame}(X,box.size=20,contained.box=FALSE,bg.col=0,...)

\method{get.cell.image}{default}(X,box.size=20,...)

\method{summary}{cell.image}(object,...)

\method{print}{summary.cell.image}(x,...)

\method{print}{cell.image}(x,nx=ceiling(sqrt(length(x))),...)

img.desc(X)

is.cell.image(X)

}

\arguments{
  \item{X}{ cell.data object or data.frame that specifies the images}
  \item{subset}{logical expression indicating elements or rows to keep. Don't specify channel here.}
  \item{channel.subset}{logical expression to specify which image to retrieve with channel and t.frame variables.}
  \item{channel}{character vector of channels to retrieve. If specified, defines the order of the channels.}
  \item{time.course}{boolean indicating if the desired image montage is a time course (i.e. several images for the same cell)}
  \item{group}{character vector or quoted names of variables who's interaction define the groups from which select \code{N} random cells.}
  \item{N}{Number of random cells to select from each group. If NULL all cells are selected}
  \item{select}{character vector defining variables names to be included in the returned cell.image object}
  \item{exclude}{character vector defining variables names to be excluded from the returned cell.image object}
  \item{QC.filter}{a boolean value indicating if the quality control filter should 
    be applied over the data}
  \item{box.size}{size in pixels of the image containing the cells. This specifies the 'radius', i.e. the image will be a square of length 2*box.size+1}
  \item{\dots}{further arguments for methods}
  \item{contained.box}{boolean indicating if the XY position of the box should be corrected to be contained in the original image. Relevant for cells close to the image border. If FALSE the part of the box outside the original image will be filled with \code{bg.col}}
  \item{bg.col}{color to be used for the background of the images}
  \item{object}{cell.image object to summarize}
  \item{x}{object to print}
  \item{nx}{number of columns in the image tile}  

 }

\details{
  \code{get.cell.image} is a generic method that returns a cell.image object.
  
  If \code{get.cell.image} first argument is a data.frame, it should contain the columns path, image, xpos and ypos. 
  
  If the first argument when calling \code{get.cell.image} is a cell.data object, further arguments specify which images will be selected. The \code{subset} arguments filters the dataset as in other functions. If some variables are specified in \code{group}, the data is split in groups defined by these variables, and from each group \code{N} cells are selected at random. The \code{channel} argument specifies which channels to show. 
  If a more complex image selection is required, you can use the \code{channel.subset} argument. For example if you want to see the BF only for the first t.frame, and then only the YFP channel, you can use
 \code{channel.subset=channel=='YFP'|(t.frame==0&channel=='BF')} 
  
  \code{img.desc} returns a data.frame describing each image of the cell.image object
  
 }
\value{
 a cell.image object. This object is basically a list who's elements are the cropped images of single cells. It has a attribute named 'img.desc' that is a data.frame with the image index (img.index) and description of all the components of the objects. 
}
\author{ Alan Bush }
\seealso{EBImage}
\examples{

if(interactive()&require(EBImage,quietly=TRUE)){
  #load example dataset
  data(ACL394filtered)
  
  #select N=3 cells images from each pos (group), 
  #from the first t.frame and pos 1,8,15,22,29.
  ci<-get.cell.image(X,subset=match(pos,c(1,8,15,22,29),nomatch=0)>0&t.frame==11,
    group=.(pos),N=3,channel=c('BF.out','YFP'))
  print(ci) #print the cells images
  summary(ci) #get a summary of the content
  img.desc(ci) #get the image description data.frame

  #select the first 4 t.frames for YFP, and the first t.frame for BF
  ci<-get.cell.image(X,subset=pos==29,group='pos',
    channel.subset=channel=='YFP'|(t.frame==11&channel=='BF'))
  print(ci)
}

}
\keyword{manip}
\keyword{methods}

