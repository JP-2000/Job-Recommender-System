import pandas as pd
from surprise import KNNWithMeans
from surprise import SVD
from surprise import Dataset
from surprise import Reader
from surprise.model_selection import cross_validate
from surprise.model_selection import train_test_split
from surprise import accuracy



# KNN
#similarity = {
#    "name": "cosine",
#    "user_based": False,  # item-based similarity
#}
#algo_KNN = KNNWithMeans(sim_options = similarity)
# SVD
algo_SVD = SVD()




df = pd.read_csv('ratings.csv')

company_df = pd.read_csv('companydataset.csv')
#print(df['Company Name'])


# load df into Surprise Reader object
reader = Reader(rating_scale = (0,5))
rating_df = Dataset.load_from_df(df[['userId','movieId','rating']], reader)



#cross_validate_KNN = cross_validate(algo_KNN, rating_df, measures=['RMSE', 'MAE'], cv=5, verbose=True)
cross_validate_SVD = cross_validate(algo_SVD, rating_df, measures=['RMSE', 'MAE'], cv=5, verbose=True)


# define train test function
def train_test_algo(algo, label):
    training_set, testing_set = train_test_split(rating_df, test_size = 0.2)
    algo.fit(training_set)
    test_output = algo.test(testing_set)
    test_df = pd.DataFrame(test_output)
    
    print("RMSE -",label, accuracy.rmse(test_output, verbose = False))
    print("MAE -", label, accuracy.mae(test_output, verbose=False))
    print("MSE -", label, accuracy.mse(test_output, verbose=False))
    
    return test_df
    
#print('*******Validation Scores of KNN and SVD********')    
#train_test_KNN = train_test_algo(algo_KNN, "algo_KNN")
#print(train_test_KNN.head())
train_test_SVD = train_test_algo(algo_SVD, "algo_SVD")
#print(train_test_SVD.head())

def normalize(val):
	normalized = (val-0)/(5-0)
	return normalized


def prediction(algo, users_K):
    pred_list = []
    for userId in range(1,users_K):
        for movieId in range(1,3377):
            rating = algo.predict(userId, movieId).est
            rating = normalize(rating)
            companyname = company_df.at[movieId,'companyname']
            pred_list.append([userId, companyname, rating])
    pred_df = pd.DataFrame(pred_list, columns = ['userId', 'companyname', 'rating'])
    return pred_df



#pred_KNN = prediction(algo_KNN, 10)

pred_SVD = prediction(algo_SVD, 10)

result_df = pred_SVD

sorted_df = result_df.groupby(('userId'), as_index = False).apply(lambda x: x.sort_values(['rating'], ascending = False)).reset_index(drop=True)

top_recommendation = sorted_df.groupby('userId').head(10)

svdresult_df = top_recommendation[top_recommendation.userId==1]
#print(svdresult_df)
#print('KNN recommendations')
#print(pred_KNN)

#print('SVD recommendations')
#print(pred_SVD)







