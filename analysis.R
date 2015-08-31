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
# engine can be splitted into cylinder and capacity
# odometre can be converted into a number
# price is all good?
# price type can put a dummy value as NA, NA represents something but not sure yet
# title can be splitted into year, make, and model
# transmission is all good
summary(dtRaw) # 132,562 cars. Will do this again after data preprocessing

########################################################
## data preprocessing ##################################
########################################################
# drop V1
names(dtRaw)
dtProcessed <- dtRaw[, !c("V1"), with = F]

# split engine into cylinder and capacity, and drop engine
SplitAndUnlist <- function(vec, sep = "\\s+", index = 1){
    # a function splits a vector of strings by sep
    # :param: vec: a vector of strings
    # :param: sep: the split
    # return: a vector of specified splitted part
    listSplit <- strsplit(vec, sep)
    vecPart <- rapply(listSplit, function(x) x[index])
    return (vecPart)
}
dtProcessed <- dtProcessed[, "cylinder" := SplitAndUnlist(dtProcessed$engine, index = 1)]
dtProcessed <- dtProcessed[, "capacity" := SplitAndUnlist(dtProcessed$engine, index = 2)]
dtProcessed <- dtProcessed[, !c("engine"), with = F]

# conver odometre into a number
DollarToNumber <- function(dollar){
    # a function converts dollar into a number
    # :param: dollar (str)
    # return: a number
    num <- gsub("[$,]", "", dollar)
    return (as.numeric(num))
}
dtProcessed <- dtProcessed[, "odometre" := DollarToNumber(SplitAndUnlist(dtProcessed$odometre, index = 1))]

# replace NA with "Special"
dtProcessed$price_type[is.na(dtProcessed$price_type)] <- "Special"

# split title into year, make, and model
dtProcessed <- dtProcessed[, "year" := SplitAndUnlist(dtProcessed$title, index = 1)]


