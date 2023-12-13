#!/usr/bin/env bash
## e.g. Run : bash /nfs/informatics/data/am5153/scripts/getIsMergedSampleBatch.sh RM7795_samples.176.txt
## will generate a batch sql commands cmds.sql.RM7795_samples.176.txt.sh to get is_merged from sequenceDB ##
file="$1"
sample=$(cat ${file} | sed -e "s/^/'/g" -e "s/$/'/g" | tr '\n' ',' | sed 's/,$//g')
echo "mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e \"USE sequenceDB; UPDATE dragen_sample_metadata SET is_merged = 2 WHERE is_merged = -10 AND dsm_update <= NOW() - INTERVAL 10 MINUTE AND sample_name IN (${sample});\"" > cmds.sql.updateIsMergedFrom-10To2.${file}.sh
