import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from surprise import SVD
from surprise import Dataset
from surprise import Reader
from surprise.model_selection import cross_validate
from surprise.model_selection import train_test_split
from surprise import accuracy


def contentBased(newUser, id):
    user = pd.DataFrame(newUser, index=[0])
    df = pd.read_csv('Rand.csv')
    df = pd.concat([user, df]).reset_index(drop=True)

    tfv = TfidfVectorizer(min_df=1, max_df=0.7,
                        max_features=None,
                        strip_accents='unicode',
                        analyzer='word', token_pattern=r'\w{1,}',
                        ngram_range=(1, 3), stop_words='english')

    parameters_list = ['Exp', 'Location', 'Skills']
    objects_list = []

    class Parameter:
        def __init__(self, name, id):
            self.name = name
            self.dataframe = df[self.name].fillna('')
            self.vector_matrix = tfv.fit_transform(self.dataframe)
            self.sim_matrix = cosine_similarity(
                self.vector_matrix[id], self.vector_matrix)
            self.sim_matrix = np.array(self.sim_matrix)

    def sim_matrix():
        sim_matrix = []
        order_of_sim_matrix = len(np.array(df))
        for i in range(0, 1):
            temp = []
            for j in range(0, order_of_sim_matrix):
                value = 0
                for k in objects_list:
                    value += k.sim_matrix[i][j]
                temp.append(value/len(objects_list))
            sim_matrix.append(temp)
        return sim_matrix

    def index_matrix(matrix):
        index_matrix = []
        for i in range(0, len(matrix)):
            x = list(enumerate(matrix[i]))
            y = sorted(x, key=lambda x: x[1], reverse=True)
            temp = []
            for j in y:
                temp.append(j[0])
            index_matrix.append(temp)
        return index_matrix

    id = 0
    for i in range(0, len(parameters_list)):
        objects_list.append(Parameter(parameters_list[i], id))

    sim_matrix = sim_matrix()
    index_matrix = index_matrix(sim_matrix)

    no_of_recommendations = 10
    index_list = index_matrix[0]
    index_list.remove(id)
    recommendations = []
    for i in range(0, no_of_recommendations):
        index = index_list[i]
        recommendations.append(int(df.loc[index]['companyId']))
    recommendations_df = pd.DataFrame(recommendations, columns=['companyId'])
    recommendations_df.to_csv('recommendations.csv',
                            index=False, encoding='utf-8')
    return [recommendations_df, sim_matrix]


def SVDKNN(uid):
    algo_SVD = SVD()
    df = pd.read_csv('newrating.csv')

    company_df = pd.read_csv('companydataset.csv')

    reader = Reader(rating_scale=(0, 5))
    rating_df = Dataset.load_from_df(
        df[['userId', 'companyId', 'rating']], reader)

    
    cross_validate_SVD = cross_validate(algo_SVD, rating_df, measures=[
                                        'RMSE', 'MAE'], cv=5, verbose=True)

    def train_test_algo(algo, label):
        training_set, testing_set = train_test_split(rating_df, test_size=0.2)
        algo.fit(training_set)
        test_output = algo.test(testing_set)
        test_df = pd.DataFrame(test_output)

        # print("RMSE -", label, accuracy.rmse(test_output, verbose=False))
        # print("MAE -", label, accuracy.mae(test_output, verbose=False))
        # print("MSE -", label, accuracy.mse(test_output, verbose=False))

        return test_df

    train_test_SVD = train_test_algo(algo_SVD, "algo_SVD")

    def normalize(val):
        normalized = (val-0)/(5-0)
        return normalized

    def prediction(algo, users_K):
        pred_list = []
        for userId in range(1, users_K):
            for companyId in range(1, 10012):
                rating = algo.predict(userId, companyId).est
                rating = normalize(rating)
                
                
                pred_list.append([userId, companyId, rating])
        pred_df = pd.DataFrame(pred_list, columns=[
                            'userId', 'companyId', 'rating'])
        return pred_df

    pred_SVD = prediction(algo_SVD, 10)

    result_df = pred_SVD

    sorted_df = result_df.groupby(('userId'), as_index=False).apply(
        lambda x: x.sort_values(['rating'], ascending=False)).reset_index(drop=True)

    recommendations_df = sorted_df[sorted_df['userId'] == uid]
    return recommendations_df

def MemoryBasedCF():
    def ans(rating, company, sim):
        score = sim[company] * (rating-2.5)
        score = score.sort_values(ascending=False)
        return score

    def standardize(df):
        new_df = (df - df.mean()) / (df.max() - df.min())
        return new_df

    df = pd.read_csv('memorybasedcf2.csv')  
    df = df.fillna(0)
    df = df.iloc[:, 1:]
    companydf = pd.read_csv('companydataset.csv') 

    sim = cosine_similarity(df.T)

    simdf = pd.DataFrame(sim, index=df.columns, columns=df.columns)
    data=[(4, str(companydf[companydf['companyname']=='Srinsoft Technologies Pvt. Ltd.  ']['companyId'].values[0])),(1, str(companydf[companydf['companyname']=='Signals & Systems (India) Pvt Ltd.']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Inmar Intelligence']['companyId'].values[0])),(5, str(companydf[companydf['companyname']=='Navabharat Limited ']['companyId'].values[0])),(2, str(companydf[companydf['companyname']=='Aptiv Technical Centre']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Authbridge Research Services Pvt Ltd']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Live Connections']['companyId'].values[0])),(3, str(companydf[companydf['companyname']=='Sydac Simulation Technologies India Pvt Ltd  ']['companyId'].values[0])),(1,str(companydf[companydf['companyname']=='Impetus Technologies India Pvt. Ltd']['companyId'].values[0]))]

    s = pd.DataFrame()
    for rating, company in data:
        s = s.append(ans(rating, company, simdf), ignore_index=True)
    s = s.sum().sort_values(ascending=False)

    companyId = list(s.index)

    rating = s.tolist()
    rating2 = []

    def normalize(val):
        normalized = (val-0)/(5-0)
        return normalized

    for i in rating:
        if i < 0:
            rating2.append(0)
        else:
            rating2.append(normalize(i))

    collabresult = list(map(list, zip(companyId, rating2)))

    collabresult_df = pd.DataFrame(
        collabresult, columns=['companyId', 'rating'])
    
    return collabresult_df
    
    
# print(ContentBased({"Exp": "0", "Location": "Mumbai", "Skills": ",Python, Java, Linux, HTML, CSS" }))
# print(SVDKNN(1))
# print(MemoryBasedCF())
    
