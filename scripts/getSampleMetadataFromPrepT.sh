#!/usr/bin/env bash
## e.g. Run : bash /nfs/informatics/data/am5153/scripts/getIsMergedSampleBatch.sh RM7795_samples.176.txt
## will generate a batch sql commands cmds.sql.RM7795_samples.176.txt.sh to get is_merged from sequenceDB ##
file="$1"
sample=$(cat ${file} | sed -e "s/^/'/g" -e "s/$/'/g" | tr '\n' ',' | sed 's/,$//g')
echo "mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e \"USE sequenceDB; select pt.sample_internal_name, pt.libKit, pt.exomeKit, pt.sample_type from prepT pt, dragen_sample_metadata dsm where dsm.pseudo_prepid = pt.experiment_id AND pt.status = 'In DragenDB' AND pt.sample_internal_name in (${sample});\"" > cmds.sql.${file}.sh
