require(data.table)
############################################################
## 1. read the data ########################################
############################################################
## 1.1 read the file and store in a data table #############
fileName <- "car.csv"
filePath <- file.path("csv", fileName)
dtRaw <- fread(filePath, na.strings = c("NA", ""))

## 1.2 take a look #########################################
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

############################################################
## 2. data preprocessing ###################################
############################################################
## 2.1 drop V1 #############################################
names(dtRaw)
dtProcessed <- dtRaw[, !c("V1"), with = F]

## 2.2 split engine into cylinder and capacity, and drop engine
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

## 2.3 conver odometre into a number #######################
DollarToNumber <- function(dollar){
    # a function converts dollar into a number
    # :param: dollar (str)
    # return: a number
    num <- gsub("[$,]", "", dollar)
    return (as.numeric(num))
}
dtProcessed <- dtProcessed[, "odometre" := DollarToNumber(SplitAndUnlist(dtProcessed$odometre, index = 1))]

## 2.4 replace NA with "Special" ###########################
dtProcessed$price_type[is.na(dtProcessed$price_type)] <- "Special"
# replace "Special" with NA for cars have price
dtProcessed$price_type[is.na(dtProcessed$price) & dtProcessed$price_type == "Special"] <- NA

## 2.5 split title into year, make, and model ##############
# 2.5.1 year #
dtProcessed <- dtProcessed[, "year" := SplitAndUnlist(dtProcessed$title, index = 1)]
# 2.5.2 make #
# read the listMakeCleared.txt
fileName <- "listMakeCleared.txt"
filePath <- file.path("listMake", fileName)
dtListMake <- fread(filePath)
vecListMake <- dtListMake[[1]]
# add Abarth in since we missed it from the listMake
vecListMake <- c("Abarth", vecListMake)
# a function searches for a list of patterns in a list of strings 
SearchVectorsFromPatterns <- function(patterns, strs){
    # a function searches for a list of patterns in a list of strings 
    # :param: patterns: a vector of patterns
    # :param: strs: a vector of strings
    # return: the pattern found, otherwise NA
    founds <- vector()
    for (str in strs) {
        for (pattern in patterns){
            if (grepl(pattern, str) == T){
                found <- pattern
                break
            } else {
                found <- NA
            }
        }
        founds <- c(founds, found)
    }
    return(founds)
}
dtProcessed <- dtProcessed[, "make" := SearchVectorsFromPatterns(vecListMake, dtProcessed$title)]
# 2.5.3 model #
# a function replace an item in a vector from another item in a vector
ReplaceVecWithVec <- function(origins, replacements){
    # a function replace an item in a vector from another item in a vector
    # :param: origins: a vector of original strings
    # :param: replacements: a vector of replacements
    # return: a vector of processed strings
    len <- length(origins)
    outputs <- vector()
    for (i in 1:len){
        output <- gsub(replacements[i], "", origins[i])
        outputs <- c(outputs, output)
    }
    return(outputs)
}
# remove make from title
dtProcessed <- dtProcessed[, "model" := ReplaceVecWithVec(dtProcessed$title, dtProcessed$make)]
# remove year, MY\\d+, Manual/Auto, and \\d+x\\d+ from title
dtProcessed <- dtProcessed[, "model" := gsub("^\\s+|\\s+$", "", gsub("^\\d+|(MY\\d+)|Auto|Manual|(\\dx\\d)", "", dtProcessed$model))]

