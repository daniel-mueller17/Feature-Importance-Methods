library(mlr3)
library(mlr3learners)


# Define function to calculate LOCO
loco = function(task, learner, resampling, loss) {
  features = task$feature_names
  
  res = numeric(length(features))
  names(res) = features
  
  original_model = resample(task = task, learner = learner, resampling = resampling)
  # maybe $score() ?
  original_loss = original_model$aggregate(loss)
  
  for (i in 1:length(features)) {
    features2 = features[-i]
    task2 = task$clone()$select(features2)
    new_model = resample(task = task2, learner = learner, resampling = resampling)
    # maybe $score() ?
    new_loss = new_model$aggregate(loss)
    res[i] = new_loss - original_loss
  }
  return(res)
}

# Define function to calculate LOCI
loci = function(task, learner, resampling, loss) {
  features = task$feature_names
  
  res = numeric(length(features))
  names(res) = features
  
  featureless_learner = lrn("regr.featureless")
  featureless_model = resample(task, featureless_learner, resampling)
  # maybe $score() ?
  featureless_loss = featureless_model$aggregate(loss)
  
  for (i in 1:length(features)) {
    features2 = features[i]
    task2 = task$clone()$select(features2)
    new_model = resample(task2, learner, resampling)
    # maybe $score() ?
    new_loss = new_model$aggregate(loss)
    res[i] = featureless_loss - new_loss
  }
  return(res)
}


set.seed(1)

load("./application_real_data/data/bike.RData") # data now bike dataset
# load("./application_real_data/data/bike_train.RData") # df_train now training set
# load("./application_real_data/data/bike_test.RData") # df_test now test set

task = as_task_regr(data, target = "cnt")
resampling = rsmp("subsampling", ratio = 0.67, repeats = 50)
resampling$instantiate(task)
learner = lrn("regr.ranger", num.trees = 500, min.node.size = 5)
loss = msr("regr.mse")

# calculate loco
res_loco = loco(task, learner, resampling, loss)
df_loco = data.frame(feature = names(res_loco),
                     importance = res_loco,
                     type = "LOCO")

# calculate LOCI
res_loci = loci(task, learner, resampling, loss)
df_loci = data.frame(feature = names(res_loci),
                     importance = res_loci,
                     type = "LOCI")

# save results
df_loco_loci = rbind(df_loco, df_loci)
write.csv(df_loco_loci, file = "./application_real_data/data/df_res_loco_loci.csv", row.names = FALSE)
