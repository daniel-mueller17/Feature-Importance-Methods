import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import random
import torch

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

from fippy import Explainer
from fippy.samplers import GaussianSampler


def fi_means_quantiles(object):
    """Computes mean feature importance over all runs, as well as the
    respective .05 and .95 quantiles.

    Returns:
        A pd.DataFrame with the respective characteristics for every feature.
        features are rows, quantities are columns
    """
    # scores_agg = object.scores.groupby(level=object.groupbycol).mean()
    scores_agg = object.scores
    df = pd.DataFrame(scores_agg.mean(), columns=['mean'])
    df['q.05'] = scores_agg.quantile(0.05)
    df['q.95'] = scores_agg.quantile(0.95)
    df.index.set_names(['feature'], inplace=True)
    return df


# datasets to use
data = pd.read_csv("./simulations/data/sim1_data.csv")
data = data[['x1', 'x2', 'x3', 'y']]

ntrain = int(0.8 * data.shape[0])

xcolumns = ['x1', 'x2', 'x3']
# ycolumn = ['y']

df_train, df_test = data.iloc[0:ntrain,], data.iloc[ntrain:,]
X_train, y_train = df_train[xcolumns], df_train['y']
X_test, y_test = df_test[xcolumns], df_test['y']

#X_train, X_test, y_train, y_test = train_test_split(data[['x1', 'x2', 'x3']], data['y'], test_size=0.2, random_state=42)


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
sim1_pfi = wrk.pfi(X_test, y_test, nr_resample_marginalize = 50)
df_pfi = fi_means_quantiles(sim1_pfi)
df_pfi['type'] = 'PFI'

# CFI
sim1_cfi = wrk.cfi(X_test, y_test, nr_resample_marginalize = 50)
df_cfi = fi_means_quantiles(sim1_cfi)
df_cfi['type'] = 'CFI'

sim1_df_res_pfi_cfi = pd.concat([df_pfi, df_cfi])
sim1_df_res_pfi_cfi.to_csv("./simulations/data/sim1_df_res_pfi_cfi.csv")
