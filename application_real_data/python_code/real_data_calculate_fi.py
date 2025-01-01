import numpy as np
import pandas as pd
import random
import torch

from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, root_mean_squared_error, r2_score
from sklearn.preprocessing import OrdinalEncoder

from fippy import Explainer
from fippy.samplers import GaussianSampler

# Computes mean feature importance. Returns da pd.dataframe
def fi_importance(object):
    scores = object.scores
    df = pd.DataFrame(scores.mean(), columns=['importance'])
    df.index.set_names(['feature'], inplace=True)
    return df

# datasets to use
df_train = pd.read_csv("./application_real_data/data/bike_train.csv")
df_test = pd.read_csv("./application_real_data/data/bike_test.csv")


# Preprocessing data
# Train data
df_train['season'] = OrdinalEncoder(categories = [["SPRING", "SUMMER", "FALL", "WINTER"]]).fit_transform(df_train[['season']]) + 1
df_train['yr'] = OrdinalEncoder(categories = [["2011", "2012"]]).fit_transform(df_train[['yr']])
df_train['mnth'] = OrdinalEncoder(categories = [["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL",
                                                   "AUG", "SEP", "OCT", "NOV", "DEC"]]).fit_transform(df_train[['mnth']]) + 1
df_train['holiday'] = OrdinalEncoder(categories = [["NO", "YES"]]).fit_transform(df_train[['holiday']])
df_train['weekday'] = OrdinalEncoder(categories = [["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]]).fit_transform(df_train[['weekday']])
df_train['workingday'] = OrdinalEncoder(categories = [["FREEDAY", "WORKDAY"]]).fit_transform(df_train[['workingday']])

#Test data
df_test['season'] = OrdinalEncoder(categories = [["SPRING", "SUMMER", "FALL", "WINTER"]]).fit_transform(df_test[['season']]) + 1
df_test['yr'] = OrdinalEncoder(categories = [["2011", "2012"]]).fit_transform(df_test[['yr']])
df_test['mnth'] = OrdinalEncoder(categories = [["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL",
                                                   "AUG", "SEP", "OCT", "NOV", "DEC"]]).fit_transform(df_test[['mnth']]) + 1
df_test['holiday'] = OrdinalEncoder(categories = [["NO", "YES"]]).fit_transform(df_test[['holiday']])
df_test['weekday'] = OrdinalEncoder(categories = [["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]]).fit_transform(df_test[['weekday']])
df_test['workingday'] = OrdinalEncoder(categories = [["FREEDAY", "WORKDAY"]]).fit_transform(df_test[['workingday']])


# Training and Test data
X_train, y_train = df_train.iloc[:, 1:11], df_train.iloc[:, 11]
X_test, y_test = df_test.iloc[:, 1:11], df_test.iloc[:, 11]


# fit model
np.random.seed(1)
random.seed(1)
torch.manual_seed(1)

rf = RandomForestRegressor(n_estimators = 500, min_samples_leaf = 5)
rf.fit(X_train, y_train)

y_pred = rf.predict(X_test)
mse_rf = mean_squared_error(y_test, y_pred)
rmse_rf = root_mean_squared_error(y_test, y_pred)
r2_rf = r2_score(y_test, y_pred)

print("MSE: {}".format(mse_rf))
print("RMSE: {}".format(rmse_rf))
print("R2_score: {}".format(r2_rf))


# calculate Feature Importance
sampler = GaussianSampler(X_train)
wrk = Explainer(rf.predict, X_train, loss = mean_squared_error, sampler = sampler)

# PFI
pfi = wrk.pfi(X_test, y_test, nr_resample_marginalize = 50)
df_pfi = fi_importance(pfi)
df_pfi['type'] = 'PFI'

# CFI
cfi = wrk.cfi(X_test, y_test, nr_resample_marginalize = 50)
df_cfi = fi_importance(cfi)
df_cfi['type'] = 'CFI'

df_res_pfi_cfi = pd.concat([df_pfi, df_cfi])
df_res_pfi_cfi.to_csv("./application_real_data/data/df_res_pfi_cfi.csv")
