#!/bin/bash

lib=$HOME/AffyLibfiles
cel=$HOME/d_data
output=$cel/genoresult2

#ensure apt-probeset-genotype is in your usr/local/bin
#run program from cel file directory

echo "Calling genotypes..."
apt-probeset-genotype -a birdseed-v2 -o $output -c $lib/GenomeWideSNP_6.cdf \
--special-snps $lib/GenomeWideSNP_6.specialSNPs \
--set-gender-method cn-probe-chrXY-ratio \
--chrX-probes $lib/GenomeWideSNP_6.chrXprobes \
--chrY-probes $lib/GenomeWideSNP_6.chrYprobes \
--read-models-birdseed $lib/GenomeWideSNP_6.birdseed-v2.models $cel/*.cel \
--summaries

echo "genotypes written to $output"
