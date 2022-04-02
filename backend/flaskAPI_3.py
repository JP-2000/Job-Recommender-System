from flask import Flask
import mysql.connector
from flask import request
import json
from datetime import date
import get_recommendations
import get_custom_recommendations
import random
import pandas as pd


app=Flask(__name__)

@app.route('/getuserdetails',methods=["POST"])
def getuserdetails():
	values = request. get_data()
	values_dict = json.loads(values)
	reqid = values_dict['id']
	mydb = mysql.connector.connect(
		host = 'localhost',
		user = 'root',
		password = '',
		database = 'portal'
	)
	cur = mydb.cursor()
	#location,exp,skills
	sqlquery = 'select prefloc,exp,skilln from profile where uid = %s'
	cur.execute(sqlquery,(reqid,))
	result = cur.fetchall()
	resultlist = [list(i) for i in result]
	exp = []
	location = []
	skills = []
	result_dict = {}
	lst=[]
	for i in resultlist:
		location.append(i[0])
		exp.append(i[1])
		skills.append(i[2])
	result_dict['Exp'] = exp
	result_dict['Location'] = location
	print(result_dict)
	sqlquery = 'select skill1,skill2,skill3,skill4,skill5,skill6,skill7,skill8,skill9,skill10 from skills where skilln='
	for i in skills:
		var = sqlquery + str(i)
		cur.execute(var)
		lst.extend(cur.fetchall())
	#print(lst)
	lst2 = []
	for i in lst:
		for j in i:
			lst2.append(j)
	print(lst2)
	#lst3 = [j for i in lst2 for j in i]
	result_dict['Skills'] = list(set(lst2))
	print(result_dict)
	return 'done'

@app.route('/getCustomRecommendations',methods=["POST"])
def getCustomRecommendations():
    values = request.get_data()
    values_dict = json.loads(values)
    
    # reqid = values_dict['userId']
    # lst = []
    # mydb = mysql.connector.connect(
    #     host = 'localhost',
    #     user = 'root',
    #     password = '',
    #     database = 'portal'
    # )
    # cur = mydb.cursor()
    # sqlquery = 'select exp,location,skills from rand where companyid=%s'
    # cur.execute(sqlquery,(reqid,))
    # result = cur.fetchall()
    # for i in result:
    #     for j in i:
    #         lst.append(j)
    # keys = ['Exp','Location','Skills']
    # user = dict(zip(keys,lst))

    content_maal = get_custom_recommendations.contentBased(values_dict['user'], values_dict['jobId'])
    contentresult_df = content_maal[0]
    contentcompanyids = contentresult_df['companyId'].tolist()
    
    lst=[]
    mydb=mysql.connector.connect(host='localhost',user='root',password='',database='portal')
    cur = mydb.cursor()
    sqlquery = 'select * from rand where companyid= '
    for i in contentcompanyids:
        var = sqlquery + str(i)
        cur.execute(var)
        lst.extend(cur.fetchall())
    print(lst)
    res_dict = {}
    for i in range(0,len(lst)):
        res_dict[i]=lst[i]
    return res_dict
    
    

@app.route('/getrecommendations',methods=["POST"])
def getresults():
    values = request.get_data()
    values_dict = json.loads(values)
    
    # reqid = values_dict['userId']
    # lst = []
    # mydb = mysql.connector.connect(
    #     host = 'localhost',
    #     user = 'root',
    #     password = '',
    #     database = 'portal'
    # )
    # cur = mydb.cursor()
    # sqlquery = 'select exp,location,skills from rand where companyid=%s'
    # cur.execute(sqlquery,(reqid,))
    # result = cur.fetchall()
    # for i in result:
    #     for j in i:
    #         lst.append(j)
    # keys = ['Exp','Location','Skills']
    # user = dict(zip(keys,lst))
    
    #print(values_dict)
    content_maal = get_recommendations.contentBased(values_dict['user'], "0")
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
        return str(myresult[0][0])
    else:
        return 'False'

@app.route('/companies' , methods=['GET'])
def index():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    cur = mydb.cursor()
    cur.execute('select * from jobs1 limit 11')
    data = cur.fetchall()
    translator = str.maketrans({chr(10): '', chr(9): ''})
    data = [list(i) for i in data]
    data2=[]
    temp=[]
    d={}
    for i in data:
        for j in i:
            if isinstance(j,str):
                #print(True)
                j=j.strip()
                temp.append(j)
                #print(j)
        data2.append(temp)
        temp=[]
    c=0
    for i in data2:
        if c == 0:
            pass
        else:
            d[c]=i
        c+=1
	# print(d)
    cur.close()
    return d



