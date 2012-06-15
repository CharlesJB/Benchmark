require(rGADEM)
require(BSgenome.Hsapiens.UCSC.hg18)

arguments <- commandArgs(trailingOnly = T)
bedName <- arguments[1]
out <- arguments[2]

# Reading bed file
# print("Loading bed file...")
BED<-read.table(bedName,header=FALSE,sep="\t")
BED<-data.frame(chr = sub(".fa","",as.factor(BED[, 1])), start = as.numeric(BED[,+ 2]), end = as.numeric(BED[, 3]))
rgBED<-IRanges(start = BED[, 2], end = BED[, 3])
Sequences<-RangedData(rgBED, space = BED[, 1])

# Running gadem analysis
# print("Running gadem analysis...")
gadem <- GADEM(Sequences, seed=1,genome=Hsapiens,verbose=TRUE)
save(gadem,file=out)
