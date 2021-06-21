#screen timeout for no disruptions
$ screen
#for list of things for screen
Ctrl+a ?
#You can detach from the screen session at any time
Ctrl+a d
#To resume your screen session use the following command:
screen -r


#loading module
module purge; module load bluebear
# Quality Control
cd /rds/projects/l/leachlj-potato-qtl-project

module load FastQC/0.11.9-Java-11
##------linux-----##
$ mkdir fastqc_output
 #-t 14 helps speed up the command time

$ fastqc /rds/projects/l/leachlj-potato-qtl-project/rawdata/mRNA/AB/PGO_AB_CTTGTA_L008_R1_001.fastq -o /rds/projects/l/leachlj-potato-qtl-project/NA_Area/fastqc_output -t 14 
$ fastqc /rds/projects/l/leachlj-potato-qtl-project/rawdata/mRNA/*/*.fastq -o /rds/projects/l/leachlj-potato-qtl-project/NA_Area/fastqc_output -t 14 
$ for zip in *.zip; do unzip $zip; done       #unzip output files
#Press control+A at the same time, then d very quickly afterwards - To check that the code is running check with $ top - To return to see the code $ screen –r
($ cat */summary.txt > ./fastqc_summaries.txt     #extract summary reports and combine into one txt file)

MultiQC
module load MultiQC/1.9-foss-2019b-Python-3.7.4
multiqc /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/fastqc_output/*_fastqc.zip
# uses default multiQC 
#sp:
  #fastqc/data:
    #fn: "fastqc_data.txt"
 #fastqc/zip:
    #fn: "*_fastqc.zip"


module load Trimmomatic/0.39-Java-11
$ mkdir Trimmed_output
#Addaptors downloaded from https://github.com/timflutre/trimmomatic/tree/master/adapters 
## one sample
#java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE ..sample.gz ILLUMINACLIP:../TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:30
#first sample
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE /rds/projects/l/leachlj-potato-qtl-project/rawdata/mRNA/AA/PGO_AA_CAGATC_L008_R1_001.fastq /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_output/PGO_AA_CAGATC_L008_R1_001.fastq ILLUMINACLIP:/rds/projects/l/leachlj-potato-qtl-project/NA_Area/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:30
# hlp structure = java -jar <path to trimmomatic jar> SE [-threads <threads>] [-phred33 | -phred64] [-trimlog <logFile>] <input> <output> <step 1> ...
#test sample 
fastqc /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_output/PGO_AA_CAGATC_L008_R1_001.fastq -o /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_Fastqc_output/ -t 14 


#second repeat different parameters
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE /rds/projects/l/leachlj-potato-qtl-project/rawdata/mRNA/AA/PGO_AA_CAGATC_L008_R1_001.fastq /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_output/PGO_AA_CAGATC_L008_R1_001x2.fastq ILLUMINACLIP:/rds/projects/l/leachlj-potato-qtl-project/NA_Area/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:40
# hlp structure = java -jar <path to trimmomatic jar> SE [-threads <threads>] [-phred33 | -phred64] [-trimlog <logFile>] <input> <output> <step 1> ...
#test sample 
fastqc /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_output/PGO_AA_CAGATC_L008_R1_001x2.fastq -o /rds/projects/l/leachlj-potato-qtl-project/NA_Area/Trimmed_Fastqc_output/ -t 14 



#loop trimm all
#create text with file name
find . -type f \( -name "*.fastq" \) > /rds/projects/l/leachlj-potato-qtl-project/NA_Area/filename.text


#loop
# didn't use cat Filename2test.txt | xargs -n 1 bash trimming.sh


####Trimming###
files=(`ls /rds/projects/l/leachlj-potato-qtl-project/rawdata/mRNA/*/*.fastq`)
files=(`ls rawdata/*/*.fastq`)

for ((i=0; i < ${#files[@]}; i++)); do
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -threads 4 ${files[$i]} "/rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Trimmed_output/`basename ${files[$i]} .fastq`.trimmomatic_out.fastq" ILLUMINACLIP:/rds/projects/l/leachlj-potato-qtl-project/NA_Area/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:30
done

###############
#trimming QC
module load FastQC/0.11.9-Java-11
##------linux-----##
$ mkdir Trim_fastqc
$ fastqc /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Trimmed_output/*.fastq -o /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Trim_fastqc -t 14 
$ for zip in *.zip; do unzip $zip; done       #unzip output files



MultiQC
module load MultiQC/1.9-foss-2019b-Python-3.7.4
$ mkdir Trim_multiqc
multiqc /rds/projects/l/leachlj-potato-qtl-project/NA_AreaOnly/Results/Trim_fastqc/*_fastqc.zip
# uses default multiQC 


