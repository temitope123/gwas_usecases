#!/bin/bash

#pedfile="hapmap"

for ped in *.bed; do

pedfile="${ped:0:3}"

#echo "$pedfile"
#read f;

plink --bfile $pedfile --recode --out liftedped/$pedfile


echo "Working on BED file for liftover..."
gawk '{print "chr"$1, $4, $4+1, $2}' OFS="\t" liftedped/${pedfile}.map > ${pedfile}.BED

echo "Done with bed file: check head/tail of file"
head ${pedfile}.BED
echo "tail"
tail ${pedfile}.BED

echo "Ready for liftover! press enter to continue..."
read f
liftOver -bedPlus=4 ${pedfile}.BED hg18ToHg19.over.chain ${pedfile}.HG19.BED ${pedfile}_unmapped.txt


gawk '/^[^#]/ {print $4}' ${pedfile}_unmapped.txt > ${pedfile}_unmappedSNPs.txt # print lines starting witout #


gawk '{print $4, $2}' OFS="\t" ${pedfile}.HG19.BED > ${pedfile}.HG19.mapping.txt

echo "Done with liftover! press enter to update plink files"
read f

plink --file liftedped/${pedfile} --exclude ${pedfile}_unmappedSNPs.txt --update-map ${pedfile}.HG19.mapping.txt --make-bed --out HG19/${pedfile}.HG19
mv *.txt logs/
mv *.BED logs/
done
