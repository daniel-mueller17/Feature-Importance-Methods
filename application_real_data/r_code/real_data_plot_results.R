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
df$importance = df$importance / 100000


# Plot
real_data = df %>% 
  group_by(type) %>% 
  slice_max(importance, n = 6) %>% 
  ggplot(aes(x = importance, y = feature)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = comma) +
  facet_wrap(~type)
real_data

pfi_plot = df %>% 
  filter(type == "PFI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "PFI",
    y = "features",
    x = "importance in 100000"
  )
pfi_plot

cfi_plot = df %>% 
  filter(type == "CFI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "CFI",
    y = "features",
    x = "importance in 100000"
  )
cfi_plot

loco_plot = df %>% 
  filter(type == "LOCO") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "LOCO",
    y = "features",
    x = "importance in 100000"
  )
loco_plot

loci_plot = df %>% 
  filter(type == "LOCI") %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "LOCI",
    y = "features",
    x = "importance in 100000"
  )
loci_plot

plot_all = (pfi_plot + cfi_plot) / (loci_plot + loco_plot)
plot_all


# Plot only top 6
pfi_plot_6 = df %>% 
  filter(type == "PFI") %>% 
  slice_max(importance, n = 6) %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma, limits = c(0, 30)) +
  labs(
    title = "PFI",
    y = "features",
    x = "importance in 100k"
  ) +
  theme(axis.title.x = element_blank())
pfi_plot_6

cfi_plot_6 = df %>% 
  filter(type == "CFI") %>% 
  slice_max(importance, n = 6) %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma, limits = c(0, 30)) +
  labs(
    title = "CFI",
    y = "features",
    x = "importance in 100k"
  ) +
  theme(axis.title = element_blank())
cfi_plot_6

loco_plot_6 = df %>% 
  filter(type == "LOCO") %>% 
  slice_max(importance, n = 6) %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma, limits = c(0, 30)) +
  labs(
    title = "LOCO",
    y = "features",
    x = "importance in 100k"
  ) +
  theme(axis.title.y = element_blank())
loco_plot_6

loci_plot_6 = df %>% 
  filter(type == "LOCI") %>% 
  slice_max(importance, n = 6) %>% 
  ggplot(aes(x = importance, y = fct_reorder(feature, importance))) +
  geom_col(position = "identity", fill = "steelblue") +
  scale_x_continuous(labels = comma, limits = c(0, 30)) +
  labs(
    title = "LOCI",
    y = "features",
    x = "importance in 100k"
  )
loci_plot_6

plot_all_6 = (pfi_plot_6 + cfi_plot_6) / (loci_plot_6 + loco_plot_6)
plot_all_6


# save plots
ggsave("./application_real_data/plots/pfi_top6.pdf", plot = pfi_plot_6)
ggsave("./application_real_data/plots/cfi_top6.pdf", plot = cfi_plot_6)
ggsave("./application_real_data/plots/loco_top6.pdf", plot = loco_plot_6)
ggsave("./application_real_data/plots/loci_top6.pdf", plot = loci_plot_6)
ggsave("./application_real_data/plots/pfi_cfi_loco_loci_top6.pdf", plot = plot_all_6)
