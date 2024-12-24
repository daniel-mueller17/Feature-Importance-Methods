library("iml")
library("mlr3")
library("mlr3verse")

set.seed(123)

n = 10000

ntrain = 0.7 * n

### Simulation 1
# Y = X1 + X2 + X3 + eps

x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n, sd = 2)

y = x1 + x2 + x3 + rnorm(n, 0.1)

data_sim1 = data.frame(x1 = x1, x2 = x2, x3 = x3, y = y)

write.csv(data_sim1, file = "./simulations/data/sim1_data.csv" )

# task = TaskRegr$new(id='simulation1', backend=data_sim1, target='y')
# learner = lrn('regr.lm')
# 
# train_set = sample(task$nrow, ntrain)
# test_set = setdiff(seq_len(task$nrow), train_set)
# 
# learner$train(task, row_ids = train_set)
# learner$model
# 
# predictor_test = Predictor$new(learner, data_sim1[test_set,], y='y')
# 
# imp_test <- FeatureImp$new(predictor_test,loss = "mse", n.repetitions = 10, compare='difference')
# 
# plot(imp_test)