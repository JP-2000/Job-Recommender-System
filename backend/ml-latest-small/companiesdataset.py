import pandas as pd
from random import randrange
from csv import writer

df1 = pd.read_csv('../jobs1.csv')

c1 = df1['Company Name'].tolist()

#print(c1)

df2 = pd.read_csv('../jobs2.csv')

c2 = df2['Company Name'].tolist()
#print(c2)
df3 = pd.read_csv('../jobs3.csv')

c3 = df3['Company Name'].tolist()

cfinal = c1+c2+c3
cfinal.pop(0)


print(len(cfinal) , len(list(set(cfinal))))

cfinal = list(set(cfinal))
cfinal.pop(0)



csvlist = []
c=1
for i in cfinal:
	csvlist.append([c,i])
	c+=1
print(csvlist)

hello = pd.DataFrame(csvlist , columns=['companyId','companyname'])

hello.to_csv('companydataset.csv')
