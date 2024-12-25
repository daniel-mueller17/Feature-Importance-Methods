library(ggplot2)
theme_set(theme_bw(base_size = 18))


# load datasets
df_pfi_cfi = read.csv("./simulations/data/sim1_df_res_pfi_cfi.csv")
df_loco_loci = read.csv("./simulations/data/sim1_df_res_loco_loci.csv")

colnames(df_pfi_cfi)[2] = "importance"

df = rbind(df_pfi_cfi[names(df_loco_loci)], df_loco_loci)
df$feature = as.factor(df$feature)
df$i = length(df$feature):1


# Plot
sim1 = ggplot(data = df, aes(y = reorder(type, i),  x = importance, fill = reorder(feature, i))) +
  geom_col(position = position_dodge()) +
  labs(y = "method",
       fill = "feature") + 
  scale_fill_brewer(palette = "Set1", breaks = c("x1", "x2", "x3"), 
                    labels = c(expression(X[1]), expression(X[2]), expression(X[3])))

sim1

# Save plot
ggsave(filename = "./simulations/plots/sim1.pdf")