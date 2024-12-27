set.seed(1211)

n = 10000

### Simulation 5
# Y = X1 + X2 + x4 + X2*X4 + eps now with unnecessary X4, X5 and high correlated X3 and X4

x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n)
x4 = x3 + rnorm(n, sd = 0.1)
x5 = runif(n, min = -1, max = 1)
x6 = x5 + rnorm(n, sd = 0.01)

y = x1 + x2 + x4 + x2*x4 + rnorm(n)

data_sim5 = data.frame(x1 = x1, x2 = x2, x3 = x3, x4 = x4, x5 = x5, x6 = x6, y = y)

write.csv(data_sim5, file = "./simulations/data/sim5_data.csv")