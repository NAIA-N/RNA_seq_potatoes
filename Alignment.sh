#Alighment 
cd /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results
#loading Module
module purge; module load bluebear
module load STAR/2.7.2b-GCC-8.3.0
#create output folder
mkdir Mapped_reads

#generating genome index with star
STAR --runThreadN 15 --runMode genomeGenerate --genomeDir /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/star_index/ --genomeFastaFiles /rds/projects/l/leachlj-potato-qtl-project/SharedGenomeFiles/reference_potato/potato_dm_v404_all_pm_un.fasta --sjdbGTFfile /rds/projects/l/leachlj-potato-qtl-project/SharedGenomeFiles/reference_potato/potato_dm_mixed.gtf --genomeSAindexNbases 13 --sjdbOverhang 49 --outFileNamePrefix /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/star_index/indexing_

#read alignment for one fastq
STAR --runThreadN 15 --genomeDir /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/star_index --runMode alignReads --readFilesIn /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/Trimmed_output/PGO_AA_CAGATC_L008_R1_001.trimmomatic_out.fastq --alignIntronMin 20 --quantMode GeneCounts --outSAMtype BAM SortedByCoordinate --outFilterMismatchNmax 10 --outReadsUnmapped Fastx --outFileNamePrefix /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/mapped_reads/PGO_AA_CAGATC_L008_R1_001.trimmomatic_out.fastq

#practice loop three fast q
for i in *.fastq; do STAR --runThreadN 15 --genomeDir /rds/projects/l/leachlj-potato-qtl-project/SharedGenomeFiles/star_index_potato/ --runMode alignReads --readFilesIn $i  --alignIntronMin 20 --outSAMtype BAM SortedByCoordinate --outFilterMismatchNmax 10 --quantMode GeneCounts --outReadsUnmapped Fastx --outFileNamePrefix /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/mapped_reads/$i; done

#trimmed fastq files
cd /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/Trimmed_output
#loop
for i in *.fastq; do STAR --runThreadN 15 --genomeDir /rds/projects/l/leachlj-potato-qtl-project/SharedGenomeFiles/star_index_potato/ --runMode alignReads --readFilesIn $i  --alignIntronMin 20 --quantMode GeneCounts --outSAMtype BAM SortedByCoordinate --outFilterMismatchNmax 10  --outReadsUnmapped Fastx --outFileNamePrefix /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/Mapped_reads/$i; done





















