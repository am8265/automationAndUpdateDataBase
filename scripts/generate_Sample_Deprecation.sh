#!/usr/bin/bash
sample_list="$1"
flowcellID="$3"
project="$2"
if flowcellID=""; then flowcellID="*"; fi
## step2
cat ${sample_list} | while read -r line
do
  ls -1d /nfs/seqscratch_ssd/BCL/*${flowcellID}*_Unaligned/*${project}*/*${line}*fastq.gz >> delFASTQ.step2.txt
  #step3 --delete alignment 
  ls -1d /nfs/seqscratch_ssd/ALIGNMENT/BUILD37/DRAGEN/GENOME_AS_FAKE_EXOME/${line}* >> delAlignment.step3.txt
  ls -1d /nfs/seqscratch_ssd/ALIGNMENT/BUILD37/DRAGEN/GENOME/${line}* >> delAlignment.step3.txt
  ls -1d /nfs/seqscratch_ssd/ALIGNMENT/BUILD37/DRAGEN/EXOME/${line}* >> delAlignment.step3.txt
  #step4 --Delete the DB loading data 
  ls -1d /nfs/fastq_temp2/dh2880/ANNOTATION/DB_LOADING/GENOME_AS_FAKE_EXOME/${line}* >> delDBLoading.step4.txt
  ls -1d /nfs/fastq_temp2/dh2880/ANNOTATION/DB_LOADING/GENOME/${line}* >> delDBLoading.step4.txt
  ls -1d /nfs/fastq_temp2/dh2880/ANNOTATION/DB_LOADING/EXOME/${line}* >> delDBLoading.step4.txt
  #step5 -- Delete the shell, merged Bam files, Marked duplicates, and alignstats scripts
  ls -1d /nfs/seqscratch_ssd/informatics/logs/merge/${line}*.sh >> delShell.step5.txt
  #step6 -- Delete the component fastqs
  ls -1d /nfs/seqscratch_ssd/FASTQ/"${flowcellID}"/GENOME/${line}*/"${flowcellID}" >> delComponentFASTQ.step6.txt
  ls -1d /nfs/seqscratch_ssd/FASTQ/"${flowcellID}"/EXOME/${line}*/"${flowcellID}" >> delComponentFASTQ.step6.txt
  ls -1d /nfs/seqscratch_ssd/FASTQ/"${flowcellID}"/GENOME_AS_FAKE_EXOME/${line}*/"${flowcellID}" >> delComponentFASTQ.step6.txt
  #step7 -- 7.	Delete the archived BCL files
  ls -1d /nfs/archive/p2018/BCL/*${flowcellID}*_Unaligned >> delArchivedBCL.step7.txt
  # step8 -- 8.	Delete the archived FASTQ 
  ls -1d /nfs/archive/p2018/FASTQ/GENOME/${line}*  >> delArchivedFASTQ.step8.txt
  ls -1d /nfs/archive/p2018/FASTQ/EXOME/${line}* >> delArchivedFASTQ.step8.txt
  #step9 -- 9. Delete the archived BAM, VCF and coverage Files
  ls -1d /nfs/archive/p2018/ALIGNMENT/BUILD37/DRAGEN/GENOME/${line}* >> delArchivedBAM_VCF_coverageFiles.step9.txt
  ls -1d /nfs/archive/p2018/ALIGNMENT/BUILD37/DRAGEN/GENOME_AS_FAKE_EXOME/${line}* >> delArchivedBAM_VCF_coverageFiles.step9.txt
  ls -1d /nfs/archive/p2018/ALIGNMENT/BUILD37/DRAGEN/EXOME/${line}* >> delArchivedBAM_VCF_coverageFiles.step9.txt
done
