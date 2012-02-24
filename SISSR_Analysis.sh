#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-02-13
# based on BlueTsunami: github.com/sebhtml/NGS-Pipelines/blob/master/BlueTsunami

source $DARK_FISH_TECHNOLOGY
source $BENCHMARKTOOLS

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
DarkFishTechnology_runCommand 0 "eland2bed --version &> meta/eland2bed.version"
# Note: There is no --version or equivalent with sissrs, this have to be hardcoded
#       and manually changed when a new version is used.
DarkFishTechnology_runCommand 0 "echo \"sissrs v1.4\" &> meta/sissrs.version"

# Prepare samples
BenchmarkTools_prepareSamples

# Convert sample for analysis
BenchmarkTools_convertSamples "SISSRs"

# Do the actual analysis
BenchmarkTools_getRawSISSRsResults
DarkFishTechnology_purgeGroupCache "FormatedSamples"

# Trim results
BenchmarkTools_trimSISSRsResults
DarkFishTechnology_purgeGroupCache "RawResults"

# Link peak list in main folder for subsequent analysis
BenchmarkTools_linkSISSRsPeakList
