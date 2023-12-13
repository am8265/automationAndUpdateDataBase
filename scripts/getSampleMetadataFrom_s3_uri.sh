#!/usr/bin/env bash
## e.g. Run : bash /nfs/informatics/data/am5153/scripts/getIsMergedSampleBatch.sh RM7795_samples.176.txt
## will generate a batch sql commands cmds.sql.RM7795_samples.176.txt.sh to get is_merged from sequenceDB ##
file="$1"
sample_type="$2"
sample=$(cat ${file} | sed -e "s/^/'/g" -e "s/$/'/g" | tr '\n' ',' | sed 's/,$//g')
echo "mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e \"USE s3_uri; select sample_internal_name, key from bam where sample_type = '${sample_type}' and sample_internal_name in (${sample});\"" > cmds.sql.${file}.sh
