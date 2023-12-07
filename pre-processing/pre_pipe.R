library(tidyverse)

bval_all <- read.csv("bval_all.csv")
bval_all <- na.omit(bval_all)

df2 <- mutate_all(bval_all, function(x) as.numeric(as.character(x)))
df2 <- df2[,-1]

rownames(bval_all) <- bval_all[,1]
bval_all <- bval_all[,-1]


logitt <- function(p) {  log(p/(1-p)) }
mval_all <- logitt(bval_all)

write.csv(bval_all,"bval_all.csv")
write.csv(mval_all,"mval_all.csv")

write.csv(mval_all[,-1],"mval_all.csv")

probe_ID <- as.data.frame(rownames(bval_all))
write.csv(probe_ID,"probe_ID.csv")

# set a seed and cluster the m-vales for the new estimation
# we assume her 3 clusters, which might be subject of change/discussion later
# create a csv that contains the file name and appropriate cluster
set.seed(20)
clusters <- as.data.frame(colnames(mval_all))
clusters$cluster <- kmeans(t(mval_all),3,iter.max=10000)$cluster

# write up a function to do the within sum of squares needed for clustering
wssplot <- function(f1, nc=5, seed=1234){
  wss <- (nrow(f1)-1)*sum(apply(f1,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(f1, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
  wss
}

wssplot(mval_all, nc=10)
