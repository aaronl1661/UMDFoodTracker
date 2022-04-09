from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.chrome.options import Options
import time
import sys
import csv


# South, 251, Diner
dinerSelectionXPaths = ['/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[1]/td[1]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a',
                        '/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[2]/td[1]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a', '/html/body/center/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr[1]/td[2]/table/tbody/tr/td[2]/table/tbody/tr[1]/td/span/a']

# Breakfast, Lunch, Dinner
mealXPaths = ['/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a',
              '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[2]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a', '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[3]/table/tbody/tr[1]/td/table/tbody/tr/td[2]/a']

mealTypeXPaths = ['/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[1]/table/tbody/tr[1]/td/table/tbody/tr/td[1]/div', '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[2]/table/tbody/tr[1]/td/table/tbody/tr/td[1]/div', '/html/body/table/tbody/tr[2]/td[2]/table[2]/tbody/tr/td[3]/table/tbody/tr[1]/td/table/tbody/tr/td[1]/div' ]


southItems = {}
north251Items = {}
dinerItems = {}

# ----------------------------------------------------------------------------------------------------------------------------------------------------------
chrome_options = Options()
chrome_options.add_argument("--headless")
driver = webdriver.Chrome(options=chrome_options)
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
            mealType = driver.find_element_by_xpath(mealTypeXPaths[number]).text 
            print(mealType)
            element = driver.find_element_by_xpath(mealLink)
            element.click()
        except NoSuchElementException:
            break

        #find out which breakfast/lunch/dinner

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
                # porperties: [mealtype, portion, cal, prot, carb, transF, vitC,  Sod]
                properties = []
                properties.append(mealType) #breakfast/lunch/dinner
                properties.append(
                    tableElements[tabNum].find_element_by_class_name('nutrptportions').text)
                #makes a list of all divs containing nutrition information
                nutrition = tableElements[tabNum].find_elements_by_class_name(
                    'nutrptvalues')
                #covert divs into their text values and appends to properties
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




def writeToCsv(dict_data, name):
    # ['1 oz', '22.964', '0.743', '5.270', '0.000', '2.410', '60.669']

    csv_columns = ['Food Name', 'Meal', 'Portion', 'Calories', 'Protein', 'Carbs', 'TransFat', 'Vitamin C',  'Sodium']
    csv_file = name

    try:
        with open(csv_file, "w") as outfile:
            writerfile = csv.writer(outfile)
            writerfile.writerow(csv_columns)
            for key, value in dict_data.items():
                writerfile.writerow([key, value[0], value[1], value[2], value[3], value[4], value[5], value[6], value[7]])

            
            outfile.close()


    except IOError:
        print("I/O error")

    """  try:
        with open(csv_file, "w") as outfile:
            writerfile = csv.writer(outfile)
            writerfile.writerow(dict_data.keys())
            writerfile.writerows(zip(*dict_data.values()))
            outfile.close()

    except IOError:
        print("I/O error")
    """
    


"""     try:
        with open(csv_file, 'w') as csvfile:
            writer = csv.writer(csvfile)
            for key, value in dict_data.items():
                writer.writerow([key, value])

            csvfile.close()
    except IOError:
        print("I/O error") """




writeToCsv(southItems, 'southDiner.csv')
writeToCsv(north251Items, 'north251Diner.csv')
writeToCsv(dinerItems, 'Diner.csv')