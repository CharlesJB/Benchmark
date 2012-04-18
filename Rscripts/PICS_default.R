#!/usr/bin/env Rscript

################################
# Functions

parseOptions <- function(toParse, options) {
	if (length(options) == 0) {
		return("N/A")
	}
	splittedOptions <- unlist(strsplit(options, split=" "))
	index <- which(splittedOptions == toParse)
	if (length(index != 0)) {
		return(options[index+1])
	} else {
		return("N/A")
	}
}

setOption <- function(optionName, options, defaultValues) {
	optionValue <- parseOptions(optionName, options)
	if (optionValue == "N/A") {
		optionValue <- parseOptions(optionName, defaultValues)
		if (optionValue == "N/A") {
			quit(paste("Unknown option:", optionName))
		}
	}
	if (optionValue == "NULL") {
		optionValue <- NULL
	}
	return(optionValue)
}


################################
# Validate arguments

arguments <- commandArgs(trailingOnly = T)

processors <- as.numeric(arguments[1])
treatmentFile <- arguments[2]
inputFile <- arguments[3]
options <- arguments[4]
outputFileName <- arguments[5]

if (length(arguments) != 1 && length(arguments) != 5) {
	write("	Usage:","")
	write("	PICS_default.R <Processors> <TreatmentFile> <InputFile> <Options> <OutputName>","")
	write("	Processors: number of processors that the script is allowed to use for the analysis","")
	write("	TreatmentFile: bed file for treatment (without header)","")
	write("	Inputfile: bed file for input (without header). Enter NULL if no input","")
	write("	Options: the name of the option followed by it's value (separated with a space)","")
	write("	OutputName: the name of the results file","")
	q()
}
if (arguments[1] == "--version" || arguments[1] == "-v") {
	write("PICS_default.R version 0.1","")
	q()
}
if (!file.exists(treatmentFile)) {
	stop(paste("Cannot find treatment file:", arguments[1]))
}
if (inputFile != "NULL" && !file.exists(inputFile)) {
	stop(paste("Cannot find input file:", inputFile))
}

################################
# Libraries

library(PICS)
library(rtracklayer)
library(snowfall)
sfInit(parallel=TRUE,cpus=processors)
sfLibrary(PICS)


################################
# Extract options

segDefault <- c("map", "NULL", "minReads", "2", "minReadsInRegion", "3", "jitter", FALSE, "dataType", "TF", 
	     "maxLregion", "0", "minLregion", "100")

map <- setOption("map", options, segDefault)
minReads <- as.numeric(setOption("minReads", options, segDefault))
minReadsInRegion <- as.numeric(setOption("minReadsInRegion", options, segDefault))
jitter <- as.logical(setOption("jitter", options, segDefault))
dataType <- setOption("dataType", options, segDefault)
maxLregion <- as.numeric(setOption("maxLregion", options, segDefault))
minLregion <- as.numeric(setOption("minLregion", options, segDefault))


################################
# Do the actual analysis

#Read the experiment : 
write("Reading treatment file...", "")
dataIP <- read.table(treatmentFile,header=FALSE,colClasses=c("factor","integer","integer","factor"))
colnames(dataIP) <- c("chromosome", "start", "end", "strand")
dataIP <- as(dataIP,"RangedData")
dataIP <- as(dataIP,"GenomeData")

#Read the control :
write("Reading control file...", "")
if (inputFile == "NULL") {
	dataCont <- NULL
	write("No control file.", "")
} else {
	dataCont <- read.table(inputFile,header=FALSE,colClasses=c("factor","integer","integer","factor"))
	colnames(dataCont) <- c("chromosome", "start", "end", "strand")
	dataCont <- as(dataCont,"RangedData")
	dataCont <- as(dataCont,"GenomeData")
}

#Load mappability profile
if (length(map) != 0) {
	if (!file.exists(map)) {
	stop(paste("Cannot find input file:", map))
	} else {
		map<-read.table(file.path(path,"mapProfileShort"),header=TRUE,
				colClasses=c("factor","integer","integer","NULL"))
		map<-as(map,"RangedData")
		# Remove the chrM
		map<-map[-23]
	}
}

# Segment the reads
seg<-segmentReads(dataIP, dataC=dataCont, map=map, minReads=minReads, minReadsInRegion=minReadsInRegion,
		  jitter=jitter, dataType=dataType, maxLregion=maxLregion, minLregion=minLregion)


# PICS analysis
pics<-PICS(seg)


####################################################
#### code chunk number 8: FDR estimation
####################################################
#segC<-segmentReads(dataCont,dataC=dataIP,map=map,minReads=1)
#picsC<-PICS(segC,dataType="TF")
#fdr<-picsFDR(pics,picsC,filter=list(delta=c(50,Inf),se=c(0,50),sigmaSqF=c(0,22500),sigmaSqR=c(0,22500)))
#
#
####################################################
#### code chunk number 9: plot-FDR1
####################################################
#plot(pics,picsC,xlim=c(2,8),ylim=c(0,.2),filter=list(delta=c(50,300),se=c(0,50),sigmaSqF=c(0,22500),sigmaSqR=c(0,22500)),type="l")
#
#
####################################################
#### code chunk number 10: plot-FDR2
####################################################
#plot(fdr[,c(3,1)])
#
#
####################################################
#### code chunk number 11: Create RangedData data object of enriched regions
####################################################
myFilter=list(delta=c(50,300),se=c(0,50),sigmaSqF=c(0,22500),sigmaSqR=c(0,22500))
rdBed<-makeRangedDataOutput(pics,type="bed",filter=c(myFilter,list(score=c(1,Inf))))
#
#
####################################################
#### code chunk number 12: Create the bed file (eval = FALSE)
####################################################
#library(rtracklayer)
export(rdBed,outputFileName)

#
####################################################
#### code chunk number 13: Create the wig file (eval = FALSE)
####################################################
### rdBed<-makeRangedDataOutput(pics,type="wig",filter=c(myFilter,list(score=c(1,Inf))))
### export(rdBed,"myfile.wig")
#
#
####################################################
#### code chunk number 14: PICS.Rnw:179-180
####################################################
sfStop()
