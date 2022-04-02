import pandas as pd
import random
import get_recommendations

#content-based
content_maal = get_recommendations.contentBased({"Exp": "0", "Location": "Mumbai", "Skills": ",Python, Java, Linux, HTML, CSS" })
contentresult_df = content_maal[0]
contentcompanyids = contentresult_df['companyId'].tolist()

#svd
svdknn_collabdf = get_recommendations.SVDKNN(1)
topsvdknnresults = svdknn_collabdf.head(10)
topsvdknncompanyids = topsvdknnresults['companyId'].tolist()

#collaborative
collabresult_df = get_recommendations.MemoryBasedCF()
topcollabresult_df = collabresult_df.sort_values(['rating'],ascending=False).head(10)
collabcompanyids = topcollabresult_df['companyId'].tolist()


finallist = []
for i in contentcompanyids:
	cid = i
	contentrating = content_maal[1][0][int(i)]
	
	collabrating = collabresult_df[collabresult_df['companyId']==str(int(i))]['rating'].values[0]
	finallist.append([cid,collabrating,contentrating])
finalcontent = pd.DataFrame(finallist,columns = ['companyId','Collabrating','Contentrating'])

finallist=[]
for i in collabcompanyids:
	cid = i
	collabrating = collabresult_df[collabresult_df['companyId']==str(i)]['rating'].values[0]
	contentrating = content_maal[1][0][int(i)]
	finallist.append([cid,collabrating,contentrating])
finalcollab = pd.DataFrame(finallist,columns=['companyId','Collabrating','Contentrating'])

finallist = []
for i in topsvdknncompanyids:
	cid = i
	contentrating = content_maal[1][0][int(i)]
	collabrating = svdknn_collabdf[svdknn_collabdf['companyId']==i]['rating'].values[0]
	finallist.append([cid,collabrating,contentrating])
svdknnresult_df = pd.DataFrame(finallist,columns = ['companyId','Collabrating','Contentrating'])

final_df = pd.concat([finalcollab,finalcontent,svdknnresult_df])

weighted_average = []
weighted_average1=[]
collabfinaldf = pd.concat([finalcollab,svdknnresult_df])
colab=collabfinaldf['Collabrating'].tolist()
scontent=collabfinaldf['Contentrating'].tolist()
for i in range(len(colab)): 
        temp = ((float(colab[i])*0.5) + (float(scontent[i])*0.5) ) 
        weighted_average1.append(temp)


collabfinaldf['Collabrating']=weighted_average1
ff = pd.concat([collabfinaldf,finalcontent])

concol=ff['Collabrating'].tolist()
collcol=ff['Contentrating'].tolist()
for i in range(len(concol)): 
        temp = ((float(concol[i])*0.40) + (float(collcol[i])*0.60) ) 
        weighted_average.append(temp)

ff['fwavg']=weighted_average
print(ff)





