args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  file = args[1];
}
pdf("plots/rel_plot.pdf")
data <- read.table(file,h=T)
#data <-read.table("/Users/User/Desktop/assoc2/cubreqc.genome", header=T)
hist(data$PI_HAT, freq=T, xlim=c(0,0.7), breaks=100, ylim=c(0,2000),  
     xlab="Distance (PI_HAT)", main="Histogram of related individuals")

abline(v=0.185, col="RED", lty=2) #THRESHOLD=0.05
abline(v=0.01, col="BLUE", lty=2) #THRESHOLD=0.03
