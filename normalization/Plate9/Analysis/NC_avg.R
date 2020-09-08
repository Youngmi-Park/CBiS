#calulate sd of NC and siTarget
#install.packages("dplyr")
install.packages("DBI")
install.packages("RSQLite")

library("RSQLite")    #SQLite관련 함수를 사용하기 위한 library
library("DBI")    #DB관련 함수를 사용하기 위한 library
library("dplyr")

setwd("D:/output")
sqlite <- dbDriver("SQLite") 

i2wdb = dbConnect(sqlite, "D:/DBfile/Image2Well.db" , header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) #read sqlite file
dbListTables(i2wdb) # table list
nc <- dbGetQuery(i2wdb, "SELECT ImageNO FROM Image2Well WHERE class='NC'")
pc <- dbGetQuery(i2wdb, "SELECT ImageNO FROM Image2Well WHERE class='PLK1'")
g <- dbGetQuery(i2wdb, "SELECT ImageNO FROM Image2Well WHERE class='g'")
#na = i2w[is.na(i2w$class), 2]

for(f in 1:3){
  plate <- paste0("Plate",f) #plate number
  
  dbFile <- paste0("D:/DBfile/",plate,".MyExpt_Nuclei.db")
  rawdb <- dbConnect(sqlite, dbFile , header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) #read sqlite file
  dbListTables(rawdb) # table list

 # full <- dbReadTable(rawdb, "MyExpt_Nuclei") # Read MySQL table to data.frame

  ncNO <- paste0("'",nc[,1],"'",collapse=",")
  pcNO <- paste0("'",pc[,1],"'",collapse=",")
  gNO <- paste0("'",g[,1],"'",collapse=",")
  query1 <- paste0("SELECT * FROM MyExpt_Nuclei WHERE ImageNumber IN ( ",ncNO, " )")
  query2 <- paste0("SELECT * FROM MyExpt_Nuclei WHERE ImageNumber IN ( ",pcNO, " )")
  query3 <- paste0("SELECT * FROM MyExpt_Nuclei WHERE ImageNumber IN ( ",gNO, " )")
  nc_raw <- dbGetQuery(rawdb,query1)
  pc_raw <- dbGetQuery(rawdb,query2)
  g_raw <- dbGetQuery(rawdb,query3)
  nc_ <- as.data.frame(apply(nc_raw[,2:ncol(nc_raw)], 2,as.numeric, na.rm=TRUE))
  pc_ <- as.data.frame(apply(pc_raw[,2:ncol(nc_raw)], 2,as.numeric, na.rm=TRUE))
  g_raw <- as.data.frame(apply(g_raw[,4:ncol(nc_raw)], 2,as.numeric, na.rm=TRUE))
  
 
  str1 <- as.data.frame(t(colMeans(nc_,na.rm=TRUE)))
  str2 <- as.data.frame(t(apply(nc_,2,sd,na.rm=TRUE)))
  str3 <- as.data.frame(t(colMeans(pc_,na.rm=TRUE)))
  str4 <- as.data.frame(t(apply(pc_,2,sd,na.rm=TRUE)))
  str5 <- as.data.frame(t(colMeans(g_raw,na.rm=TRUE)))
  str6 <- as.data.frame(t(lapply(g_raw,mean,na.rm=TRUE)))
  
  if(f == 1){
    str1 <- cbind(plate,str1)
    nc_avg <- str1
    str2 <- cbind(plate,str2)
    nc_sd <- str2
    str3 <- cbind(plate,str3)
    pc_avg <- str3
    str4 <- cbind(plate,str4)
    pc_sd <- str4
    str5 <- cbind(plate,str5)
    g_avg <- str5
    str6 <- cbind(plate,str6)
    g_sd <- str6
  } else{
    str1 <- cbind(plate,str1)
    nc_avg <- rbind(nc_avg,str1)
    str2 <- cbind(plate,str2)
    nc_sd <- rbind(nc_avg,str2)
    
    str3 <- cbind(plate,str3)
    pc_avg <- rbind(pc_avg,str3)
    str4 <- cbind(plate,str4)
    pc_sd <- rbind(pc_avg,str4)
    
    str5 <- cbind(plate,str5)
    g_avg <- rbind(g_avg,str5)
    str6 <- cbind(plate,str6)
    g_sd <- rbind(g_sd,str6)
    }
}

#dbWriteTable(db,"table name","filename"), overwrite

write.table(nc_avg, file = "NCavg_perPlate.txt", sep= "\t", row.names =FALSE,quote=FALSE)
write.table(nc_sd, file = "NCsd_perPlate.txt", row.names =FALSE,quote=FALSE)
write.table(pc_avg, file = "PCavg_perPlate.txt", row.names =FALSE,quote=FALSE)
write.table(pc_sd, file = "PCsd_perPlate.txt", row.names =FALSE,quote=FALSE)
write.table(g_avg, file = "PCavg_perPlate.txt", row.names =FALSE,quote=FALSE)
write.table(g_sd, file = "PCavg_perPlate.txt", row.names =FALSE,quote=FALSE)

dbDisconnect(rawdb)#disconnect SQLite DB 
dbDisconnect(i2wdb)



#ncImageNum <- dbGetQuery(exampledb, "SELECT ImageNumber, class FROM Plate9_MyExpt_Nuclei WHERE class='NC'") 
