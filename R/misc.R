#Paste data and error in pretty format
#ToDo: test for vectorial input
#ToDo: add examples to documentation
#ToDo: see if using round_any simplyfies the code
paste_data_error <- function(data,error,error.signif=1,plotmath=FALSE) {
	data.digits=floor(log10(abs(ifelse(data==0,1,data))))
	error.digits=floor(log10(abs(error)))
	digits <- error.digits - error.signif + 1
	pm.sign=intToUtf8(177)
	if(isTRUE(plotmath)) pm.sign<-"%+-%"

	x=10^digits*round(data/(10^digits))
	d=data.digits-error.digits+error.signif
	data.str<-as.character(10^digits*round(data/(10^digits)))
	for(i in (1:length(x))[!digits>=0])
		data.str[i]<-sapply(x[i],formatC,digits=max(d[i],1),format="fg",flag="#")
	
	x=10^digits*round(error/(10^digits))
	d=abs(error.digits)+error.signif-as.numeric(error<1)
	error.str<-as.character(10^digits*round(error/(10^digits)))
	
	return(paste(data.str,error.str,sep=pm.sign))
}

paste_parameter <- function(fit,param,error.signif=1){
	if(class(fit)=="nls"){
		fit.param<-summary(fit)$parameters
	} else if (class(fit)=="lm"){
		fit.param<-summary(fit)$coefficients
	} else {
		stop("Unknow class for fit:",class(fit),"\n")
	}

	paste_data_error(
		fit.param[param,1] #Estimate
		,fit.param[param,2] #Std. Error
	,error.signif=error.signif)
}

paste_intercept_slope <- function(fit,error.signif=1){
	if(class(fit)!="lm") stop("lm fit expected\n")
	fit.param<-summary(fit)$coefficients
	return(paste(c("Intercept","Slope")
		,paste_data_error(
			fit.param[1:2,1] #Estimate
			,fit.param[1:2,2] #Std. Error
		,error.signif=error.signif),sep="=",collapse=" ")
		)
}

paste_EC50_n <- function(fit,leading.str="",error.signif=2){
	paste(leading.str,"EC50=",paste_parameter(fit,"EC50",error.signif=error.signif),
	      "nM n=",paste_parameter(fit,"n",error.signif=error.signif)
	,sep="")
}

write.delim<-function(x, file = "", quote = FALSE, sep = "\t", row.names = FALSE,...){
	write.table(x,file=file,quote=quote,sep=sep,row.names=row.names,...)
}

#*************************************************************************#
#generic
#Creates the generic function flatten
flatten <- function(df,...) UseMethod("flatten")

flatten.data.frame <- function(df){
	
	require(foreach)

	foreach(i=as.list(df),n=names(df),.combine=cbind) %do% {
		o<-as.data.frame(i)
		if(is.matrix(i)){
			names(o)<-paste(colnames(i),n,sep=".")
		} else {
			names(o)<-n
		}
		o
	}
}

revFactor <- function(x)factor(x, levels = rev(levels(x)),ordered=TRUE)

