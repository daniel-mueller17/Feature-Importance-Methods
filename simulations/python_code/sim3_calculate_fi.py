import numpy as np
import pandas as pd
import random
import torch

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

from fippy import Explainer
from fippy.samplers import GaussianSampler

# Computes mean feature importance. Returns da pd.dataframe
def fi_importance(object):
    scores = object.scores
    df = pd.DataFrame(scores.mean(), columns=['importance'])
    df.index.set_names(['feature'], inplace=True)
    return df

# datasets to use
data = pd.read_csv("./simulations/data/sim3_data.csv")
data = data[['x1', 'x2', 'x3', 'x4', 'x5', 'y']]

ntrain = int(0.8 * data.shape[0])

xcolumns = ['x1', 'x2', 'x3', 'x4', 'x5']
# ycolumn = ['y']

df_train, df_test = data.iloc[0:ntrain,], data.iloc[ntrain:,]
X_train, y_train = df_train[xcolumns], df_train['y']
X_test, y_test = df_test[xcolumns], df_test['y']


# fit model
np.random.seed(1)
random.seed(1)
torch.manual_seed(1)

lm = LinearRegression()
lm.fit(X_train, y_train)

y_pred = lm.predict(X_test)
mse_lm = mean_squared_error(y_test, y_pred)

print("Coeff: {}".format(lm.coef_))
print("MSE: {}".format(mse_lm))
print("R2_score: {}".format(lm.score(X_test, y_test)))


# calculate Feature Importance
sampler = GaussianSampler(X_train)
wrk = Explainer(lm.predict, X_train, loss = mean_squared_error, sampler = sampler)

# PFI
sim3_pfi = wrk.pfi(X_test, y_test, nr_resample_marginalize = 50)
df_pfi = fi_importance(sim3_pfi)
df_pfi['type'] = 'PFI'

# CFI
sim3_cfi = wrk.cfi(X_test, y_test, nr_resample_marginalize = 50)
df_cfi = fi_importance(sim3_cfi)
df_cfi['type'] = 'CFI'

sim3_df_res_pfi_cfi = pd.concat([df_pfi, df_cfi])
sim3_df_res_pfi_cfi.to_csv("./simulations/data/sim3_df_res_pfi_cfi.csv")
