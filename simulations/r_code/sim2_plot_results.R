library(ggplot2)
theme_set(theme_bw(base_size = 18))
color_vector = c("red", "#0066CC", "#FF9900", "#999999", "#9900FF", "#99CCFF")


# load datasets
df_pfi_cfi = read.csv("./simulations/data/sim2_df_res_pfi_cfi.csv")
df_loco_loci = read.csv("./simulations/data/sim2_df_res_loco_loci.csv")


df = rbind(df_pfi_cfi, df_loco_loci)
df$feature = as.factor(df$feature)
df$i = length(df$feature):1


# Plot
sim2 = ggplot(data = df, aes(y = reorder(type, i),  x = importance, fill = reorder(feature, i))) +
  geom_col(position = position_dodge()) +
  labs(y = "method",
       fill = "feature") + 
  scale_fill_manual(values = color_vector, breaks = c("x1", "x2", "x3", "x4"), 
                    labels = c(expression(X[1]), expression(X[2]), expression(X[3]), expression(X[4]))) +
  theme(legend.position = "bottom")

sim2

# Save plot
ggsave(filename = "./simulations/plots/sim2.pdf")