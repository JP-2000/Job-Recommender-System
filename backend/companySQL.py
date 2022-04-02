from flask import Flask,render_template,request
from flask_mysqldb import MySQL
import json

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'company'

mysql = MySQL(app)


@app.route('/companies' , methods=['GET'])
def index():
	companyid = 1
	companyid = int(companyid)
	companyname = 'HCL'
	companyrating = 5
	companyrating = int(companyrating)
	cur = mysql.connection.cursor()
	#val=(companyid,companyname,companyrating)
	cur.execute('select * from companytable2 limit 10')
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
		d[c]=i
		c+=1
	print(d)
	mysql.connection.commit()
	cur.close()
	return 'success'

if __name__=='__main__':
	app.run()
