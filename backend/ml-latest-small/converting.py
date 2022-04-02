import pandas as pd
import numpy as np
from csv import writer

df = pd.read_csv('ratings.csv')
#df.drop('timestamp')

#try:
#	for x in df['movieId']:
#		if x>=3379:
#			i = df[(df.movieId==x)].index
#			df = df.drop(c)
#		c+=1
#except:
#	pass

#print(df['movieId'])

#df.to_csv('final.csv', index=False)

#df['split'] = np.random.randn(df.shape[0],1)

#msk = np.random.rand(len(df)) <=0.7


#train_df = df[msk]
#test_df = df[~msk]




train_df = pd.read_csv('train.csv')


test_df = pd.read_csv('test.csv')

training_set = np.array(train_df,dtype='int')
test_set = np.array(test_df,dtype='int')

rating_set = np.array(df,dtype='int')


nb_users = int(max(max(training_set[:,0]), max(test_set[:,0])))
nb_movies = int(max(max(training_set[:,1]), max(test_set[:,1])))

def convert(data):
    new_data = []
    for id_users in range(1, nb_users + 1):
        id_movies = data[:,1][data[:,0] == id_users]
        id_ratings = data[:,2][data[:,0] == id_users]
        ratings = np.zeros(nb_movies)
        ratings[id_movies - 1] = id_ratings
        new_data.append(list(ratings))
    return new_data
#training_set = convert(training_set)
#test_set = convert(test_set)
rating_set = convert(rating_set)


#print(training_set[0])


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

hello = pd.DataFrame(columns=cfinal)
print(cfinal)
#hello.to_csv('memorybasedcf.csv')


#for x in training_set:
#	with open('memorybasedcf.csv','a+',newline='') as write_obj:
 #   		csv_writer = writer(write_obj)
  #  		csv_writer.writerow(x)












