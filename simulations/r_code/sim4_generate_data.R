set.seed(678)

n = 10000

### Simulation 4
# Y = X1 + X2 + eps now with unnecessary X3, X4
x1 = rnorm(n)
x2 = rnorm(n)
x3 = runif(n, min = -1, max = 1)
x4 = x3 + rnorm(n, sd = 0.01)

y = x1 + x2 + rnorm(n)

data_sim4 = data.frame(x1 = x1, x2 = x2, x3 = x3, x4 = x4, y = y)

write.csv(data_sim4, file = "./simulations/data/sim4_data.csv")