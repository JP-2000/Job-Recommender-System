from flask import Flask
import mysql.connector
from flask import request
from flask_mysqldb import MySQL
import json

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
