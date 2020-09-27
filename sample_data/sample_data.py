import pandas as pd
from numpy.random import randint
from numpy.random import seed
import numpy as np
import sys
import time
from datetime import datetime, timedelta
import csv
import random

random_postcodes = ['KY5 0YR','BL9 6HE','SL3 3AA','WF5 8PU','N22 5PT']
nbr_users  = 50 # number of users 
user_id_list = randint(1001, 9999, nbr_users) # generate a random user_id on the interval [1000,9999]

# 
def insert_row(df, row):
    """ Inserts a row into an existing pandas dataframe  """
    insert_loc = df.index.max()
    if pd.isna(insert_loc):
        df.loc[0] = row
    else:
        df.loc[insert_loc + 1] = row
        
        
def RandomTimestamp(start, end):
    """ The function picks a random datetime between two specified dates """
    dts = (end - start).total_seconds()
    return start + pd.Timedelta(np.random.uniform(0, dts), 's')
            
def generate_user_daily_extract(user_list,nbr_users = 5,offset_date = 0):
    """ Generates user data  """
    # create an empty user dataframe
    users_df = pd.DataFrame(columns=['id','postcode','extract_date'])
    today = datetime.now()
    extract_date  = today + timedelta(days=offset_date)
    for user_id in user_list:
        random_postcode = random.choice(random_postcodes) # one postcode per user per day
        insert_row(users_df,[user_id,random_postcode,extract_date.strftime("%Y%m%d")])         
        exract_file_name = 'user_extract_%s.csv' %(extract_date.strftime("%Y%m%d"))
        users_df.to_csv(exract_file_name,index = False,quoting=csv.QUOTE_NONNUMERIC)


def generate_pageview_hourly_extract(user_list,offset_date = 0,offset_hour = 0):
    """ Generates pageview data  """
    pageviews_df = pd.DataFrame(columns=['user_id','url','pageview_datetime'],)
    # for each hour 
    for user_id in user_list:
        sample_page_number = randint(3, 30, 1)[0] # random number of pageviews per user
        for page_id in range(1,sample_page_number):
            page_url = 'https://www.testpage.com/item%s' %(page_id)
            today = datetime.now() + timedelta(minutes=page_id)
            extract_date  = today + timedelta(days=offset_date)
            pageview_hour = extract_date + pd.offsets.Hour(offset_hour)
            insert_row(pageviews_df,[user_id,page_url,pageview_hour])
    exract_file_name = 'pageview_extract_%s.csv' %(pageview_hour.strftime("%Y%m%d%H"))
    pageviews_df.to_csv(exract_file_name,index = False,quoting=csv.QUOTE_NONNUMERIC)
    
# seed random number generator
seed(1)
# main program
for offset_date in range(-29,1):
    # this generates a daily user extract (number of user provided)
    generate_user_daily_extract(user_id_list,5,offset_date)
    # this generates an hourly pageview extract
    for offset_hour in range(0,6):
        generate_pageview_hourly_extract(user_id_list,offset_date,offset_hour)
