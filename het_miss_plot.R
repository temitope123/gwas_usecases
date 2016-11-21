#plots graph for missingness and heterozygosity
#loads in .imiss and .het files
#pls ensure you specify the right full path to those files
#takes imiss and het file from command line
args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  imissfile = args[1];
  hetfile = args[2];
}
imiss <- read.table(imissfile,header=T)
het <- read.table(hetfile,header=T)

#imiss <- read.table("/home/darefalola/d__data/data/logs/inds/cubreqc.imiss",header=T)
#het <- read.table("/home/darefalola/d__data/data/logs/inds/cubreqc.het",header=T)

#CALCULATE CALL RATE, LOG10(F_FMISS) and mean heterozygosity
imiss$CALL_RATE <- 1-imiss$F_MISS
imiss$logF_MISS = log10(imiss[,6])
het$meanHet = (het$N.NM. - het$O.HOM.)/het$N.NM.
#if values are missing, assign 0
het$meanHet <- ifelse(het$meanHet=="NaN", c(0), c(het$meanHet))
imiss.het <- merge(het,imiss,by=c("FID","IID"))

#GENERATE CALL RATE BY HETEROZYGOSITY PLOT
colors  <- densCols(imiss$logF_MISS,het$meanHet)
pdf("plots/imiss-vs-het.pdf")
plot(imiss$logF_MISS,het$meanHet, col=colors, xlim=c(-3,0),
     ylim=c(0.15,0.75),pch=20, xlab="Proportion of missing genotypes", 
     ylab="Heterozygosity rate",axes=F)

axis(2,at=c(0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.60,0.65,0.70,0.75),tick=T)
axis(1,at=c(-3,-2,-1,0),labels=c(0.001,0.01,0.1,1))

#Heterozygosity thresholds (Horizontal Line)

abline(h=mean(het$meanHet)-(3*sd(het$meanHet)),col="RED",lty=2)
abline(h=mean(het$meanHet)+(3*sd(het$meanHet)),col="RED",lty=2)

#Missing Data Thresholds (Vertical Line)
abline(v=-1.30103, col="BLUE", lty=2) #THRESHOLD=0.05
abline(v=-1.522879, col="BLUE", lty=2) #THRESHOLD=0.03
abline(v=-1.221849, col="RED", lty=2) #THRESHOLD=0.06

#log10(0.06)
#suggested cut high and low values
print(mean(het$meanHet)-(3*sd(het$meanHet)))
print(mean(het$meanHet)+(3*sd(het$meanHet)))
