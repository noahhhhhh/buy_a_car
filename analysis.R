require(data.table)
########################################################
## read the data #######################################
########################################################
# read the file and store in a data table
fileName <- "car.csv"
filePath <- file.path("csv", fileName)
dtRaw <- fread(filePath, na.strings = c("NA", ""))

# take a look
head(dtRaw) # Abarth first
tail(dtRaw) # ZX last
str(dtRaw) # all characters
# V1 can be removed
# body is all good
# engine can be splitted into cylinder and volume
# odometre can be converted into a number
# price is all good?
# price type can put a dummy value as NA, NA represents something but not sure yet
# title can be splitted into year, make, and model
# transmission is all good
summary(dtRaw) # 132,562 cars. Will do this again after data preprocessing

########################################################
## read the data #######################################
########################################################
