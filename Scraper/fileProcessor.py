import pandas as pd
import numpy as np

def process(fileName):
    df = pd.read_csv(fileName + ".csv")
    df['Calories'] = pd.to_numeric(df['Calories'], errors = 'coerce')
    df['Protein'] = pd.to_numeric(df['Protein'], errors = 'coerce') 
    df['Carbs'] = pd.to_numeric(df['Carbs'], errors = 'coerce')
    df['TransFat'] = pd.to_numeric(df['TransFat'], errors = 'coerce') 
    df['Vitamin C'] = pd.to_numeric(df['Vitamin C'], errors = 'coerce')
    df['Sodium'] = pd.to_numeric(df['Sodium'], errors = 'coerce') 
    df = df.replace(np.nan, 0, regex=True)
    #df['Calories'] = round(df['Calories'], 0)
    df['Calories'] = df['Calories'].astype(int)
    df['Protein'] = df['Protein'].astype(int)
    df['Carbs'] = df['Carbs'].astype(int)
    df['TransFat'] = df['TransFat'].astype(int)
    df['Vitamin C'] = df['Vitamin C'].astype(int)
    df['Sodium'] = df['Sodium'].astype(int)

    """  df['Protein'] = round(df['Protein'])
    df['Carbs'] = round(df['Carbs'])
    df['TransFat'] = round(df['TransFat'])
    df['Vitamin C'] = round(df['Vitamin C'])
    df['Sodium'] = round(df['Sodium']) """
    #df.round({"A":1, "B":2, "C":3, "D":4})
    #df.round({'Calories': 1, 'cats': 0})
    sorted_df = df.sort_values(by=["Meal"], ascending=True)

    

    sorted_df.reset_index(drop=True, inplace=True)


    sorted_df.to_csv(fileName + "sorted.csv")







if __name__ == "__main__":
    fileNames = ["Diner"]
    for i, currentDiner in enumerate(fileNames):
        process(fileNames[i])