library("RSQLite")    #SQLite관련 함수를 사용하기 위한 library
library("DBI")    #DB관련 함수를 사용하기 위한 library
library("dplyr")

setwd("D:/output")
sqlite <- dbDriver("SQLite") 

i2wdb = dbConnect(sqlite, "D:/DBfile/Image2Well.db" , header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) #read sqlite file
dbListTables(i2wdb) # table list
nc <- dbGetQuery(i2wdb, "SELECT ImageNO FROM Image2Well WHERE class='NC'")

plate <- paste0("Plate",f) #plate number

dbFile <- paste0("D:/DBfile/",plate,".MyExpt_Nuclei.db")
rawdb <- dbConnect(sqlite, dbFile , header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) #read sqlite file
dbListTables(rawdb) # table list

ncNO <- paste0("'",nc[,1],"'",collapse=",")
query1 <- paste0("SELECT * FROM MyExpt_Nuclei WHERE ImageNumber IN ( ",ncNO, " )")
nc_raw <- dbGetQuery(rawdb,query1)

nc_ <- as.data.frame(apply(nc_raw[,2:ncol(nc_raw)], 2,as.numeric, na.rm=TRUE))


#function MAD normalization(Object)
MADnor <- function(n){
  med = median(n)
  MAD = median(abs(n - med))
  objectnorMAD = (n - med)/(MAD*1.4826)
  
  objectnorMAD
}
apply(test,2,function(x) MADnor(x))

a= median(test$d)
a
b = median(abs(d-a))
b
z=d-a/(b*1.4826)
z


count_all = as.data.frame(table(full[,1]))
med_nc = median(count_nc$Freq)
MAD = median(abs(count_nc$Freq -med_nc))
count_all$norMAD = (count_all$Freq - med_nc)/(MAD*1.4826)
write.table(count_all, outCount, sep= "\t", row.names = FALSE, quote=FALSE)

d<-c(1,2,5,3)
c<-c(6,8,13,4)
k<-c(2,6,1,0)

test = data.frame(d,c,k)
test
test-1


#well
for(id1 in seq(1, 1872, 6)){
  df1_id = c(id1:(id1+5))
  df1 = full[full$ImageNumber %in% df1_id,]
  class = as.character(i2w[i2w$Image.No == df1_id[1], 3])
  if(!is.na(class) & class == "g"){
    if(nrow(df1)>0){
      well = as.character(i2w[i2w$Image.No == df1_id[1], 1])
      count_sd = sd(count_all[df1_id, 3], na.rm=TRUE)
      count_avg = mean(count_all[df1_id, 3], na.rm=TRUE)
      #df1_sd = apply(df1[,3:ncol(full)], 2, function(x) sd(x, na.rm=TRUE))
      str = paste(f,well, count_sd, paste(apply(df1[,3:ncol(full)], 2, function(x) sd(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
      write(str, file = outputSD, append = TRUE)
      str1 = paste(f,well, count_avg, paste(apply(df1[,3:ncol(full)], 2, function(x) mean(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
      write(str1, file = outputAVG, append = TRUE)
    }
  }
}
