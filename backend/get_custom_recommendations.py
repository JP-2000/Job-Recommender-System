import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

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

    id = int(id)
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