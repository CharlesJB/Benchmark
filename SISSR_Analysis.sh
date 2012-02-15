#!/bin/bash
# author: Charles Joly Beauparlant
# date: 2012-02-13
# based on BlueTsunami: github.com/sebhtml/NGS-Pipelines/blob/master/BlueTsunami

treatmentFileOrigin=$1

# the argument must not be absolute paths.
inputFileOrigin=$2
processors=$3
output=$4
command=$5

mkdir $output
cd $output

source $DARK_FISH_TECHNOLOGY

DarkFishTechnology_initializeDirectory

#DarkFishTechnology_prepareReference $treatmentFileOrigin
BenchmarkTools_prepareSampleSISSR $treatmentFileOrigin 
BenchmarkTools_prepareSampleSISSR $inputFileOrigin 
DarkFishTechnology_prepareSample $inputFileOrigin

# TODO get R's sessionInfo (utiliser /dev/null pour eviter trop de blabla?

# Prepare sample
