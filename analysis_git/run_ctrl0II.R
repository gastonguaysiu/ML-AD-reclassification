library(tidyverse)

wssplot <- function(f1, nc=5, seed=1234){
  wss <- (nrow(f1)-1)*sum(apply(f1,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(f1, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
  wss
}

em_see <- read.csv("em_see.csv")
em_see <- em_see[,-1]
em_see[em_see == 0] <- NA
new <- na.omit(em_see)
new <- as.data.frame(new[,1])
colnames(new) <- "Name"

# bval_all <- read_csv("bval_all.csv")
mval_all <- read_csv("mval_all.csv")
probe_list <- as.data.frame(mval_all$"...1")

# bx <- merge(x = new, y = bval_all, by.x = "Name", by.y = "...1")
mx <- merge(x = new, y = mval_all, by.x = "Name", by.y = "...1")

rownames(mx) <- mx[,1]
mx <- mx[,-1]

# pdf("elbow1.pdf")
# wssplot(mx, nc=10)
# dev.off()

set.seed(20)
clusters <- as.data.frame(colnames(mx))
clusters$cluster <- kmeans(t(mx), 3, iter.max = 10000)$cluster
colnames(clusters) <- c("sample", "cluster")

ref <- read.csv("n2.csv")
notes <- inner_join(ref, clusters, by = "sample")

cluster1 <- notes %>% filter(cluster == 1)
cluster2 <- notes %>% filter(cluster == 2)
cluster3 <- notes %>% filter(cluster == 3)

###################   stats.R   ######################
print("pre-processing and loading up mx_current...")

mx_t <- as.data.frame(lapply(data.frame(t(mval_all), stringsAsFactors = FALSE), as.numeric))
mx_t <- mx_t[-1,]
colnames(mx_t) <- t(probe_list)
temp <- as.data.frame(colnames(mval_all[,-1]))
colnames(temp) <- "sample"
mx_t <- cbind(temp, mx_t)

# Function to process clusters
build_df <- function(cluster_samples) {
  cluster_df <- merge(x = cluster_samples, y = mx_t, by = "sample")
  rownames(cluster_df) <- cluster_df$sample
  return(as.data.frame(t(cluster_df[-1])))
}

# Separating information into data frames to later get statistical info (pre-processing)
print("building a data frame for normal + each cluster")

normalB <- build_df(data.frame(sample = cluster1$sample))
cluster2B <- build_df(data.frame(sample = cluster2$sample))
cluster3B <- build_df(data.frame(sample = cluster3$sample))

# Function to calculate row variance
rowVars <- function(x, na.rm = F) {
  rowSums((x - rowMeans(x, na.rm = na.rm))^2, na.rm = na.rm) / (ncol(x) - 1)
}

# Function to perform Kolmogorov–Smirnov test of two samples (cluster vs norm) and update summary
update_summary <- function(summary, norm_data, cluster_data, cluster_name) {
  summary[[paste0(cluster_name, "_avg")]] <- rowMeans(cluster_data)
  summary[[paste0(cluster_name, "_std")]] <- sqrt(rowVars(cluster_data))
  
  pval_col_name <- paste0("pval_norm_vs_", cluster_name)
  summary[[pval_col_name]] <- sapply(1:nrow(norm_data), function(i) {
    ks.test(as.numeric(norm_data[i, ]), as.numeric(cluster_data[i, ]))$p
  })
  
  summary[[paste0("padj_norm_vs_", cluster_name)]] <- p.adjust(summary[[pval_col_name]], method = "BH")
  
  return(summary)
}

# Getting stats for norm + clusters
print("getting stats for norm + clusters...")

summary <- data.frame(norm_avg = rowMeans(normalB))
summary$norm_std <- sqrt(rowVars(normalB))

# Update summary for each cluster
cluster_names <- c("c2", "c3")
cluster_data_list <- list(cluster2B, cluster3B)

for (i in seq_along(cluster_names)) {
  summary <- update_summary(summary, normalB, cluster_data_list[[i]], cluster_names[i])
}

# write.csv(summary, "stat_mval_sum.csv")

###################   sig_probe   ######################

for (i in 2:3) {
  cluster_name <- paste0("c", i)
  probes_data <- data.frame(diff = summary[[paste0(cluster_name, "_avg")]] - summary$norm_avg,
                            padj = summary[[paste0("padj_norm_vs_", cluster_name)]])
  row.names(probes_data) <- row.names(summary) # Add row names from summary data frame
  assign(paste0("probes_cl", i), probes_data)
}

std_diff <- max(sd(probes_cl2$diff), sd(probes_cl3$diff))

get_sig_probes <- function(cluster, threshold = 0.01) {
  cluster[(cluster$diff > std_diff | cluster$diff < -std_diff) & cluster$padj < threshold,]
}

# Get significant probes
cl2B <- get_sig_probes(probes_cl2)
cl3B <- get_sig_probes(probes_cl3)

cl2B$probes <- rownames(cl2B)
cl3B$probes <- rownames(cl3B)

######  sumarize into data frames  ######

# Read manifest file
manifest <- read_csv("headless.csv")

process_cluster <- function(cluster_data, manifest) {
  cl_temp <- merge(x = cluster_data, y = manifest, by.x = "probes", by.y = "IlmnID", all = FALSE)
  cl_genes <- cl_temp %>%
    separate_rows(UCSC_RefGene_Name, sep = ";")
  unique_cl_genes <- cl_genes %>%
    distinct(UCSC_RefGene_Name, .keep_all = TRUE)
  unique_cl_genes <- unique_cl_genes[,c("probes", "diff", "padj", "UCSC_RefGene_Name")]
  colnames(unique_cl_genes) <- c("probes", "diff", "padj", "gene")
  return(unique_cl_genes)
}

cl2_probes_genes <- process_cluster(cl2B, manifest)
cl3_probes_genes <- process_cluster(cl3B, manifest)

sig_probes <- unique(c(cl2_probes_genes$probes, cl3_probes_genes$probes))
sig_probes <- as.data.frame(sig_probes)
colnames(sig_probes) <- "probes"

cl2_genes <- unique(as.data.frame(cl2_probes_genes$gene))
cl3_genes <- unique(as.data.frame(cl3_probes_genes$gene))
colnames(cl2_genes) <- colnames(cl3_genes) <- "gene"

######################    building simp heatmap data    ######################

get_cluster_means <- function(cluster_data) {
  rowMeans(cluster_data)
}

simp_heat <- data.frame(normal_avg = get_cluster_means(normalB),
                        cl2_avg = get_cluster_means(cluster2B),
                        cl3_avg = get_cluster_means(cluster3B))

simp_heat$temp <- rownames(simp_heat)
simp_heat2 <- merge(x=sig_probes, y=simp_heat, by.x="probes", by.y="temp", all = FALSE)
rownames(simp_heat2) <- simp_heat2[,1]
simp_heat2 <- simp_heat2[,-1]

notes2 <- notes[order(notes$cluster),]

# write.csv(notes,"notes.csv")
# write.csv(notes2, "notes2.csv")
# write.csv(simp_heat,"simp_heat.csv")
# write.csv(simp_heat2,"simp_heat2.csv")

######  print out the csv  ######

# write.csv(cl2_genes,"cl2_genes.csv", row.names = FALSE)
# write.csv(cl3_genes,"cl3_genes.csv", row.names = FALSE)

AD_genes <- read.csv("ncbi_AD_genes.csv")

cl2_AD <- inner_join(AD_genes, cl2_genes, by = c("Symbol" = "gene"))
cl3_AD <- inner_join(AD_genes, cl3_genes, by = c("Symbol" = "gene"))

cl2_AD <- as.data.frame(cl2_AD$Symbol)
cl3_AD <- as.data.frame(cl3_AD$Symbol)


######  hyp probes  ######

cl2_hyper <- subset(cl2_probes_genes, diff > 0)
cl2_hyper <- unique(cl2_hyper[,1:3])

cl3_hyper <- subset(cl3_probes_genes, diff > 0)
cl3_hyper <- unique(cl3_hyper[,1:3])

cl2_hypo <- subset(cl2_probes_genes, diff < 0)
cl2_hypo <- unique(cl2_hypo[,1:3])

cl3_hypo <- subset(cl3_probes_genes, diff < 0)
cl3_hypo <- unique(cl3_hypo[,1:3])


######  feature isolation  ######

alx <- as.data.frame(rownames(summary))
colnames(alx) <- "probes"

isolate_feature <- function(cluster_data, manifest) {
  cl_temp <- merge(x = cluster_data, y = manifest, by.x = "probes", by.y = "IlmnID", all = FALSE)
  # Extract genomic features
  genomic_features <- cl_temp[, c("probes", "Next_Base", "Genome_Build", "CHR", "MAPINFO", "Strand", "Probe_SNPs", "Probe_SNPs_10", "UCSC_RefGene_Name", "UCSC_RefGene_Group", 
                                  "UCSC_CpG_Islands_Name", "Relation_to_UCSC_CpG_Island", "DMR", "Enhancer", "Regulatory_Feature_Name", "Regulatory_Feature_Group", "DHS")]
  return(genomic_features)
}

# isolate each cluster using the function
alx_feat <- isolate_feature(alx, manifest)
sig_feat <-isolate_feature(sig_probes, manifest)
cl2_hypo_feat <- isolate_feature(cl2_hypo, manifest)
cl2_hyper_feat <- isolate_feature(cl2_hyper, manifest)
cl3_hypo_feat <- isolate_feature(cl3_hypo, manifest)
cl3_hyper_feat <- isolate_feature(cl3_hyper, manifest)


# Define the row and column names
row_names <- c("alx", "cl2_hyper", "cl2_hypo", "cl3_hyper", "cl3_hypo")
column_names <- c("S_Shore", "S_Shelf", "N_Shore", "N_Shelf", "Island")

# Create an empty data frame
data <- data.frame(matrix(ncol = length(column_names), nrow = length(row_names)))
names(data) <- column_names
row.names(data) <- row_names

# Fill in the data frame
for (row_name in row_names) {
  # Get the data for this row (replace this with your actual data)
  df_row <- get(paste(row_name, "_feat", sep = ""))
  
  for (column_name in column_names) {
    # Count the number of rows with the given value
    temp <- df_row %>% filter(grepl(column_name, Relation_to_UCSC_CpG_Island))
    data[row_name, column_name] <- nrow(temp)
  }
}

# Print the data
# write.csv(data,"temp.csv")

for (row_name in row_names) {
  # Get the data frame associated with this row name
  df <- get(paste0(row_name, "_feat"))
  
  # Count the number of rows where enhancer is TRUE
  num_rows <- subset(df, DHS == "TRUE")
  
  # Print the result
  print(nrow(num_rows))
}

save.image("my_workspace.RData")
load("my_workspace.RData")

