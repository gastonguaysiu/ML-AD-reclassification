library(tidyverse)

print ("loading significant methylation data")

########### --- ###########

mval_all <- read.csv("mval_all.csv")
probes_list <- as.vector(mval_all[,1])
notes <- read.csv("notes.csv")
name_list <- as.vector(notes$sample)
mval_all <- mval_all %>% select(name_list)
rownames(mval_all) <- probes_list

islands <- as.vector(t(read.csv("island_probes.csv")))
mval <- mval_all[rownames(mval_all) %in% islands, ]

order_temp <- read.csv("notes2.csv")
order_temp <- order_temp[,-1]
order <- order_temp$sample

other <- mval[,order]

########### dev. ComplexHeatmap ###########

library(ComplexHeatmap)

mat <- as.matrix(other)

an <- order_temp[,8]
ha = HeatmapAnnotation(grouping = an)
Heatmap(mat, name = "m_value", show_row_names = FALSE, show_column_names = FALSE, col = topo.colors(10), top_annotation = ha)
Heatmap(mat, name = "m_value", show_row_names = FALSE, show_column_names = FALSE, cluster_columns = FALSE, col = topo.colors(10), top_annotation = ha)


########### dev. heatmap ###########

print ("building simp heatmap...")

simp <- read.csv("simp_heat.csv")
rownames(simp) <- as.list(t(simp[,1]))
simp <- simp[,-1]
simp2 <- simp
colnames(simp2) <- c("ML0-II", "MLIII-IV", "MLV-VI")

mat = as.matrix(simp2)
ha = HeatmapAnnotation(grouping = c(1, 2, 3))
Heatmap(mat, name = "m_value", show_row_names = FALSE, cluster_columns = FALSE, col = topo.colors(10), top_annotation = ha)

simp2 <- simp2[,c(1,2,3)]
heatmap(as.matrix(simp2), Colv = NA, col = topo.colors(10),
        main = "Average M value methylation score")


legend <- c("M < -3.7", "M ~ -2.8", "M ~ -1.8", "M ~ -0.9", "M ~ 0",
            "M ~ 0.9","M ~ 1.8", "M ~ 2.8", "M ~ 3.7", "M > 3.7")
pdf("legend.pdf")
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("center", legend=legend, fill= topo.colors(10))
dev.off()

