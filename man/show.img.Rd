\name{show.img}
\alias{show.img}
\alias{show.image}

\title{ Show a Image}
\description{
  Display one or several BF or fluorescent images, indicating the cells eliminated by the QC filter.   
}

\usage{
show.img(X,pos,t.frame=0,channel="BF.out",image.title=""
  ,annotate=NULL,cross=!QC,QC.filter=FALSE,subset=TRUE,cross.col=c(0.1,0.9)
  ,display=interactive(),normalize=TRUE,...)
  
show.image(X,pos,t.frame=0,channel="BF.out",image.title=""
  ,annotate=NULL,cross=!QC,QC.filter=FALSE,subset=TRUE,cross.col=c(0.1,0.9)
  ,display=interactive(),normalize=TRUE,...)  
}

\arguments{
  \item{X}{cell.data object as returned by \code{\link{load.cellID.data}} }
  \item{pos}{ The position(s) of interest, from which the image will be shown.}
  \item{t.frame}{ The time frame(s) of interest, from which the image will be shown. If it is a vector shorter than \code{pos}, it is recycled.}
  \item{channel}{the fluorescent channel label of interest. Usual values are 'BF', 'BF.out', 'YFP', 'YFP.out', etc. If it is shorter than \code{pos} or \code{t.frame} it is recycled.}
  \item{image.title}{optional title for the image}
  \item{annotate}{character vector with variable names with which to annotate the image. A usual value is 'cellID'. NOT IMPLEMENTED CURRENTLY!}
  \item{cross}{ conditional statement with \code{X} variables indicating over which cells should a cross be placed.}
  \item{QC.filter}{boolean value, indicating if \code{X} should be subset by QC.filter before \code{cross} or \code{annotate} are applied. Default to FALSE.}
  \item{subset}{conditional statement using \code{X} variables used to subset \code{X} before other arguments are applied.}
  \item{cross.col}{vector of colors (gray levels) to be used for the crosses. Each mark is composed of two cross with the specified colors, moved one pixel from each other. Using a black and white enhances contrast.}
  \item{display}{boolean indicating if the created image should be displayed}
  \item{normalize}{boolean indicating if the images should be normalized to enhance contrast}
  \item{\dots}{further arguments}
}
\details{
 Displays the bright field and/or fluorescence images. Cells can be annotated with a cross or the value of a selected variable. This function can be used as a feedback to verify that the cuts used for \code{\link{QC.filter}} were adequate.}

\value{
   It returns a \code{\link{invisible}} EBImage image. 
}
\author{Alan Bush}
\note{ 
  This function requires \code{EBImage} package installed which, in turn, requires
  the ImageMagick software. 
}
\seealso{EBImage}
\examples{

if(interactive()&require(EBImage,quietly=TRUE)){
  #load example dataset
  data(ACL394filtered)
  
  #display the BF out image from position 8 and t.frame 11
  show.img(X,pos=8,t.frame=11)

  #display a stack of the YFP images of position 29
  show.img(X,pos=29,t.frame=7:11,channel="YFP")
}

}
\keyword{manip}
\keyword{methods}
