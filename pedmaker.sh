#!/bin/bash

annot=$home/gwasfiles/annotationFiles
output=$home/phase1/pedfile
result=$home/phase1/genoresult

echo "Making ped & map file...."
perl ~/phase1scripts/scripts/Perl_scripts/pedfilemaker.pl -ac $result/birdseed-v2.calls.txt \
-r $result/birdseed-v2.report.txt -an $annot/GenomeWideSNP_6.na35.annot.csv \
-o $output -n acc_data

echo "Done with ped, results are in $output"
