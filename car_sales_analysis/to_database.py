######################################################################### importing the relevant libraries
import pandas as pd
import numpy as np
import glob
import time
from sqlalchemy import create_engine
import pyodbc
import yaml
import os

start = time.time()

##################################################################### location of the files we want to process

filepath = r"Datasets"

######################################################################## setting up a database connection
driver = 'SQL Server'
server = 'localhost'
database = 'cars'

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};Server='+server+';Database='+database+';Trusted_Connection=yes;')
cursor = cnxn.cursor()

engine = create_engine('mssql+pyodbc://@' + server + '/' + database + '?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server', fast_executemany=True)


################################################################ establishing a database connection and run a few test queries

def create_database_connection():

    """
    Establish connection to the database 
    Return the connection and cursor refrence
    :return: returns (cur, conn) a cursor and connection reference
    """

    # Opening the YAML config file
    with open("mssql_config.yml") as f:
        content = f.read()

    # from config.yml import user name and password
    config = yaml.load(content, Loader=yaml.FullLoader)
    
    cnxn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes', 
        fast_executemany=True, 
        pool_pre_ping=True
    )
    cur = cnxn.cursor()
    
    return cur, cnxn


def drop_tables(cur, cnxn):

    # cur.execute("""CREATE SCHEMA cars """)

    cur.execute(""" DROP TABLE IF EXISTS cars.bodytype""")
    cur.execute(""" DROP TABLE IF EXISTS cars.categories""")
    cur.execute(""" DROP TABLE IF EXISTS cars.condition""")
    cur.execute(""" DROP TABLE IF EXISTS cars.listing""")
    cur.execute(""" DROP TABLE IF EXISTS cars.trueprices""")
    cnxn.commit()
    print("Successfully dropped tables")


############################################################################### function to process and load data
def process_data(filepath):

    """
    import the datasets from where they are (locally or on the web) directly to the database
    - In this case, the datasets are sitting locally in CSV files on my machine
    """


    # get all files matching extension from directory
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root + '/*.csv'))

        for file in files:
            df = pd.read_csv(file, header = 0, delimiter=";", decimal = ",", index_col=False)

            df.to_sql(f'{file[9:-4]}', engine, schema='cars', if_exists='append', index=False, chunksize=10000)
            print(f"data transformed and inserted for {file}")


########################################################### create a main database function to run all database constructs and queries

def database_main():

    cur, cnxn = create_database_connection()
    drop_tables(cur, cnxn)
    cnxn.close()

# ############################################################### Main function to run all functions
if __name__ == "__main__":

    database_main()
    process_data(filepath)


#  ############################################################### Calculating time for processing

end = time.time()
print(
    f"The program took {end - start} seconds to run")