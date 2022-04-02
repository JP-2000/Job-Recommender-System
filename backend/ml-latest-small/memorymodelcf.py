import pandas as pd


company_df = pd.read_csv('companydataset.csv')

companyname = company_df.at[1,'companyname']

print(companyname)
