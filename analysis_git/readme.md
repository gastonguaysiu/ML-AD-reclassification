

The use of the run_ctrl0II.R focused on analyzing CpG sites and associated genes linked to methylomic-classified Alzheimer's disease (AD) patients. These CpG sites were significant in our adjusted p-value tests, indicating their potential role in varying levels of Alzheimer's severity. These AD subgroups corresponded to their unique methylation signatures and approximated Braak stages.

**Pseudo-Intermediate AD Cluster Analysis (cl2)**

In the cluster we've labelled as pseudo-intermediate AD (cl2), our analysis uncovered 2836 genes significantly associated with differentially methylated CpG sites. These genes were isolated using a threshold of an adjusted p-value < 0.01 and an average M-value difference greater than Zmax = z1. This comparison was made against a pseudo-control group, which served as our baseline for methylation levels.

**Pseudo-Advanced AD Cluster Analysis (cl3)**

Similarly, in the pseudo-advanced AD cluster (cl3), we identified 8737 significantly associated genes. This analysis also used the pseudo-control group as a reference.

**Comparison with Known AD Genes**

To determine the significance of these findings, we compared the isolated genes in both cl2 and cl3 with known AD-associated genes. Intriguingly, our pseudo-intermediate cluster (cl2) contained 247 of the 1554 recognized AD genes, while the pseudo-advanced cluster (cl3) included 738, as illustrated in Figure 2.

Our results showed that 15.89% of genes in cl2 and 46.85% in cl3 matched with known AD genes, bolstering the epigenetic progenitor model's assertion that epigenetic modifications can mirror genetic mutations. The identified differentially methylated CpG sites are potentially linked to gene dysregulation observed in AD progression, offering new perspectives in understanding the disease.

![pie_charts](https://github.com/gastonguaysiu/ML-AD-reclassification/blob/main/analysis_git/out_ML/enrichment/pie_genes.png?raw=true)

**Enrichment Analysis Using Gene Ontology (GO) Terms**

We extended our analysis to include an enrichment assessment with Gene Ontology (GO) terms. This revealed significant overlaps in enriched GO terms between our ML clusters and those known in AD, suggesting strong functional relationships among the isolated genes. These overlaps were characterized by lower average adjusted p-values and higher average gene counts per enriched GO term, indicating a close association with established Alzheimer's disease GO enrichments.

![GO_overlap](https://github.com/gastonguaysiu/ML-AD-reclassification/blob/main/analysis_git/out_ML/enrichment/GO_share.png?raw=true)

