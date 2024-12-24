library(mlr3)
library(mlr3verse)

set.seed(1)


# Define function to calculate LOCO
loco = function(task, learner, resampling, loss) {
  features = task$feature_names
  
  res = numeric(length = features)
  names(res) = features
  
  original_model = resample(task = task, learner = learner, resampling = resampling)
  # maybe $score() ?
  original_loss = original_model$aggregate(loss)
  
  for (i in length(features)) {
    features2 = features[-i]
    task2 = task$clone()$select(features2)
    new_model = resample(task = task2, learner = learner, reampling = resampling)
    # maybe $score() ?
    new_loss = new_model$aggregate(loss)
    res[i] = new_loss - original_model
  }
  return(res)
}

