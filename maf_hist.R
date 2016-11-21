args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  file = args[1];
}
#imiss <- read.table(file,header=T)

#x<-read.table("/home/darefalola/d__data/data/cubreqc.frq",header=T)
x<-read.table(file,header=T)

ylabels=c("0","10K","20K","30K","40K","50K")
xlabels=c("0.0001","0.001","0.01","0.1","1")
#par(mfrow=c(1,1))
pdf("plots/maf.pdf")
q <- na.omit(x$MAF)
hist(log10(q),axes=F,xlim=c(-4,0),col="BROWN",ylab="Number of SNPs",xlab="MAF",main="Minor Allele frequency of all SNPs",ylim=c(0,50000))
axis(side=2,labels=F)
mtext(ylabels,side=2, las=2, at=c(0,10000,20000,30000,40000,50000),line=1)


axis(side=1,labels=F)
mtext(xlabels,side=1,at=c(-4,-3,-2,-1,0),line=1)
abline(v=log10(0.005),lty=2, col="RED")

# hdata <- data.frame(logs=log10(q))
# head(hdata$logs)
# qplot(hdata$logs,xlim=c(-4,0),ylab="Number of SNPs",xlab="MAF",
# main="Minor Allele frequency of all SNPs",ylim=c(0,50000), binwidth=0.2,
# alpha=I(.6), fill=I("white"),col=I("black"))


# graphobj <- ggplot(hdata,aes(hdata$logs))
# + geom_histogram(labs(title="Minor Allele frequency of all SNPs") +
#   labs(x="MAF", y="Number of SNPs"))
# 
# graphobj
# 
# + ylab("Number of SNPs") + xlab("MAF") +
#   labs(title="Minor Allele frequency of all SNPs")
# 
# 
# geom_vline(xintercept=log10(0.005), color="red", linetype="dashed", size=1)
dev.off()
q()
