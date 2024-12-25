set.seed(245)

n = 10000

### Simulation 2
# Y = X1 + X2 + X3 + eps now with unnecessary X4, X5
x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n)
x4 = runif(n, min = -1, max = 1)
x5 = x4 + rnorm(n, sd = 0.01)

y = x1 + x2 + x3 + rnorm(n, sd = 0.1)

y = x1 + x2 + x3 + rnorm(n, 0.1)

data_sim2 = data.frame(x1 = x1, x2 = x2, x3 = x3, x4 = x4, x5 = x5, y = y)

write.csv(data_sim2, file = "./simulations/data/sim2_data.csv")