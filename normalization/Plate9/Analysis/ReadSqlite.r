#insta0000ll.packages(c("DBI","RSQLite"))

library("RSQLite")    #SQLite���� �Լ��� ����ϱ� ���� library
library("DBI")    #DB���� �Լ��� ����ϱ� ���� library

setwd("C:/Users/HJ/Desktop/DBfile/test")
sqlite <- dbDriver("SQLite") 
exampledb <- dbConnect(sqlite, "C:/Users/HJ/Desktop/DBfile/Plate9.MADNor_perObject_DB.db") #read sqlite file
dbListTables(exampledb) # table list

#nuclei = dbReadTable(exampledb, "nuclei")
test = dbReadTable(exampledb,"Plate9MADNor_perObject_DB") # Read MySQL table to data.frame

#subset
test1 <- test[,4:5]

write.csv(test1, "Test1.csv")
#write.table(test, "Test1.txt")

dbDisconnect(exampledb)#disconnect SQLite DB 

