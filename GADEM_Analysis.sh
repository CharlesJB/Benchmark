#!/bin/bash

source /home/cjbparlant/git-clones/NGS-Pipelines/LoadModules.sh
source $DARK_FISH_TECHNOLOGY
source $BENCHMARKTOOLS

numberOfProcessors=$1
inputDir=$2
outputDir=$3

export OMP_NUM_THREADS=$numberOfProcessors
mkdir $outputDir
cd $outputDir
DarkFishTechnology_initializeDirectory

for file in ../$inputDir/*
do
	out=$(basename $file)
	out=${out%.*}.rda
	DarkFishTechnology_runCommand 0 "( Rscript $RSCRIPTS_PATH/GADEM_default.R $file $out ) ; "
#	commandResults="( Rscript $RSCRIPTS_PATH/GADEM_default.R $file $out ) ; "
#	DarkFishTechnology_runCommand 0 $commandResults
	DarkFishTechnology_runCommand 0 "mv $out $outputDir/"
done

wait
