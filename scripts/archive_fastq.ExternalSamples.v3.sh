samples_file="$1"
fcid="$2" # optional
# just run each archive cmds, since rsync checks destination dir, with source dir. Will throw errors when if source dir doesn't have any files. So DO NOT RERUN!
if [ -f batch.cmdsToCreateDir.${samples_file}.sh ]; then rm batch.cmdsToCreateDir.${samples_file}.sh; fi
if [ -f batch.cmdsToArchive.${samples_file}.sh ]; then rm batch.cmdsToArchive.${samples_file}.sh; fi
cat ${samples_file} | while read -r line
do
  echo $fcid
  is_merged=$(mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e "USE sequenceDB; SELECT is_merged FROM dragen_sample_metadata WHERE sample_name = '${line}';" | tail -n+2)
  if [[ $is_merged -eq '40' ]] && [ "$(ls -A ${line}/FASTQ)" ] # when sample inDragenDB and sample/FASTQ/ is non-empty i.e archival incomplete/NOT started
  then
    if [[ "${fcid}" != 'dummy' ]]; then fcid=$(ls -1d ${line}/backup/*fastq.gz | head -n1 | awk -F'/' '{print $NF}' | awk -F'_' '{print $(NF-3)}'); else fcid="HDUMM2022"; fi  
    #echo $fcid >> test.sh
  fi 
done

## run batch.cmdsToArchive.${samples_file}.sh like this with parallel
## cat batch.cmdsToArchive.${samples_file}.sh | parallel -j10 {}
