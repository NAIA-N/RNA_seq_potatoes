#Working directory
setwd("Z:/NA_AreaOnly/Results/Analysis")
#installing package 
#if (!requireNamespace("BiocManager", quietly = TRUE))
 # install.packages("BiocManager")

#BiocManager::install("Rsubread")
#Load Rsubread
library(Rsubread)
#list of bam files 
fls <- list.files(path = "Z:/NA_AreaOnly/Results/Mapped_reads/")
fls <- fls[endsWith(fls, 'bam')]
fls <- paste0('Z:/NA_AreaOnly/Results/Mapped_reads/', fls)
fls

### creating count matrix with featureCout
countMatrix <- featureCounts(files = fls, annot.ext = 'Z:/SharedGenomeFiles/reference_potato/potato_dm_mixed.gtf',
                             isGTFAnnotationFile = TRUE, GTF.attrType = 'gene_id',primaryOnly = TRUE, isPairedEnd = FALSE, nthreads = 4)


#write.csv(x=data.frame(countMatrix$annotation[,c("GeneID","Length")],countMatrix$counts,stringsAsFactors=FALSE),file="counts.csv",quote=FALSE,sep="\t",row.names=FALSE)



