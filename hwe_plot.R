args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  file = args[1];
}
#Load HWE P-value file and generate frequency_distribution
#b.frq <- read.table("/home/darefalola/d__data/data/cubreqc.hwe",header=T)
b.frq <- read.table(file,header=T)
pdf("plots/hwe_plot.pdf")
b.frq$logP = log10(b.frq$P)

plot(ecdf(b.frq$logP), xlim=c(-10,0),ylim=c(0,0.8), pch=20, main="HWE P-value",xlab="logP (HWE)", ylab="Fraction of SNPs",axes=T)
log10(0.00001)
abline(v=log10(0.00001), col="RED", lty=2)
#?ecdf
#y <- seq(from=0, to=0.8, by=0.1)
