import numpy as np
import pandas as pd
import random
import torch

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

import statsmodels.formula.api as smf

from fippy import Explainer
from fippy.samplers import GaussianSampler

# Computes mean feature importance. Returns da pd.dataframe
def fi_importance(object):
    scores = object.scores
    df = pd.DataFrame(scores.mean(), columns=['importance'])
    df.index.set_names(['feature'], inplace=True)
    return df

# datasets to use
data = pd.read_csv("./simulations/data/sim5_data.csv")
data = data[['x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'y']]

ntrain = int(0.8 * data.shape[0])

xcolumns = ['x1', 'x2', 'x3', 'x4', 'x5', 'x6']
# ycolumn = ['y']

df_train, df_test = data.iloc[0:ntrain,], data.iloc[ntrain:,]
X_train, y_train = df_train[xcolumns], df_train['y']
X_test, y_test = df_test[xcolumns], df_test['y']


# fit model
np.random.seed(1)
random.seed(1)
torch.manual_seed(1)

formula = 'y ~ x1 + x2 + x3 + x4 + x5 + x6 + x1:x2 + x1:x3 + x1:x4 + x1:x5 +x1:x6 + x2:x3 + x2:x4 + x2:x5 + x2:x6 + x3:x4 + x3:x5 + x3:x6 + x4:x5 + x4:x6 + x5:x6'
lm = smf.ols(formula = formula, data=df_train).fit()

y_pred = lm.predict(X_test)
mse_lm = mean_squared_error(y_test, y_pred)
r2_lm = r2_score(y_test, y_pred)

print("Coeff: {}".format(lm.params))
print("MSE: {}".format(mse_lm))
print("R2_score: {}".format(r2_lm))


# calculate Feature Importance
sampler = GaussianSampler(X_train)
wrk = Explainer(lm.predict, X_train, loss = mean_squared_error, sampler = sampler)

# PFI
sim5_pfi = wrk.pfi(X_test, y_test, nr_resample_marginalize = 50)
df_pfi = fi_importance(sim5_pfi)
df_pfi['type'] = 'PFI'

# CFI
sim5_cfi = wrk.cfi(X_test, y_test, nr_resample_marginalize = 50)
df_cfi = fi_importance(sim5_cfi)
df_cfi['type'] = 'CFI'

sim5_df_res_pfi_cfi = pd.concat([df_pfi, df_cfi])
sim5_df_res_pfi_cfi.to_csv("./simulations/data/sim5_df_res_pfi_cfi.csv")
