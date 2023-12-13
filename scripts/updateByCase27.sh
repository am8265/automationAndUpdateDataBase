#!/usr/bin/env bash
## e.g. Run : bash /nfs/informatics/data/am5153/scripts/getIsMergedSampleBatch.sh pseudo_prepID.txt
## will generate a batch sql commands cmds.sql.RM7795_samples.176.txt.sh to get is_merged from sequenceDB ##
file="$1" # list of pseudo_prepID
root_name=$(basename ${file})
if [ -f updateCase27.${root_name}.sql ]; then rm -f updateCase27.${root_name}.sql; fi

echo "USE sequenceDB;" > updateCase27.${root_name}.sql
cat ${file} | while read -r line
do
  diff_in_sec_step31=$(mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e "USE sequenceDB; SELECT difference_in_seconds FROM (SELECT pipeline_step_id, finish_time, TIMESTAMPDIFF(SECOND, finish_time, LEAD(finish_time) OVER ()) AS difference_in_seconds FROM dragen_pipeline_step WHERE pseudo_prepid = $line ) AS subquery where pipeline_step_id=31 AND difference_in_seconds <= 0;" | tail -n+2)
  if [ $diff_in_sec_step31 -le 0 ]; then
    # UPDATE step 31 with a timestamp lagging by 1 sec from step 32 
    echo "UPDATE dragen_pipeline_step SET finish_time = finish_time + INTERVAL ($diff_in_sec_step31 -1) SECOND WHERE pipeline_step_id = 31 and pseudo_prepid = $line;" >> updateCase27.${root_name}.sql
    echo "UPDATE prepT SET status = 'In DragenDB' where prepT.p_prepID = $line;" >> updateCase27.${root_name}.sql
  fi
done
   
