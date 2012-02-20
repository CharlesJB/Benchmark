#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-02-13
# based on BlueTsunami: github.com/sebhtml/NGS-Pipelines/blob/master/BlueTsunami


# the argument must not be absolute paths.
processors=$1
fileFormat=$2
output=$3
options=$4
treatmentFile=$5
controlFile=$6

mkdir $output
cd $output

source $DARK_FISH_TECHNOLOGY
source $BENCHMARKTOOLS

DarkFishTechnology_initializeDirectory
DarkFishTechnology_runCommand 0 "eland2bed --version &> meta/eland2bed.version"

# Prepare samples
BenchmarkTools_prepareSample $treatmentFile
BenchmarkTools_prepareSample $controlFile

# Convert sample for analysis
BenchmarkTools_convertSamplesSISSRs

# Do the actual analysis
BenchmarkTools_getRawSISSRsResults
DarkFishTechnology_purgeGroupCache "FormatedSamples"

# Trim results
BenchmarkTools_trimSISSRsResults
DarkFishTechnology_purgeGroupCache "RawResults"
