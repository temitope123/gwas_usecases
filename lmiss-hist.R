args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  file = args[1];
}
imiss <- read.table(file,header=T)

#x<-read.table("/home/darefalola/accd/phase1/cubreqc.lmiss",header=T)
#x<-read.table(file,header=T)

ylabels=c("0","20K","40K","60K","80K","100K")
xlabels=c("0.0001","0.001","0.01","0.1","1")
#par(mfrow=c(1,1))
pdf("plots/lmiss.pdf")
q <- na.omit(imiss$F_MISS)
hist(log10(q),axes=F,xlim=c(-4,0),col="BLUE",ylab="Number of SNPs",xlab="FMISS",main="All SNPs",ylim=c(0,100000))
axis(side=2,labels=F)
mtext(ylabels,side=2,las=2, at=c(0,20000,40000,60000,80000,100000),line=1)
axis(side=1,labels=F)
mtext(xlabels,side=1,at=c(-4,-3,-2,-1,0),line=1)
abline(v=log10(0.005),lty=2, col="BLUE")
abline(v=log10(0.006),lty=2, col="RED")
dev.off()
q()
n
#log10(0.07)
