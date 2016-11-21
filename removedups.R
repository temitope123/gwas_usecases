args=(commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  q();
}else{
  tped = args[1];
}
#print(tped)
#tped <- tped.tped
print(tped)
a=read.table(tped,sep=" ",header=F)
b=a[!duplicated(a$V2),]
print("Working...")
write.table(b,file="data.tped",sep=" ",quote = FALSE,col.names = FALSE, row.names=FALSE)
print("output is data.tped")