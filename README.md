# ML-AD-reclassification
ML-alzheimer's disease reclassification using k-means and EM

This pre_pie.R script is designed for processing DNA methylation data. Methylation data is often converted from beta values to M values for statistical analysis. M values are the logit transformation of the beta values and provide a more statistically robust framework for differential analysis. The script then prepares for k-means clustering by extracting the probe IDs from the original dataset and saving them. In k-means clustering, the 'elbow method' is a heuristic used to determine the number of clusters. The elbow graph plots the WSS against the number of clusters, and the 'elbow' point – where the rate of decrease sharply changes – suggests the appropriate number of clusters. A function is called to create this plot for up to 10 clusters. The script involves several steps denoted below.



