#Load SNP frequency file and generate histogram
b.frq <- read.table("/home/darefalola/phase2_data/cub.missing",header=T)
pdf("plots/snpmiss_plot.pdf")
plot(ecdf(b.frq$F_MISS_A,xlim=c(0,0.10),ylim=c(0,1),pch=20, main="SNP Missingness Distribution", 
     xlab="Missingness Frequency", ylab="Fraction of SNPs",col="blue",axes=T)
