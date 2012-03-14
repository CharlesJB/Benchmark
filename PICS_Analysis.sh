#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-03-14
# version 0.1
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
DarkFishTechnology_runCommand 0 "R --version &> meta/R.version"
DarkFishTechnology_runCommand 0 "macs14 --version &> meta/macs.version"

# Prepare samples
BenchmarkTools_prepareSamples

# Do the actual analysis
BenchmarkTools_MACS_Analysis

# Link peak list for subsequent analysis
BenchmarkTools_linkMacsPeakList
