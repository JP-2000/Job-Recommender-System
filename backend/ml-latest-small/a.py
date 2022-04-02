import pandas as pd
import svdknn
import collaborative
from sklearn.metrics.pairwise import cosine_similarity

svdknn_results = svdknn.svdresult_df.drop(['userId'],axis=1)

finalresult_df = pd.concat([svdknn_results,collaborative.collabresult_df],axis=0)

finalresult_df = finalresult_df.sort_values(['rating'],ascending=False)
print(finalresult_df.rating.tolist())

#print(cosine_similarity([finalresult_df.rating.tolist(), finalresult_df.rating.tolist()]))
