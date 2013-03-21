\name{cimage}
\alias{cimage}
\alias{cimage.cell.image}
\alias{cimage.cell.data}
\alias{cimage.default}


\title{Images Layout}

\description{Arranges cell's images in a plot}
\usage{

cimage(X,...)

\method{cimage}{cell.data}(X,formula=NULL,facets=NULL,time.var=c('*time*','t.frame','z.scan','z.slice')
  ,time.course=NULL,select=NULL,exclude=NULL,normalize.group='channel',...)

\method{cimage}{cell.image}(X,formula=NULL,facets=NULL,scales='fixed',allow.expressions=FALSE
  ,nx=NULL,ny=NULL,facets.nx=NULL,facets.ny=NULL
  ,bg.col='white',border=1,facets.border=1,rev.y=TRUE
  ,font.size=14,font.col='black',display=interactive(),...)

\method{cimage}{default}(X,...)

}

\arguments{
  \item{X}{cell.data or cell.image object to plot}
  \item{formula}{formula of the form 'var1+var2~var3' specifying how the images are to be ordered. See details.}
  \item{facets}{formula of the form 'var1+var2~var3' specifying how to facet the plot. See details.}
  \item{time.var}{variables that indicate time and should be excluded from the grouping variables. See \code{\link{get.cell.image}}}
  \item{time.course}{boolean indicating if the image layout represents a time course and several images of the same cell at different times are expected}
  \item{select}{character vector defining further variables that are required for the plot}
  \item{exclude}{character vector defining variable names to be excluded}
  \item{normalize.group}{variable names that define groups of images that should be normalized together}
  \item{scales}{either 'none', 'fixed' or 'free' axis for each facet}
  \item{allow.expressions}{allow expressions in formulas, set to TRUE when called from cimage.cell.data}
  \item{nx}{number of columns of images within each facet. Used with \code{formula} '~var1' or 'var1~.'}
  \item{ny}{number of rows of images within each facet. Used with \code{formulas} '~var1' or 'var1~.'}
  \item{facets.nx}{number of columns of facets. Used with \code{facets} '~var1' or 'var1~.'}
  \item{facets.ny}{number of rows of facets. Used with \code{facets} '~var1' or 'var1~.'}
  \item{bg.col}{The background color of the plot}
  \item{border}{the width in pixels of the border between images}
  \item{facets.border}{the width in pixels of the border between facets}
  \item{rev.y}{boolean indicating if the y axis should be reversed}
  \item{font.size}{The size of the font to use, in pixels}
  \item{font.col}{The color of the font to use}
  \item{display}{boolean indicating if the created image should be displayed}
  \item{\dots}{further arguments for methods. \code{cimage} calls \code{\link{get.cell.image}}, so all the arguments of this function are available.}
}
\details{
  
\tabular{ll}{
\code{subset} \tab logical expression indicating elements or rows to keep. Don't specify channel here \cr
\code{channel.subset} \tab logical expression to specify which image to retrieve with channel and t.frame variables \cr
\code{channel} \tab character vector of channels to retrieve. If specified, defines the order of the channels \cr
\code{QC.filter} \tab a boolean value indicating if the quality control filter should be applied over the data \cr
\code{N} \tab Number of random cells to select from each group. If NULL all cells are selected \cr
\code{box.size} \tab size in pixels of the image containing the cells. This specifies the 'radius', i.e. the image will be a square of length 2*box.size+1\cr
\code{contained.box} \tab boolean indicating if the XY position of the box should be corrected to be contained in the original image. Relevant for cells close to the image border. If FALSE the part of the box outside the original image will be filled with \code{bg.col} \cr
\code{bg.col} \tab color to be used for the background of the images \cr
}

  Read the cimage vignette for a tutorial on how to use this function: vignette('cimage')

  \code{cimage} is a generic method that returns a 'Image' object, from EBImage package.
  
  If \code{cimage}'s first argument is a \verb{cell.data} object, it first calls \code{\link{get.cell.image}} and then the \code{cimage} method for \verb{cell.image} objects. This function arranges the images of single cells according to the \code{formula} and \code{facets} arguments, and adds appropriated axis to the image. 

 For example, formula=channel~t.frame, will arrange different channels as rows and t.frame as columns. You can use several variables per term, for example formula=channel~pos+t.frame will arrange the columns first by position, and within each position by t.frame. The variable to the right varies faster than the one to the left. 
 If only the right term of the formula is defined, as in formula=~t.frame, the images are 'wrapped' around, attempting to create a square plot. \code{nx} and \code{ny} can be used to define the number of columns or rows respectively. The special keyword 'cell' can be used to indicate the samples within a group, for example formula=cell~t.frame.
 The \code{facets} argument works in a similar way. 
 }
\value{
  The function returns an invisible 'Image' object of the EBImage package. Use display to render the image or writeImage to save it. You can also use \code{plot} to print to the active device and \code{img.desc} to retrieve the description of each cell. 
}
\author{ Alan Bush }
\seealso{EBImage,display}
\examples{

if(interactive()&require(EBImage,quietly=TRUE)){
	#load example dataset
	data(ACL394filtered)
  
	#display timecourse strip of cell 5 of pos 29, channels BF and YFP
	cimage(X,channel~t.frame,subset=pos==29&cellID==5,channel=c('BF','YFP'))

	#display 7 cells (default value for N) of pos 29
	cimage(X,...+channel~t.frame,subset=pos==29,channel=c('BF','YFP'))

	#display 3 cells from each pos in a different facet
	cimage(X,channel~...,facets=~pos,channel=c('BF.out','YFP'),N=3,
		subset=t.frame==11&match(pos,c(1,8,15,22,29),nomatch=0)>0)

	#select one BF and many YFP images
	cimage(X,...~channel+t.frame,subset=pos==29,N=3,
		channel.subset=channel=='YFP'|(channel=='BF.out'&t.frame==11))

	#make a movie!		
	cimage(X,.~cell|t.frame,subset=pos==29,channel='YFP',N=9)
		
}

}
\keyword{manip}
\keyword{methods}

