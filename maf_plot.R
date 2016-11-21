args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  file = args[1];
}
#imiss <- read.table(imissfile,header=T)

#Load SNP frequency file and generate cumulative freequency distribution
#b.frq <- read.table("/home/darefalola/phase2_data/cub.frq",header=T)
b.frq <- read.table(file, header=T)
pdf("plots/maf_plot.pdf")
plot(ecdf(b.frq$MAF), xlim=c(0,0.10),ylim=c(0,1),pch=20, main="MAF cumulative distribution",xlab="Minor allele frequency (MAF)", ylab="Fraction of SNPs",axes=T)

abline(h=0.1,col="gray32",lty=2)
