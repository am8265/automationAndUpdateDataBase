#!/usr/bin/env bash
sample_file="$1"
sampleInternalName=$(cat ${sample_file} | sed -e 's/^/"/g' -e 's/$/"/g' | tr '\n' ',' | sed 's/,$//g') 

mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq -e "USE sequenceDB; SELECT dqc.pseudo_prepid, dqc.WGS_Mean_Cov, ROUND(dqc.WGS_Mean_Cov, 3) AS ROUND_WGS_Mean_Cov FROM dragen_qc_metrics AS dqc, prepT AS pT WHERE dqc.pseudo_prepid =  pT.p_prepID AND pT.sample_internal_name IN (${sampleInternalName});" > wgs_mean_cov_rounded.list.txt

echo "USE sequenceDB;" > batchUpdateWGS_Mean_Cov.sql
cat wgs_mean_cov_rounded.list.txt | tail -n+2 | while read -r line
do
  pseudo_prepid=$(echo $line| cut -f1 -d ' ')
  rounded_WGS=$(echo $line| cut -f3 -d ' ')
  echo "UPDATE dragen_qc_metrics SET WGS_Mean_Cov = ${rounded_WGS} WHERE pseudo_prepid = ${pseudo_prepid};" >> batchUpdateWGS_Mean_Cov.sql
done
# Run the batchUpdateWGS_Mean_Cov.sql file
#mysql --defaults-file=/home/am5153/.my.cnf -u am5153 -h prodseq < batchUpdateWGS_Mean_Cov.sql
