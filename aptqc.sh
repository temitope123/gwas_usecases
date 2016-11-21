#!/bin/bash

lib=$HOME/AffyLibfiles
cel=$HOME/phase1_data
result=$cel/qcresult
#ensure apt-geno-qc is in your usr/local/bin
#run script from cel file directory
#
echo "Start: Cel QC"
 apt-geno-qc --cdf-file $lib/GenomeWideSNP_6.cdf \
--qca-file $lib/GenomeWideSNP_6.r2.qca \
--qcc-file $lib/GenomeWideSNP_6.r2.qcc \
--chrX-probes $lib/GenomeWideSNP_6.chrXprobes \
--chrY-probes $lib/GenomeWideSNP_6.chrYprobes \
--cel-files $cel/cel-files.txt --out-file $result/result.txt

