# Load necessary libraries
library(tidyverse)

# Create example data
data <- read.csv("DNAm_age2_300.csv")
colnames(data) <- c('group', 'age', 'adj_DNAm_age', 'adj_RE')

# Reshape data to long format
long_data <- data %>%
  gather(key = "Age_type", value = "Value", age, adj_DNAm_age) %>%
  unite(Group, group, Age_type, sep = "_") %>%
  mutate(Group = factor(Group, levels = c("0-II_age", "0-II_adj_DNAm_age", "III-IV_age", "III-IV_adj_DNAm_age", "V-VI_age", "V-VI_adj_DNAm_age")))

# Create a data frame for the "N=" labels
n_labels <- long_data %>%
  group_by(Group) %>%
  summarize(count = n()) %>%
  mutate(text = paste("N =", count))

# Calculate mean relative error (MRE) for each group
mre_data <- data %>%
  gather(key = "Age_type", value = "Value", age, adj_DNAm_age) %>%
  gather(key = "RE_type", value = "RE_value", adj_RE) %>%
  unite(Group, group, Age_type, sep = "_") %>%
  group_by(Group) %>%
  summarize(MRE = mean(RE_value))

# Define custom colors
custom_colors <- c("0-II_age" = "green", "0-II_adj_DNAm_age" = "lightgreen",
                   "III-IV_age" = "yellow", "III-IV_adj_DNAm_age" = "lightyellow",
                   "V-VI_age" = "darkred", "V-VI_adj_DNAm_age" = "red")

# Create a whisker plot (box plot) using ggplot2
age_whisker_plot <- ggplot(long_data, aes(x = Group, y = Value, fill = Group)) +
  geom_boxplot() +
  geom_text(data = n_labels, aes(x = Group, y = Inf, label = text), vjust = 2) +
  geom_text(data = mre_data, aes(x = Group, y = -Inf, label = paste("MRE:", round(MRE, 2))), vjust = -1.5) +
  theme_minimal() +
  labs(title = "Age and Adj. DNAm Age Distribution among Groups",
       x = "Group",
       y = "Age Value",
       fill = "Group") +
  scale_fill_manual(values = custom_colors)

# Display the plot
print(age_whisker_plot)

# Statistical Analysis
# Perform ANOVA to compare groups
result.aov <- aov(Value ~ Group, data = long_data)
summary(result.aov)

# TukeyHSD test for pairwise comparisons
tukey_result <- TukeyHSD(result.aov, "Group")
print(tukey_result)

# Calculate statistical summaries for original data subsets
summarize_subset <- function(df, group_name) {
  df %>% 
    filter(group == group_name) %>% 
    summarise(num_samples = n(),
              avg_age = mean(age, na.rm = TRUE),
              median_age = median(age, na.rm = TRUE),
              std_dev_age = sd(age, na.rm = TRUE),
              avg_adj_DNAm_age = mean(adj_DNAm_age, na.rm = TRUE),
              median_adj_DNAm_age = median(adj_DNAm_age, na.rm = TRUE),
              std_dev_adj_DNAm_age = sd(adj_DNAm_age, na.rm = TRUE))
}


# Generate statistical summary for each group
summary_mild <- summarize_subset(data, "0-II")
summary_int <- summarize_subset(data, "III-IV")
summary_adv <- summarize_subset(data, "V-VI")

# Combine the summaries into a single data frame
group_summary <- bind_rows(summary_mild, summary_int, summary_adv)

# Display the summary data frame
print(group_summary)

# Convert TukeyHSD results to a data frame & Write the data frame to a CSV file
tukey_df <- as.data.frame(tukey_result$Group)  # Assuming 'Group' is the factor used in ANOVA
# write.csv(tukey_df, "anova_HSD_braak.csv", row.names = TRUE)