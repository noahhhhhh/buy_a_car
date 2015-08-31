__author__ = 'Noahhhhhh'

import os
import requests
from bs4 import BeautifulSoup

urlMake = "http://www.carsales.com.au/all-cars/search.aspx?adv=1"
# the source code of the url
source_code = requests.get(urlMake)

# convert the source code to a plain text
plain_text = source_code.text.encode("utf-8")

# soup
soup = BeautifulSoup(plain_text)

# loop search
for option in soup.findAll("select", {"data-aspect": "Make"}):
    optionMake = str(option)

# create a file name
fileName = "listMake" + ".txt"

# file path
pathFile = os.path.join("listMake", fileName)

# write the file
file = open(pathFile, "w")
file.write(optionMake)
file.close()

print pathFile + " is done"