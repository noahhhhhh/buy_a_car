__author__ = 'Noahhhhhh'

import os
import requests

def ListMakeParser(dir = os.path.join("listMake", "listMake.txt")):
    """ parse the car make list
    :param dir (os.path): a directory of the list of car make
    :return (list): a list of car make
    """
    listMake = list()
    if os.path.isfile(dir):
        with open(dir, "r") as file:
            for line in file:
                if ")</option>" in line:
                    strLine = str(line)
                    start = strLine.find("\">") + len("\">")
                    end = strLine.find("(") - 1
                    make = strLine[start:end]
                    listMake.append(make)
        file.close()
        print listMake
    return listMake

def pageNum(listMake):
    """
    get the maximum number of pages each make in the listMake
    :param listMake (list): list of car makes
    :return (dict): a dict of the corresponding maximum number of pages
    """
    listPageNum = list()
    dictPageNum = dict()
    initPage = 0
    for car_make in listMake:
        initUrl = "http://www.carsales.com.au/cars/results?offset=" + str(initPage) +\
                  "&q=%28Service%3D%5BCarsales%5D%26Make%3D%5B" + car_make + \
                  "%5D%29&limit=24"
        # the source code of the url
        source_code = requests.get(initUrl)
        # convert the source code to a plain text
        plain_text = source_code.text.encode("utf-8")
        # convert to a string
        strText = str(plain_text)
        # get the starting point of the maximum page
        start = strText.find("Page 1 of ") + len("Page 1 of ")
        # get 4 characters from the maximum page starting point
        strTextTemp = strText[start:(start + 5)]
        # get the ending point of the maximum page from the above 4 characters
        end = strTextTemp.find("<")
        # page number
        pageNum = int(strTextTemp[:end])

        # append to the list of pageNum
        listPageNum.append(pageNum)

        # dict
        dictPageNum[car_make] = pageNum

    print dictPageNum
    return dictPageNum


def MainCrawler(is_all_car = False, car_make = "BMW", is_max_page = False, max_page = 100, items_per_page = 24):
    """
    crawl car info
    :param is_all_car (boolean): do you want to crawl all the car makes?
    :param car_make (str): if is_all_car is False, then this is the car make you want to crawl
    :param items_per_page (int): number of  items per page (12 or 24)
    :param is_max_page (boolean): do you want to crawl all the pages of each car make?
    :param max_page (int): if is_max_page is False, then this is the number of pages you want to crawl
    :return: nothing
    """
    # a list of all car makes
    listMake = ListMakeParser(dir = os.path.join("listMake", "listMake.txt"))
    # a dict of the corresponding maximum number of pages of each car make
    dictPageNum = pageNum(listMake)

    if is_all_car == True:
        for make in listMake:
            if is_max_page == True:
                max_page = dictPageNum[make]
            else:
                max_page = max(dictPageNum[make], max_page)

            for page in range(0, max_page + 1, 1):
                curPage = items_per_page * page
                # the url you want to crawl
                """
                example url: http://www.carsales.com.au/cars/results?offset=0&q=%28Service%3D%5BCarsales%5D%26Make%3D%5BBMW%5D%29&limit=24
                """
                url = "http://www.carsales.com.au/cars/results?offset=" + str(curPage) +\
                      "&q=%28Service%3D%5BCarsales%5D%26Make%3D%5B" + make + \
                      "%5D%29&limit=24"

                # the source code of the url
                source_code = requests.get(url)

                # convert the source code to a plain text
                plain_text = source_code.text.encode("utf-8")

                # create a file name
                fileName = "cars" + make + str(page).zfill(6) + ".txt"

                # file path
                pathFile = os.path.join("data", fileName)
                # write the file
                file = open(pathFile, "w")
                file.write(plain_text)
                file.close()

                print fileName + " is done"
    else:
        if is_max_page == True:
            max_page = dictPageNum[make]
        else:
            max_page = max(dictPageNum[make], max_page)
        for page in range(0, max_page + 1, 1):
            curPage = items_per_page * page
            # the url you want to crawl
            """
            example url: http://www.carsales.com.au/cars/results?offset=0&q=%28Service%3D%5BCarsales%5D%26Make%3D%5BBMW%5D%29&limit=24
            """
            url = "http://www.carsales.com.au/cars/results?offset=" + str(curPage) +\
                  "&q=%28Service%3D%5BCarsales%5D%26Make%3D%5B" + make + \
                  "%5D%29&limit=24"

            # the source code of the url
            source_code = requests.get(url)

            # convert the source code to a plain text
            plain_text = source_code.text.encode("utf-8")

            # create a file name
            fileName = "cars" + make + str(page).zfill(6) + ".txt"

            # file path
            pathFile = os.path.join("data", fileName)
            # write the file
            file = open(pathFile, "w")
            file.write(plain_text)
            file.close()

            print fileName + " is done"

# test run
MainCrawler(is_all_car = True, is_max_page = True, items_per_page = 24)
# ListMakeParser()