@app.route('/profile',methods=["POST"])
def profile():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    cur=mydb.cursor()
    values=request. get_data()
    #print(values)
    values_dict = json.loads(values)
    #print(values_dict)
    if values_dict:
        Prefloc=values_dict['prefloc']
        exp=values_dict['exp']
        skills=values_dict['skills']
        education=values_dict['edu']
        lang=values_dict['lang']
        dob=values_dict['dob']
        linkedinP=values_dict['linkedin']
        uid=values_dict['uid']
    #print(skills)
    #print( exp)
    #else:
    #    return 'ERROR'

    # insert skills
    #print(education)
    try:
        sql1 = "INSERT INTO skills(skill1,skill2,skill3,skill4,skill5,skill6,skill7,skill8,skill9,skill10) VALUES (%s, %s,%s,%s,%s,%s,%s,%s,%s,%s)"
        val1=[0]*10
        for x in range(len(skills)):
            val1[x] = skills[x]
        
        cur.execute(sql1, tuple(val1))
        mydb.commit()

        cur.execute("SELECT skilln FROM skills where skill1=%s and skill2=%s and skill3=%s and skill4=%s and skill5=%s and skill6=%s and skill7=%s and skill8=%s and skill9=%s and skill10=%s",val1)
        skillno = cur.fetchall()[0][0]
        #print(myresult)
   
    except:
        return 'ERROR skill'

    
    # insert education
    try:
        eduno=[]
        sql2 = "INSERT INTO edu(schname,per,degree) VALUES (%s,%s,%s)"
        for x in education:
            #print(xcolgname , 's')
            cur.execute(sql2, (x['collegeName'], x['percentage'], x['degree']))
            mydb.commit()
            cur.execute("SELECT edun FROM edu where schname=%s and per=%s and degree=%s ",(x['collegeName'], x['percentage'], x['degree']))
            eduno.append(cur.fetchall()[0][0])
            
    except:
        return 'ERROR edu'
    
    
    #insert experience
    
    try:
        sql4 = "INSERT INTO exp(jobt,companyname,strtd,endd,jobdesc) VALUES (%s,%s,%s,%s,%s)"
        #print(education)
        expno=0
        
        for x in exp:
                
            cur.execute(sql4,(x['jobTitle'],x['companyName'],x['startDate'],x['endDate'],x['jobDescription']))
            mydb.commit()
            start = x['startDate'].split('/')
            end = x['endDate'].split('/')

            start = list(map(int,start))
            end = list(map(int,end))

            values=[]
            for i,j in zip(start,end):
                val = j-i
                values.append(val)
            values = values[::-1]
            noyear=values[2]
            if noyear>1:
                noyear = noyear*12
            nomonth=values[1]
            nofyear = (nomonth+noyear) / 12
            expno+=nofyear
    except:
        return 'ERROR wxp'

    
        
    # insert languages
    try:
        sql3 = "INSERT INTO lang(lang1,lang2,lang3,lang4,lang5) VALUES (%s, %s,%s,%s,%s)"
        val3=[0]*5

        for x in range(len(lang)):
            val3[x] = lang[x]
        
        cur.execute(sql3, tuple(val3))
        mydb.commit()
        #print(val3)
        #cur.execute("SELECT langn FROM lang where ",val)
        cur.execute("SELECT langn FROM lang where lang1=%s and lang2=%s and lang3=%s and lang4=%s and lang5=%s",val3)
        langno = cur.fetchall()[0][0]
    
    except:
        return 'ERROR dgfdg'
        
        
    
    for x in eduno:
        sql = "INSERT INTO profile(prefloc,exp,skilln,langn,edun,dob,linkedin,uid) VALUES (%s, %s,%s,%s,%s,%s,%s,%s)"
        val = (Prefloc,expno,skillno,langno,x,dob,linkedinP,uid)
        cur.execute(sql, val)
        mydb.commit()
    return 'DONE'

@app.route('/chkprofile',methods=["GET"])
def chkprofile():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    cur=mydb.cursor()
    # values=request. get_data()
    #print(values)
    # values_dict = json.loads(values)
    #print(values_dict)
    # if values_dict:
    uid= request.args.get('uid')
    #print(uid)
    sql="select * from profile where uid="+str(uid)
    #print(sql)
    cur.execute(sql)
    try:
        if cur.fetchall()[0][0] :
            return 'True'
    except:
        return 'False'

app.run(host = "192.168.0.106")
