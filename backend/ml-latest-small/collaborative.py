import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
     

def ans(rating, company, sim):
    score = sim[company] * (rating-2.5)
    score = score.sort_values(ascending=False)
    return score

def standardize(df):
    new_df = (df - df.mean()) / (df.max() - df.min())
    return new_df

df = pd.read_csv('memorybasedcf2.csv')#reading csv
df = df.fillna(0)
df = df.iloc[:,1:]
companydf = pd.read_csv('companydataset.csv')
#print(df.columns)
#new_df=df.apply(standardize)

##df_2 = standardize(df)[['MM Media Pvt Ltd', 'find live infotech',
##       'Softtech Career Infosystem Pvt. Ltd', 'Onboard HRServices LLP',
##       'Spire Technologies and Solutions Pvt. Ltd.',
##       'PFS Web Global Services Pvt Ltd',
##       'Kinesis Management Consultant Pvt. Ltd',
##       'Agile HR consultancy Pvt. Ltd. hiring for Rossell Techsys, Bangalore.',
##       'HANSUM INDIA ELECTRONICS PVT.LTD.', 'Accenture', 'Premium']]
##
###tfv = TfidfVectorizer(min_df=3,max_df=0.7, max_features=None, strip_accents='unicode', analyzer='word', token_pattern=r'\w{1,}', ngram_range=(1, 3), stop_words='english')
###tvf_matrix = tfv.fit_transform(df_2)
##
sim = cosine_similarity(df.T)
#print(sim,new_df)
#[['MM Media Pvt Ltd', 'find live infotech',
##       'Softtech Career Infosystem Pvt. Ltd', 'Onboard HRServices LLP',
##       'Spire Technologies and Solutions Pvt. Ltd.',
##       'PFS Web Global Services Pvt Ltd',
##       'Kinesis Management Consultant Pvt. Ltd',
##       'Agile HR consultancy Pvt. Ltd. hiring for Rossell Techsys, Bangalore.',
##       'HANSUM INDIA ELECTRONICS PVT.LTD.', 'Accenture', 'Premium']].T)
##
##print(df_2)
simdf=pd.DataFrame(sim,index=df.columns,columns=df.columns)

data=[(4, str(companydf[companydf['companyname']=='Srinsoft Technologies Pvt. Ltd.  ']['companyId'].values[0])),(1, str(companydf[companydf['companyname']=='Signals & Systems (India) Pvt Ltd.']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Inmar Intelligence']['companyId'].values[0])),(5, str(companydf[companydf['companyname']=='Navabharat Limited ']['companyId'].values[0])),(2, str(companydf[companydf['companyname']=='Aptiv Technical Centre']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Authbridge Research Services Pvt Ltd']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Live Connections']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Sydac Simulation Technologies India Pvt Ltd  ']['companyId'].values[0])),(1,str(companydf[companydf['companyname']=='Impetus Technologies India Pvt. Ltd']['companyId'].values[0]))]
s=pd.DataFrame()
for rating,company in data:
    s= s.append(ans(rating,company,simdf),ignore_index=True)

s=s.sum().sort_values(ascending=False).head(10)
#print(s)

companyId = list(s.index)

rating = s.tolist()
rating2 = []
#print(companynames)

#print(ratings)

def normalize(val):
	normalized = (val-0)/(5-0)
	return normalized

for i in rating:
	if i<0:
		rating2.append(0)
	else:
		rating2.append(normalize(i))



collabresult = list(map(list,zip(companyId,rating2)))
#print(collabresult)

collabresult_df = pd.DataFrame(collabresult,columns=['companyId','rating'])
#print(collabresult_df)


