mds <- read.table("/home/darefalola/ps_data/allpopsmds1.mds", header=T) 
popnids <- read.table("/home/darefalola/ps_data/allpopsIDs.out", header=T)
head(mds)
head(popnids) 
colour <- popnids$CEUind+2*popnids$CHBind+3*popnids$JPTind+4*popnids$YRIind+5*popnids$OURSind
colour
plot(mds$C1, mds$C2, col=colour)
points(mds$C1, mds$C2, col=popnids$CEUind)
abline(h=0.05,col="gray32",lty=2)
mds[mds$C1>0,]
?plot

gg <- "RED"
gg
View(gg)
####################Another flow#####################
mds <- read.table("/home/darefalola/ps_data/allpopsmds1.mds", header=T) 
popnids <- read.table("/home/darefalola/ps_data/allpopsIDs.out", header=T)

CEU=which(popnids$CEUind=="1")
CHB=which(popnids$CHBind=="1")
JPT=which(popnids$JPTind=="1")
YRI=which(popnids$YRIind=="1")
OUR=which(popnids$OURSind=="1")

plot(0,0,pch="",xlim=c(-0.1,0.05),ylim=c(-0.05,0.1),
     xlab="Cluster 1", ylab="Cluster 2")
par(cex=0.5)
points(mds$C1[CEU],mds$C2[CEU],pch=20,col="RED")
points(mds$C1[CHB],mds$C2[CHB],pch=20,col="PURPLE")
points(mds$C1[JPT],mds$C2[JPT],pch=20,col="PURPLE")
points(mds$C1[YRI],mds$C2[YRI],pch=20,col="GREEN")
points(mds$C1[OUR],mds$C2[OUR],pch=20,col="BLACK")
abline(h=0.00,col="gray32",lty=2)
