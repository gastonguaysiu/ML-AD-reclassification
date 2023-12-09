library(tidyverse)

cl2_GO <- read.csv("cl2_GO.csv")
cl3_GO <- read.csv("cl3_GO.csv")
AD_GO <- read.csv("AD_GO.csv")

# Perform the inner join
cl2_AD <- inner_join(cl2_GO, AD_GO, by = c("X" = "X"))
cl3_AD <- inner_join(cl3_GO, AD_GO, by = c("X" = "X"))

cl2_AD2 <- cl2_AD[,1:11]
colnames(cl2_AD2) <- colnames(AD_GO)

cl3_AD2 <- cl3_AD[,1:11]
colnames(cl3_AD2) <- colnames(AD_GO)

cl2_cl3 <- inner_join(cl2_AD2, cl3_AD2, by = c("X" = "X"))

nx <- c(0, 0)
nx <- data.frame(nx)
rownames(nx) <- c("p_adj", "count")

nx[1,1] <- median(cl2_AD$p.adjust.x)
nx[2,1] <- median(cl2_AD$Count.x)
nx[1,2] <- median(cl2_AD$p.adjust.y)
nx[2,2] <- median(cl2_AD$Count.y)

nx[1,3] <- median(cl3_AD$p.adjust.x)
nx[2,3] <- median(cl3_AD$Count.x)
nx[1,4] <- median(cl3_AD$p.adjust.y)
nx[2,4] <- median(cl3_AD$Count.y)

nx[1,5] <- median(cl2_cl3$p.adjust.x)
nx[2,5] <- median(cl2_cl3$Count.x)
nx[1,6] <- median(cl2_cl3$p.adjust.y)
nx[2,6] <- median(cl2_cl3$Count.y)

colnames(nx) <- c("cl2", "AD", "cl3", "AD", "cl2_inner", "cl3_inner")

# write.csv(nx,"GO_analysis.csv", row.names = FALSE)
