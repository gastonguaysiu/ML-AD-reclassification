
# R script for chi-squared test on 6 experimental groups and 1 control group

# Read the CSV file and convert it to a matrix
observed_counts <- read.csv("Relation_to_UCSC_CpG_Island.csv")
rownames(observed_counts) <- observed_counts[,1]
observed_counts <- observed_counts[,-1]
observed_counts <- as.matrix(observed_counts)

# Perform the chi-squared test for each experimental group compared to the control group
control_group <- 1 # Assuming the control group is the 1st group

# Initialize a data frame to store the results
results <- data.frame(Group = character(),
                      X_squared = numeric(),
                      df = integer(),
                      p_value = numeric(),
                      stringsAsFactors = FALSE)

for (exp_group in (control_group + 1):nrow(observed_counts)) {
  comparison_matrix <- observed_counts[c(control_group, exp_group),]
  chi_squared_test <- chisq.test(comparison_matrix)
  cat(sprintf("Chi-squared test for Group %d compared to Control Group:\n", exp_group))
  print(chi_squared_test)
  cat("\n")
  
  # Save the results to the data frame
  results <- rbind(results, data.frame(Group = rownames(observed_counts)[exp_group],
                                       X_squared = chi_squared_test$statistic,
                                       df = chi_squared_test$parameter,
                                       p_value = chi_squared_test$p.value))
}

# Save the results to a CSV file
write.csv(results, "chi_squared_test_results.csv", row.names = FALSE)





# # Perform the chi-squared test
# chi_squared_test <- chisq.test(observed_counts)
# 
# # Print the results
# print(chi_squared_test)


# R script for chi-squared test on one observation in six experimental groups and one control group

# Read the data from CSV file
data <- read.csv("DHS.csv", row.names = 1)

# Extract the observed counts and group names
observed_counts <- data[, 1]
group_names <- rownames(data)

# Create a data frame to store the results
results <- data.frame(Group = character(),
                      X_squared = numeric(),
                      df = integer(),
                      p_value = numeric(),
                      stringsAsFactors = FALSE)

# Perform the chi-squared test for each experimental group compared to the control group
for (i in 2:length(group_names)) {
  control_group <- observed_counts[1]  # Control group count
  comparison_counts <- c(control_group, observed_counts[i])
  
  chi_squared_test_group <- chisq.test(comparison_counts)
  
  cat(sprintf("\nChi-squared test for %s compared to Control Group:\n", group_names[i]))
  print(chi_squared_test_group)
  
  # Save the results to the data frame
  results <- rbind(results, data.frame(Group = group_names[i],
                                       X_squared = chi_squared_test_group$statistic,
                                       df = chi_squared_test_group$parameter,
                                       p_value = chi_squared_test_group$p.value))
}

# Save the results to a CSV file
write.csv(results, "chi_squared_test_results.csv", row.names = FALSE)

