from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException

import time
import sys

# South, 251, Diner
dinerSelectionXPaths = ['/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[1]/td[1]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a',
                        '/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[2]/td[1]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a', '/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[1]/td[2]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a']

# Breakfast, Lunch, Dinner
mealXPaths = ['/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a',
              '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[2]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a', '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[3]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a']


southItems = {}
north251Items = {}
dinerItems = {}

# ----------------------------------------------------------------------------------------------------------------------------------------------------------
driver = webdriver.Chrome()
driver.get("https://nutrition.umd.edu/")

# large for loop - for 3 diners
for iteration, dinerLink in enumerate(dinerSelectionXPaths):
    # Opens each diner page
    dinerHomePage = driver.find_element_by_xpath(dinerLink)
    dinerHomePage.click()

    # click on nutrition information for each meal - breakfast, lunch, dinner
    for number, mealLink in enumerate(mealXPaths):
        driver.implicitly_wait(3)
        try:
            element = driver.find_element_by_xpath(mealLink)
            element.click()
        except NoSuchElementException:
            break

        # put one into each of the table elements
        tableXPath = '/html/body/table/tbody/tr[2]/td[2]/div[2]/table[1]/tbody'
        table = driver.find_element_by_xpath(tableXPath)

        # creates an array of the checkboxes
        checkBoxes = table.find_elements_by_name('recipe')

        for checkBox in checkBoxes:
          # iterate through the list of checkboxes and if checked, uncheck them
            checkBox.click()

        # hit generate report                      /html/body/table/tbody/tr[2]/td[2]/div[2]/table[1]/tbody/tr[339]/td/table/tbody/tr/td[2]/input
        # reportButton = driver.find_element_by_xpath('/html/body/table/tbody/tr[2]/td[2]/div[2]/table[1]/tbody/tr[86]/td/table/tbody/tr/td[2]/input')
        reportButtonArray = driver.find_elements_by_css_selector(
            "input[type='button']")
        reportButton = reportButtonArray[1]
        # reportButton = driver.find_element_by_css_selector("input[value='Show Report'][type='button']")

        reportButton.click()
        #time.sleep(.5)

        # scrape the information from the table
        nutritionTable = driver.find_element_by_xpath(
            '/html/body/table[2]/tbody')
        tableElements = nutritionTable.find_elements_by_tag_name('tr')

        for tabNum in range(len(tableElements)):
            if tabNum != 0 and tabNum != 1 and tabNum != len(tableElements) - 1:
                # name
                id = tableElements[tabNum].find_element_by_class_name(
                    'nutrptnames').find_element_by_tag_name('a').text
                # porperties: [portion, cal, prot, carb, transF, vitC,  Sod]
                properties = []
                properties.append(
                    tableElements[tabNum].find_element_by_class_name('nutrptportions').text)
                nutrition = tableElements[tabNum].find_elements_by_class_name(
                    'nutrptvalues')
                for nutritionType in nutrition:
                    properties.append(nutritionType.text)
                if iteration == 0:
                    southItems[id] = properties
                if iteration == 1:
                    north251Items[id] = properties
                if iteration == 2:
                    dinerItems[id] = properties

        # add to database

        # returns back to current diner page
        clearButton = driver.find_element_by_xpath(
            '/html/body/div[6]/form/table/tbody/tr[1]/td[4]/input')
        clearButton.click()
        # time.sleep(1)

    driver.get("https://nutrition.umd.edu/")


driver.close()






def printDict(x):
    print("----------------------")
    for(k, v) in x.items():
        print(k, v)


printDict(southItems)
printDict(north251Items)
printDict(dinerItems)