require(data.table)
require(dplyr)
require(ggplot2)
require(scales)
require(sqldf)
require(reshape)
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

## 2.2 group by make and year stats #########################
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
    arrange(desc(meanPrice), make, year)

## 2.3 group by make, model and year stats ###################
statsMakeModelYear <- dtProcessed %>%
    filter(transmission != "Manual" & year >= 2012 & is.na(price) == F & price <= 35000 & odometre <= 40000) %>%
    group_by(make, model, year) %>%
    summarise(meanPrice = round(mean(price, na.rm = T))
              , sdPrice = round(sd(price, na.rm = T))
              , minPrice = min(price, na.rm = T)
              , lowerPrice = quantile(price, na.rm = T)[2]
              , midPrice = quantile(price, na.rm = T)[3]
              , upperPrice = quantile(price, na.rm = T)[4]
              , maxPrice = max(price, na.rm = T)
              , cntMake = n()) %>%
    arrange(desc(meanPrice), make, model, year)

## 2.4 stats of make, model and year by year #################
statsMakeModelYbyY <- sqldf("select a.make, a.model
            , a.year as year1, a.meanPrice as price1
            , b.year as year2, b.meanPrice as price2
            , a.meanPrice - b.meanPrice as diffPrice12
            , 1 - b.meanPrice/a.meanPrice as percPrice12
            , c.year as year3, c.meanPrice as price3
            , b.meanPrice - c.meanPrice as diffPrice23
            , 1 - c.meanPrice/b.meanPrice as percPrice23
            , d.year as year4, d.meanPrice as price4
            , c.meanPrice - d.meanPrice as diffPrice34
            , 1 - d.meanPrice/c.meanPrice as percPrice34
            , e.year as year5, e.meanPrice as price5
            , d.meanPrice - e.meanPrice as diffPrice45
            , 1 - e.meanPrice/d.meanPrice as percPrice45
            from statsMakeModelYear a
            left join statsMakeModelYear b
            on a.make = b.make and a.model = b.model and a.year = b.year + 1
            left join statsMakeModelYear c
            on b.make = c.make and b.model = c.model and b.year = c.year + 1
            left join statsMakeModelYear d
            on c.make = d.make and c.model = d.model and c.year = d.year + 1
            left join statsMakeModelYear e
            on d.make = e.make and d.model = e.model and d.year = e.year + 1
                            ")
###################
## New Car Value ##
###################
# get all makes and models with 2015 as year3
statsMakeModelYbyY2015 <- statsMakeModelYbyY %>%
    filter(year1 == 2015) %>%
    mutate(makeModel = paste(make, model)) %>%
    select(make, model, makeModel, price1, price2, price4, price5)
# melt it for plotting purpose
meltMakeModelYbyY2015 <- data.table(melt(statsMakeModelYbyY2015, id.vars = c("make", "model", "makeModel")))
    
# plot it
PlotDiff <- function(pMake, pModel){
    if (is.na(pMake) == F){
        if (is.na(pModel) == F) {
            g_Y_by_Y <- ggplot(meltMakeModelYbyY2015[grepl(pMake, meltMakeModelYbyY2015$make) & grepl(pModel, meltMakeModelYbyY2015$model)], aes(x = variable, y = value, fill = model))
        } else {
            g_Y_by_Y <- ggplot(meltMakeModelYbyY2015[grepl(pMake, meltMakeModelYbyY2015$make)], aes(x = variable, y = value, fill = model))
        }
        g_Y_by_Y <- g_Y_by_Y + geom_bar(stat = "identity", position = "dodge")
        g_Y_by_Y
    }
}

PlotDiff(pMake = "Volks")


# sort by diffPrice
# get all makes and models with 2015 as year3
statsDiffValue2014 <- statsMakeModelYbyY %>%
    filter(year1 == 2014) %>%
    mutate(makeModel = paste(make, model)) %>%
    # select(make, model, price3, diffPrice32, diffPrice21, diffPrice10) %>%
    arrange(diffPrice12, diffPrice23)



