require(data.table)
require(dplyr)
############################################################
## 1. read the data ########################################
############################################################
fileName <- "dtProcessed.RData"
filePath <- file.path("RData", fileName)
load(filePath)
############################################################
## 2. exploratory analysis #################################
############################################################
summary(dtProcessed)
str(dtProcessed)
## group by make stats #####################################
dtByMake <- group_by(dtProcessed, make)
statsMake <- summarise(dtByMake
                       , meanPrice = mean(price, na.rm = T)
                       , sdPrice = sd(price, na.rm = T)
                       , cnt = n())
View(arrange(statsMake, desc(meanPrice)))
