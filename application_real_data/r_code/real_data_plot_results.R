library(ggplot2)
library(dplyr)
library(scales)
library(forcats)
library(patchwork)

theme_set(theme_bw(base_size = 18))


# load dataset
df_pfi_cfi = read.csv("./application_real_data/data/df_res_pfi_cfi.csv")
df_loco_loci = read.csv("./application_real_data/data/df_res_loco_loci.csv")

df = rbind(df_pfi_cfi, df_loco_loci)
df$feature = as.factor(df$feature)


# Plot
real_data = ggplot(data = df, aes(x = importance, y = feature)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = comma) +
  facet_wrap(~type)
#real_data

pfi_plot = df %>% 
  filter(type == "PFI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "PFI",
    y = "features"
  )
pfi_plot

cfi_plot = df %>% 
  filter(type == "CFI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "CFI",
    y = "features"
  )
cfi_plot

loco_plot = df %>% 
  filter(type == "LOCO") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "LOCO",
    y = "features"
  )
loco_plot

loci_plot = df %>% 
  filter(type == "LOCI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "LOCI",
    y = "features"
  )
loci_plot

plot_all = (pfi_plot + cfi_plot) / (loci_plot + loco_plot)
plot_all
