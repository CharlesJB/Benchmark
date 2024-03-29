#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-02-22
# based on BlueTsunami: github.com/sebhtml/NGS-Pipelines/blob/master/BlueTsunami
# Note: cisGenome produces *.bar files that can be used for vizualition on their 
# 	browser. Unfortunately, since those files are very large, they will not 
#	be kept for the Benchmark Analysis.

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
# Note: There is no --version or equivalent with cisGenome, this have to be hardcoded
#       and manually changed when a new version is used.
DarkFishTechnology_runCommand 0 "echo \"cisGenome v2.0\" &> meta/cisGenome.version"

# Prepare samples
BenchmarkTools_prepareSamples

# Convert sample for analysis
BenchmarkTools_convertSamples "cisGenome"
BenchmarkTools_prepareSamplesLists

# Do the actual analysis
BenchmarkTools_getRawcisGenomeResults
#DarkFishTechnology_purgeGroupCache "FormatedSamples"

# Trim results
BenchmarkTools_trimcisGenomeResults
DarkFishTechnology_purgeGroupCache "RawResults"

# Link peak list in main folder for subsequent analysis
BenchmarkTools_linkcisGenomePeakList
