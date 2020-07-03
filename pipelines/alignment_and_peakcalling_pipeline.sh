#!/usr/local/bin/bash

export PATH=/homes/dazazi/software/bwa-0.7.12/:$PATH
export PATH=/homes/dazazi/software/samtools-1.2/:$PATH
export PATH=/homes/dazazi/software/MACSv2/bin/:$PATH

#Align fastq files to BL6/CAST indexed assembly.

bwa index -a bwtsw /genome/mm10.fa
bwa mem /genome/mm10.fa CTCF_ChIPseq_library.p1.fq CTCF_ChIPseq_library.p2.fq > CTCF_ChIPseq_library.sam

# Fetch uniquely mapped reads, outputting filtered SAM alignment files

fgrep -w "XT:A:U" CTCF_ChIPseq_library.sam > CTCF_ChIPseq_library_filtered.sam

#Convert SAM file to BAM, followed by sorting the BAM file

samtools view -bSo CTCF_ChIPseq_library.bam CTCF_ChIPseq_library_filtered.sam
samtools sort CTCF_ChIPseq_library.bam CTCF_ChIPseq_library.sorted

#Index sorted BAM file

samtools index CTCF_ChIPseq_library.sorted.bam

#NOTE: repeat all steps above for control/input libraries

#Peak-calling using MACS2 with default parameters

macs2 callpeak -t CTCF_ChIPseq_library.sorted.bam -c CTCF_ChIPseq_input.sorted.bam -f 'BAM' -g 'mm' -n CTCF_ChIPseq_library -B --call-summits -p 0.001

