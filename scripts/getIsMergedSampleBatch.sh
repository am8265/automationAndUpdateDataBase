#!/usr/bin/env bash
## e.g. Run : bash /nfs/informatics/data/am5153/scripts/getIsMergedSampleBatch.sh RM7795_samples.176.txt
## will generate a batch sql commands cmds.sql.RM7795_samples.176.txt.sh to get is_merged from sequenceDB ##
file="$1"
sample=$(cat ${file} | sed -e "s/^/'/g" -e "s/$/'/g" | tr '\n' ',' | sed 's/,$//g')
echo "mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e \"USE sequenceDB; select dsm.dsm_update, dsm.sample_name, dsm.experiment_id, dsm.is_merged, pt.status from dragen_sample_metadata dsm, prepT pt where pt.p_prepID = dsm.pseudo_prepid AND dsm.sample_name in (${sample});\"" > cmds.sql.${file}.sh
