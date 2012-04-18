#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-03-14
# version 0.1
# based on BlueTsunami: github.com/sebhtml/NGS-Pipelines/blob/master/BlueTsunami

source $DARK_FISH_TECHNOLOGY
source $BENCHMARKTOOLS
echo $RSCRIPTS_PATH

# Process arguments
# The arguments must not be absolute paths.
processors=$1
output=$2
fileFormat=$3
options=$4

if [ $fileFormat = "txt" ]
then
	fileName=$5	
	BenchmarkTools_extractFileInfos $fileName
else
	fileFormats[0]=$fileFormat
	treatmentFiles[0]=$5
	controlFiles[0]=$6
fi

# Prepare analysis
mkdir $output
cd $output

DarkFishTechnology_initializeDirectory
DarkFishTechnology_runCommand 0 "R --version &> meta/R.version"
DarkFishTechnology_runCommand 0 "macs14 --version &> meta/macs.version"
#DarkFishTechnology_runCommand 0 "Rscript $RSCRIPTS_PATH/sessionInfo.R &> meta/R.sessionInfo"


# Prepare samples
BenchmarkTools_prepareSamples

# Convert sample for analysis
BenchmarkTools_convertSamples "PICS"

# Do the actual analysis
BenchmarkTools_PICS_Analysis
DarkFishTechnology_purgeGroupCache "FormatedSamples"

# Link peak list for subsequent analysis
#BenchmarkTools_linkMacsPeakList
