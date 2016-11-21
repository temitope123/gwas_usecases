#!/bin/bash
pops=(CEU JPT CHB YRI)
for i in "${pops[@]}"; do
 plink --bfile "$i" --exclude apops-merge.missnp --make-bed --out "merged2/$i"
done

plink --merge-list merge.txt --make-bed --out apops
