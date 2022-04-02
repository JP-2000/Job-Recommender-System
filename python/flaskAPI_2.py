from flask import Flask
import mysql.connector
from flask import request
import json
from datetime import date


app=Flask(__name__)

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


@app.route('/companies',methods=["GET"])
def getCompanies():
    mydb=mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="portal")
    mycursor = mydb.cursor()
    mycursor.execute("select * from company tablesample(1 percent)")
    
    myresult = mycursor.fetchall()
    
    return 



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
            cur.execute(sql2, (x[0],x[1],x[2]))
            mydb.commit()
            cur.execute("SELECT edun FROM edu where schname=%s and per=%s and degree=%s ",(x[0],x[1],x[2]))
            eduno.append(cur.fetchall()[0][0])
            
    except:
        return 'ERROR edu'
    
    
    #insert experience
    
    try:
        sql4 = "INSERT INTO exp(jobt,companyname,strtd,endd,jobdesc) VALUES (%s,%s,%s,%s,%s)"
        #print(education)
        expno=0
        
        for x in exp:
                
            cur.execute(sql4,(x[0],x[1],x[2],x[3],x[4]))
            mydb.commit()
            start = x[2].split('/')
            end = x[3].split('/')

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

app.run()
