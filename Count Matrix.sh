#load SAMtools
module load SAMtools/1.10-GCC-8.3.0
#index 1 bam files
samtools index PGO_AA_CAGATC_L008_R1_001.trimmomatic_out.fastqAligned.sortedByCoord.out.bam
#loop
for i in *.bam; do samtools index $i; done 
