\name{append.oif}
\alias{append.oif.time}
\alias{append.oif.interval}
\alias{OIF}

\title{Append Variables from OIF files}
\description{
This functions create new variables containing information of OIF (Olympus Image Format) files.
}
\usage{
append.oif.time(X,OIF.date='OIF-date.txt',path=getwd(),pos.digits=2
  ,oif.digits=2)
}
\arguments{
  \item{X}{cell.data object }
  \item{OIF.date}{string containing the name of the OIF-date file (see details).}
  \item{path}{path to the OIF-date file (see details). Working directory is used by default.}	
  \item{pos.digits}{Integer indicating the number of digits expected for position.}	
  \item{oif.digits}{Integer indicating the number of digits expected to specify the file number within a position.}	
}
\details{
	This function can be used to add the time information of a OIF (Olympus Image Format) file to the cell.data object. To do so you first have to generate a single text file with the time information of all the .oif files. To create this file (OIF-date.txt) in Windows you can use the following scripts
	
	oif2txt.bat: \code{for \%\%i in (*.oif) do type \%\%i > \%\%~ni.txt}
	
	selectLineFromOif.bat: \code{sfk filter -ls+"ImageCaputre" -file .txt > OIF-date.txt}

	The first one changes the encoding of the .oif files, from Unicode to ASCII. The second one uses sfk (\url{http://swissfileknife.sourceforge.net/}) to extract the time information from each oif file. The OIF-date.txt file should look like this: \cr

	01_01_YPP3662_XYZ.txt : \cr
		ImageCaputreDate='2011-08-20 11:15:59' \cr
		ImageCaputreDate+MilliSec=984 \cr

	The oif filenames are expected to be of the form ??_??_* where ? are digits [0-9]. The digits before the underscore specify the position, and the digits after the underscore specify the "oif number" (number of file within a position). \code{pos.digits} and \code{oif.digits} specify the expected digits for these numbers respectively.
 
}
\value{
  returns a cell.data object, with appended variables
}
\author{Alan Bush}
\seealso{ \code{\link{merge.cell.data}}}
\examples{
\dontrun{
X<-append.oif.time(X)
}
}
\keyword{manip}