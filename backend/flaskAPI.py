from flask import Flask
import mysql.connector
from flask import request
import get_recommendations
import random
import pandas as pd
import json

app=Flask(__name__)

@app.route('/getrecommendations',methods=["POST"])
def getresults():
    values = request.get_data()
    values_dict = json.loads(values)
    #print(values_dict)
    content_maal = get_recommendations.contentBased(values_dict['user'])
    contentresult_df = content_maal[0]
    contentcompanyids = contentresult_df['companyId'].tolist()


    #svd
    svdknn_collabdf = get_recommendations.SVDKNN(int(values_dict['userid']))
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
    
    lst=[]
    mydb=mysql.connector.connect(host='localhost',user='root',password='',database='portal')
    cur = mydb.cursor()
    sqlquery = 'select * from rand where companyid= '
    ffcompanies = ff['companyId'].tolist()
    for i in ffcompanies:
        var = sqlquery + str(i)
        cur.execute(var)
        lst.extend(cur.fetchall())
    print(lst)
    res_dict = {}
    for i in range(0,len(lst)):
        res_dict[i]=lst[i]
    return res_dict


@app.route('/signup',methods=["POST"])
def signup():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    cur=mydb.cursor()
    values=request. get_data()
    values_dict = json.loads(values)
    if values_dict:
        username=values_dict['uname']
        fullname=values_dict['fname']
        email=values_dict['email']
        password=values_dict['pass']
    else:
        return 'ERROR'
    sql = "INSERT INTO user (uname,pass,fname,email) VALUES (%s, %s,%s,%s)"
    val = (username,password,fullname,email)
    cur.execute(sql, val)
    mydb.commit()
    return 'DONE'


@app.route('/login',methods=["POST"])
def login():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    mycursor = mydb.cursor()
    values=request. get_data()
    values_dict = json.loads(values)
    if values_dict:
        username=values_dict['uname']
        password=values_dict['pass']
    else:
        return 'ERROR'
    val = (username,password)
    mycursor.execute("SELECT * FROM user where uname= %s and pass= %s",val)
    
    myresult = mycursor.fetchall()

    if len(myresult) > 0 :
        return 'True'
    else:
        return 'False'
app.run(host = "192.168.0.106")


