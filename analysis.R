require(data.table)
require(dplyr)
require(ggplot2)
require(scales)
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

## 2.1 group by make stats #################################
statsMake <- dtProcessed %>%
    group_by(make) %>%
    summarise(meanPrice = mean(price, na.rm = T)
              , sdPrice = sd(price, na.rm = T)
              , minPrice = min(price, na.rm = T)
              , lowerPrice = quantile(price, na.rm = T)[2]
              , midPrice = quantile(price, na.rm = T)[3]
              , upperPrice = quantile(price, na.rm = T)[4]
              , maxPrice = max(price, na.rm = T)
              , cntMake = n()) %>%
    arrange(desc(meanPrice), make)
# plot price distribution by make
# remove the most expensive car
statsMakeAdj <- statsMake[meanPrice != max(statsMake$meanPrice, na.rm = T)]
# sort the plot by meanPrice
statsMakeAdj$make <- factor(statsMakeAdj$make, levels = statsMakeAdj$make[order(- statsMakeAdj$meanPrice, statsMakeAdj$make)])
g_price_make <- ggplot(statsMakeAdj
                       , aes(x = make
                             , y = meanPrice
                             , ymin = minPrice
                             , lower = lowerPrice
                             , middle = midPrice
                             , upper = upperPrice
                             , ymax = maxPrice))
g_price_make <- g_price_make + geom_bar(stat = "identity", fill = "skyblue2")
# g_price_make <- g_price_make + geom_boxplot(stat = "identity", fill = "skyblue2")
g_price_make <- g_price_make + scale_y_continuous(name = "", labels = comma)
g_price_make <- g_price_make + theme(plot.background = element_rect(fill = "white")
               , axis.text.x = element_text(angle = 90, hjust = 1))
g_price_make

## 2.2 group bY make and year stats #########################
statsMakeYear <- dtProcessed %>%
    group_by(make, year) %>%
    summarise(meanPrice = mean(price, na.rm = T)
              , sdPrice = sd(price, na.rm = T)
              , minPrice = min(price, na.rm = T)
              , lowerPrice = quantile(price, na.rm = T)[2]
              , midPrice = quantile(price, na.rm = T)[3]
              , upperPrice = quantile(price, na.rm = T)[4]
              , maxPrice = max(price, na.rm = T)
              , cntMake = n()) %>%
    arrange(desc(meanPrice), make)
