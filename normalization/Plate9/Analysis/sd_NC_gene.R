#calulate sd of NC and siTarget
#install.packages("dplyr")

library(dplyr)
setwd("C:/Users/HJ/Desktop/Plate9/A549_image_CP_result")

# read image2well
i2w = read.table("C:/Users/HJ/Desktop/Plate9/Analysis/Image2Well.txt", header=T, sep="\t",na.strings=c("na", "NA", "NaN", "")) 
nc = i2w[i2w$class %in% "NC", 2] #1: well no, 2: image no
pc = i2w[i2w$class %in% "PLK1", 2]
na = i2w[is.na(i2w$class), 2]

f <- 9

outputSD = "all_sd_plate_1_18.txt"
outputAVG = "all_avg_plate_1_18.txt"

#for(f in 1:18){
    fn = paste0("Plate", , ".MADNor_perObject.txt") #file name
    cat(fn, "\n")
    full = read.table(fn, skip=1, header = T, sep="\t",na.strings=c("na", "NA", "NaN", ""))
    # Count 
    outCount = paste0("Plate", f, ".Count_perImage.txt")
    #write.table(full_nc, file = outNC, sep="\t",  col.names=NA, row.names=TRUE)
    count_all = as.data.frame(table(full[,1]))
    med_nc = median(count_nc$Freq)
    MAD = median(abs(count_nc$Freq -med_nc))
    count_all$norMAD = (count_all$Freq - med_nc)/(MAD*1.4826)
    write.table(count_all, outCount, sep= "\t", row.names = FALSE, quote=FALSE)
    
    count_nc = count_all[count_all$Var1 %in% nc, ]
    count_pc = count_all[count_all$Var1 %in% pc, ]
    count_nc_sd = sd(count_nc$norMAD, na.rm=TRUE)
    count_nc_avg = mean(count_nc$norMAD, na.rm=TRUE)
    count_pc_sd = sd(count_pc$norMAD, na.rm=TRUE)
    count_pc_avg = mean(count_pc$norMAD, na.rm=TRUE)
    
    full_nc = full[full$ImageNumber %in% nc, ]
    full_pc = full[full$ImageNumber %in% pc, ]

    str1 = paste(f, "NC", count_nc_avg, paste(apply(full_nc[,3:ncol(full)], 2, function(x) mean(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
    write(str1, file = outputAVG, append = TRUE)
    str1 = paste(f, "PC", count_pc_avg, paste(apply(full_pc[,3:ncol(full)], 2, function(x) mean(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
    write(str1, file = outputAVG, append = TRUE)

    str1 = paste(f, "NC", count_nc_sd, paste(apply(full_nc[,3:ncol(full)], 2, function(x) sd(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
    write(str1, file = outputSD, append = TRUE)
    str1 = paste(f, "PC", count_pc_sd, paste(apply(full_pc[,3:ncol(full)], 2, function(x) sd(x, na.rm=TRUE)), collapse="\t"), sep = "\t" )
    write(str1, file = outputSD, append = TRUE)
    
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
#}

