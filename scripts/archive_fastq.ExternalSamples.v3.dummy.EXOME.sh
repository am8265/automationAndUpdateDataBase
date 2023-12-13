samples_file="$1"
fcid="HDUMM2022" # optional
# just run each archive cmds, since rsync checks destination dir, with source dir. Will throw errors when if source dir doesn't have any files. So DO NOT RERUN!
if [ -f batch.cmdsToCreateDir.${samples_file}.sh ]; then rm batch.cmdsToCreateDir.${samples_file}.sh; fi
if [ -f batch.cmdsToArchive.${samples_file}.sh ]; then rm batch.cmdsToArchive.${samples_file}.sh; fi
if [ -f samplesToArchive.${samples_file}.txt ]; then rm samplesToArchive.${samples_file}.txt; fi
cat ${samples_file} | while read -r line
do
  is_merged=$(mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e "USE sequenceDB; SELECT is_merged FROM dragen_sample_metadata WHERE sample_name = '${line}';" | tail -n+2)
  if [[ $is_merged -eq '40' ]] && [ "$(ls -A ${line}/FASTQ)" ] # when sample inDragenDB and sample/FASTQ/ is non-empty i.e archival incomplete/NOT started
  then
    echo "mkdir -p /nfs/archive/p2018/FASTQ/EXOME/${line}/${fcid}" >> batch.cmdsToCreateDir.${samples_file}.sh
    echo "${line}" >> samplesToArchive.${samples_file}.txt
  fi 
done

## run batch.cmdsToArchive.${samples_file}.sh like this with parallel
## cat batch.cmdsToArchive.${samples_file}.sh | parallel -j10 {}
