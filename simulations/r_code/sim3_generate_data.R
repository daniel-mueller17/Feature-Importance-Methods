set.seed(789)

n = 10000

### Simulation 3
# Y = X1 + X2 + X3 + X4 + eps but X3 and X4 higly correlated
x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n)
x4 = x3 + rnorm(n, sd = 0.01)

y = x1 + x2 + x3 + rnorm(n)

data_sim3 = data.frame(x1 = x1, x2 = x2, x3 = x3, x4 = x4, y = y)

write.csv(data_sim3, file = "./simulations/data/sim3_data.csv")