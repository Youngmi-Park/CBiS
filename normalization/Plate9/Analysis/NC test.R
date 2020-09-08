#calulate sd of NC and siTarget
install.packages("dplyr")
install.packages(c("DBI","RSQLite"))

library("RSQLite")    #SQLite관련 함수를 사용하기 위한 library
library("DBI")    #DB관련 함수를 사용하기 위한 library
library("dplyr")

setwd("C:/Users/HJ/Desktop/DBfile/test")
sqlite <- dbDriver("SQLite") 
exampledb <- dbConnect(sqlite, "C:/Users/HJ/Desktop/DBfile/Plate9_MyExpt_Nuclei(mapping).db", header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) #read sqlite file
dbListTables(exampledb) # table list

full <- dbReadTable(exampledb,"Plate9_MyExpt_Nuclei") # Read MySQL table to data.frame
#i2w = read.table("C:/Users/HJ/Desktop/Plate9/Analysis/Image2Well.txt", header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) 

str(full)

nc <- dbGetQuery(exampledb, "SELECT * FROM Plate9_MyExpt_Nuclei WHERE class='NC'")

str(nc)
num <- as.numeric(nc$Nuclei_ObjectNumber)
class(nc)


write(a, file = "c.txt", append = TRUE)
at <- as.numeric(nc[,1])
write.table(a,"abc.txt",sep="\t")

pc <- dbGetQuery(exampledb, "SELECT * FROM Plate9_MyExpt_Nuclei WHERE class='PLK1'") 
#na <- is.na(dbGetQuery(exampledb, "SELECT ImageNumber, class FROM Plate9_MyExpt_Nuclei WHERE class"))#na = full[is.na(full$class), 2]


str = apply(nc[,4:ncol(nc)], 2, function(x) as.numeric(x, na.rm=TRUE))
a<-str[,2:5]


nct <- data.frame(nc)
str1 = paste(nct, sep = "\t")

write(str1, file = outputNC_avg, append = TRUE)
#full_nc = full[full$ImageNumber %in% nc, ] #row of nc image number #full_pc = full[full$ImageNumber %in% "p", ] #row of pc image number
#ImageNumber
ncImageNum <- dbGetQuery(exampledb, "SELECT ImageNumber, class FROM Plate9_MyExpt_Nuclei WHERE class='NC'") 
pcImageNum <- dbGetQuery(exampledb, "SELECT ImageNumber, class FROM Plate9_MyExpt_Nuclei WHERE class='PLK1'")
#na <- unique()

f <- 9 #plate number
outputMAD_Object = paste0("Plate", f, ".MADNor_perObject.txt")
outputMAD_Well = paste0("Plate", f, ".MADNor_perWell.txt")

outputNC_avg = paste0("Plate", f, ".NCavg.txt")
outputNC_sd = paste0("Plate", f, ".NCsd.txt")
outputPC_avg = paste0("Plate", f, ".PCavg.txt")
outputPC_sd = paste0("Plate", f, ".PCsd.txt")

#fn = paste0("Plate", f, ".MADNor_perObject.txt") #file name  cat(fn, "\n")
#full = read.table(fn, skip=1, header = T, sep="\t",na.strings=c("na", "NA", "NaN", ""))

count_all = as.data.frame(table(full[,1]))  # table  to dataframe
#write.table(full_nc, file = outNC, sep="\t",  col.names=NA, row.names=TRUE)

warning()
# NC,PC avg sd
str1 = paste(apply(nc[,5:ncol(nc)], 2, function(x) mean(x, na.rm=TRUE)),collapse = "\t")
str2 = apply(nc[,5:ncol(nc)], 2, function(x) sd(x, na.rm=TRUE))
str3 = apply(pc[,5:ncol()], 2, function(x) mean(x, na.rm=TRUE))
str4 = apply(pc[,5:ncol(full)], 2, function(x) sd(x, na.rm=TRUE))
str1 = paste(nc,collapse = "\t")

write(full, file = outputNC_avg, append = TRUE)
write(str2, file = outputNC_sd, append = TRUE)
write(str3, file = outputPC_avg, append = TRUE)
write(str4, file = ooutputNC_sd, append = TRUE)

write.table(count_all, outCount, sep= "\t", row.names = FALSE, quote=FALSE)
count_nc = count_all[count_all$Var1 %in% nc, ]
count_pc = count_all[count_all$Var1 %in% pc, ]
count_nc_sd = sd(count_nc$norMAD, na.rm=TRUE)
count_nc_avg = mean(count_nc$norMAD, na.rm=TRUE)
count_pc_sd = sd(count_pc$norMAD, na.rm=TRUE)
count_pc_avg = mean(count_pc$norMAD, na.rm=TRUE)


str1 = paste(f, "PC", count_pc_avg, paste(apply(full_pc[,3:ncol(full)], 2, function(x) mean(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )


dbDisconnect(exampledb)#disconnect SQLite DB 

