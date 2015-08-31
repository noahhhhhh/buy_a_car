__author__ = 'Noahhhhhh'

import os
from pandas import *

def FindNth(haystack, needle, n):
    start = haystack.find(needle)
    while start >= 0 and n > 1:
        start = haystack.find(needle, start+len(needle))
        n -= 1
    return start

# a list of parameters
listTitle = list()
listPrice = list()
listPriceType = list()
listEngine = list()
listTransmission = list()
listBody = list()
listOdometre = list()

# open the files
pathMain = os.path.join("data")
fileNames = os.listdir(pathMain)
# fileNames = fileNames[:fileNames.index("carsAudi000001.txt")]
# some dummy tracker
iTitle = 0
iPrice = 0
iPriceType = 0
iEngine = 0
iTransmission = 0
iBody = 0
iOdometre = 0
# dataframe
dfCar = DataFrame()

for fileName in fileNames:
    filePath = os.path.join(pathMain, fileName)
    if os.path.isfile(filePath):
        with open(filePath, "r") as file:
            for line in file:
                if "photo-count" in line:
                    strLine = str(line)
                    start = strLine.find("title=\"") + len("title=\"")
                    end = strLine.find("\" recordid")
                    title = strLine[start:end]
                    listTitle.append(title)

                    iTitle = iTitle + 1

                if ("data-price" in line or "special-offer-price" in line) and "PriceType" not in line:
                    if "data-price" in line:
                        strLine = str(line)
                        start = strLine.find("data-price=\"") + len("data-price=\"")
                        end = strLine.find("\" href")
                        price = strLine[start:end]
                    if "special-offer-price" in line:
                        strLine = str(line)
                        start = FindNth(strLine, "\">", 2) + len("\">")
                        end = FindNth(strLine, "</a>", 1)
                        price = strLine[start:end]
                        for ch in ["$", ","]:
                           if ch in price:
                              price = price.replace(ch, "")

                    iPrice = iPrice + 1
                    if iPrice != iTitle:
                        print "Price not found: " + "title: " + str(iTitle - 2) + "; price: " + str(iPrice - 1)
                        listPrice.extend([None] * (iTitle - iPrice))
                        listPrice.append(price)
                        print "None added to listPrice in the index of: " + str(iTitle - iPrice)
                        iPrice = iTitle
                    else:
                        listPrice.append(price)

                if "PriceType" in line:
                    strLine = str(line)
                    start = strLine.find("\">") + len("\">")
                    end = strLine.find("</a>")
                    priceType = strLine[start:end]

                    iPriceType = iPriceType + 1
                    if iPriceType != iTitle:
                        print "PriceType not found: " + "title: " + str(iTitle - 2) + "; priceType: " + str(iPriceType - 1)
                        listPriceType.extend([None] * (iTitle - iPriceType))
                        listPriceType.append(priceType)
                        print "None added to listPriceType in the index of: " + str(iTitle - iPriceType)
                        iPriceType = iTitle
                    else:
                        listPriceType.append(priceType)

                if "item-engine" in line:
                    strLine = str(line)
                    start = strLine.find("</i>") + len("</i>")
                    end = strLine.find("</li>")
                    engine = strLine[start:end]

                    iEngine = iEngine + 1
                    if iEngine != iTitle:
                        print "Engine not found: " + "title: " + str(iTitle - 2) + "; engine: " + str(iEngine - 1)
                        listEngine.extend([None] * (iTitle - iEngine))
                        listEngine.append(engine)
                        print "None added to listEngine in the index of: " + str(iTitle - iEngine)
                        iEngine = iTitle
                    else:
                        listEngine.append(engine)

                if "item-transmission" in line:
                    strLine = str(line)
                    start = strLine.find("</i>") + len("</i>")
                    end = strLine.find("</li>")
                    transmission = strLine[start:end]

                    iTransmission = iTransmission + 1
                    if iTransmission != iTitle:
                        print "Transmission not found: " + "title: " + str(iTitle - 2) + "; transmission: " + str(iTransmission - 1)
                        listTransmission.extend([None] * (iTitle - iTransmission))
                        listTransmission.append(transmission)
                        print "None added to listTransmission in the index of: " + str(iTitle - iTransmission)
                        iTransmission = iTitle
                    else:
                        listTransmission.append(transmission)

                if "item-body" in line:
                    strLine = str(line)
                    start = strLine.find("</i>") + len("</i>")
                    end = strLine.find("</li>")
                    body = strLine[start:end]

                    iBody = iBody + 1
                    if iBody != iTitle:
                        print "Body not found: " + "title: " + str(iTitle - 2) + "; body: " + str(iBody - 1)
                        listBody.extend([None] * (iTitle - iBody))
                        listBody.append(body)
                        print "None added to listBody in the index of: " + str(iTitle - iBody)
                        iBody = iTitle
                    else:
                        listBody.append(body)

                if "item-odometer" in line:
                    strLine = str(line)
                    start = strLine.find("</i>") + len("</i>")
                    end = strLine.find("</li>")
                    odometer = strLine[start:end]

                    iOdometre = iOdometre + 1
                    if iOdometre != iTitle:
                        print "Odometre not found: " + "title: " + str(iTitle - 2) + "; odometre: " + str(iOdometre - 1)
                        listOdometre.extend([None] * (iTitle - iOdometre))
                        listOdometre.append(odometer)
                        print "None added to listOdometre in the index of: " + str(iTitle - iOdometre)
                        iOdometre = iTitle
                    else:
                        listOdometre.append(odometer)

            if iTitle != iPrice:
                print "Exception: " + fileName + " -- Unequal length of Price: " + "Title: " + str(iTitle) + "; Price: " + str(iPrice)
                listPrice.extend(([None] * (iTitle - iPrice)))
            if iTitle != iPriceType:
                print "Exception: " + fileName + " -- Unequal length of Price Type: " + "Title: " + str(iTitle) + "; Price Type: " + str(iPrice)
                listPriceType.extend(([None] * (iTitle - iPriceType)))
            if iTitle != iEngine:
                print "Exception: " + fileName + " -- Unequal length of Engine: " + "Title: " + str(iTitle) + "; Engine: " + str(iPrice)
                listEngine.extend(([None] * (iTitle - iEngine)))
            if iTitle != iTransmission:
                print "Exception: " + fileName + " -- Unequal length of Transmission: " + "Title: " + str(iTitle) + "; Transmission: " + str(iPrice)
                listTransmission.extend(([None] * (iTitle - iTransmission)))
            if iTitle != iBody:
                print "Exception: " + fileName + " -- Unequal length of Body: " + "Title: " + str(iTitle) + "; Body: " + str(iPrice)
                listBody.extend(([None] * (iTitle - iBody)))
            if iTitle != iOdometre:
                print "Exception: " + fileName + " -- Unequal length of Odometre: " + "Title: " + str(iTitle) + "; Odometre: " + str(iPrice)
                listOdometre.extend(([None] * (iTitle - iOdometre)))

        print fileName + " is done parsing"

        dictCar = {"price_type": listPriceType
           , "price": listPrice
           , "title": listTitle
           , "engine": listEngine
           , "transmission": listTransmission
           , "body": listBody
           , "odometre": listOdometre
                   }

        lenListTitle = len(listTitle)
        lenListPrice = len(listPrice)
        lenListPriceType = len(listPriceType)
        lenListEngine = len(listEngine)
        lenListTransmission = len(listTransmission)
        lenListBody = len(listBody)
        lenListOdometre = len(listOdometre)

        if lenListTitle == lenListPrice == lenListPriceType == lenListEngine == lenListTransmission == lenListBody == lenListOdometre:
            dfCarTemp = DataFrame(dictCar)
            dfCar = dfCar.append(dfCarTemp, ignore_index = True)

        listPriceType = list()
        listPrice = list()
        listTitle = list()
        listEngine = list()
        listTransmission = list()
        listBody = list()
        listOdometre = list()

        iTitle = 0
        iPrice = 0
        iPriceType = 0
        iEngine = 0
        iTransmission = 0
        iBody = 0
        iOdometre = 0

        file.close()



# to directory
toFileName = os.path.join("csv", "car.csv")
dfCar.to_csv(toFileName)

lenListTitle = len(listTitle)
lenListPrice = len(listPrice)
lenListPriceType = len(listPriceType)
lenListEngine = len(listEngine)
lenListTransmission = len(listTransmission)
lenListBody = len(listBody)
lenListOdometre = len(listOdometre)

print "len Title: " + str(lenListTitle)
print "len Price: " + str(lenListPrice)
print "len Price Type: " + str(lenListPriceType)
print "len Engine: " + str(lenListEngine)
print "len Transmission: " + str(lenListTransmission)
print "len Body: " + str(lenListBody)
print "len Odometre: " + str(lenListOdometre)

print dfCar
# print listTitle
# print listPrice
# print listPriceType
# print listOdometre
