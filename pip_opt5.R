library(tidyverse)

new_best <- 2
num_sim <- 10000
counter <- 1

# bval_all <- read_csv("bval_all.csv")
mval_all <- read_csv("mval_all.csv")

while (counter != 0) {
  y <- 1
  counter <- num_sim

  while (y < (num_sim + 1)) {
    ex <- paste("e", y, sep = "")
    print(paste("trial ", ex, " counter ", counter, sep = ""))

    em_see <- read.csv("em_see.csv")
    em_see <- em_see[,-1]
    nprobes <- nrow(em_see)
    num_e0_probes <- sum(em_see$e0)

    set.seed(floor(runif(1, min = 0, max = (y * 10))))
    neg_probes <- floor(runif(1, min = 0, max = (num_e0_probes / 2)))
    pos_probes <- floor(runif(1, min = 0, max = (min((num_e0_probes / 3), (nprobes - num_e0_probes)))))
    em_see$new <- em_see$e0

    while (pos_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 0) {
        em_see$new[x] <- 1
        pos_probes <- pos_probes - 1
      }
    }

    while (neg_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 1) {
        em_see$new[x] <- 0
        neg_probes <- neg_probes - 1
      }
    }

    new <- cbind(em_see$master_list, em_see$new)
    new[new == 0] <- NA
    new <- na.omit(new)
    new <- as.data.frame(new[,1])
    colnames(new) <- "Name"

    bx <- merge(x = new, y = bval_all, by.x = "Name", by.y = "...1")
    mx <- merge(x = new, y = mval_all, by.x = "Name", by.y = "...1")

    rownames(mx) <- mx[,1]
    mx <- mx[,-1]

    set.seed(20)
    clusters <- as.data.frame(colnames(mx))
    clusters$cluster <- kmeans(t(mx), 3, iter.max = 10000)$cluster
    colnames(clusters) <- c("sample", "cluster")

    ref <- read.csv("n2.csv")
    notes <- merge(x = ref, y = clusters, by.x = "sample", by.y = "sample")

    mxcl1 <- filter(notes, cluster == 1)
    mxcl2 <- filter(notes, cluster == 2)
    mxcl3 <- filter(notes, cluster == 3)

    nx <- c(0, 0, 0)
    nx <- data.frame(nx)
    rownames(nx) <- c("cl1_A", "cl2_B", "cl3_C")

    nx[1,1] <- nrow(mxcl1)
    nx[2,1] <- nrow(mxcl2)
    nx[3,1] <- nrow(mxcl3)

    nx[1,2] <- nrow(mxcl1[mxcl1$group == "A", ])
    nx[2,2] <- nrow(mxcl2[mxcl2$group == "B", ])
    nx[3,2] <- nrow(mxcl3[mxcl3$group == "C", ])

    nx[1,3] <- (nx[1,2] + (nx[1,2] - nx[1,1])) / 23
    nx[2,3] <- (nx[2,2] + (nx[2,2] - nx[2,1])) / 16
    nx[3,3] <- (nx[3,2] + (nx[3,2] - nx[3,1])) / 56

    colnames(nx) <- c("samples", "count", "score")

    nx_best <- read.csv("nx_best.csv")

    if ( round(sum(nx$score), digits = 5) > round(sum(nx_best$score), digits = 5) ) {
      write.csv(nx, "nx_best.csv")
      print(paste(ex, " is best, more accurate", sep = ""))
      new_best <- 1
      # save.image(file = "my_environment.RData")
    } else {
      new_best <- 0
    }

    if (new_best == 1) {
      em_see2 <- em_see[, -2]
      colnames(em_see2) <- c("master_list", "e0")
      write.csv(em_see2, "em_see.csv")
    } else {
      counter <- counter - 1
    }

    y <- y + 1
}}

print("second phase, reintegration of probes")

new_best <- 2
num_sim <- 10000
counter <- 1

while (counter != 0) {
  y <- 1
  counter <- num_sim

  while (y < (num_sim + 1)) {
    ex <- paste("e", y, sep = "")
    print(paste("second pahse, trial ", ex, " counter ", counter, sep = ""))

    em_see <- read.csv("em_see.csv")
    em_see <- em_see[,-1]
    nprobes <- nrow(em_see)
    num_e0_probes <- sum(em_see$e0)

    set.seed(floor(runif(1, min = 0, max = (y * 10))))
    neg_probes <- floor(runif(1, min = 0, max = (num_e0_probes / 3)))
    pos_probes <- floor(runif(1, min = 0, max = (min((num_e0_probes / 2), (nprobes - num_e0_probes)))))
    em_see$new <- em_see$e0

    while (pos_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 0) {
        em_see$new[x] <- 1
        pos_probes <- pos_probes - 1
      }
    }

    while (neg_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 1) {
        em_see$new[x] <- 0
        neg_probes <- neg_probes - 1
      }
    }

    new <- cbind(em_see$master_list, em_see$new)
    new[new == 0] <- NA
    new <- na.omit(new)
    new <- as.data.frame(new[,1])
    colnames(new) <- "Name"

    bx <- merge(x = new, y = bval_all, by.x = "Name", by.y = "...1")
    mx <- merge(x = new, y = mval_all, by.x = "Name", by.y = "...1")

    rownames(mx) <- mx[,1]
    mx <- mx[,-1]

    set.seed(20)
    clusters <- as.data.frame(colnames(mx))
    clusters$cluster <- kmeans(t(mx), 3, iter.max = 10000)$cluster
    colnames(clusters) <- c("sample", "cluster")

    ref <- read.csv("n2.csv")
    notes <- merge(x = ref, y = clusters, by.x = "sample", by.y = "sample")

    mxcl1 <- filter(notes, cluster == 1)
    mxcl2 <- filter(notes, cluster == 2)
    mxcl3 <- filter(notes, cluster == 3)

    nx <- c(0, 0, 0)
    nx <- data.frame(nx)
    rownames(nx) <- c("cl1_A", "cl2_B", "cl3_C")

    nx[1,1] <- nrow(mxcl1)
    nx[2,1] <- nrow(mxcl2)
    nx[3,1] <- nrow(mxcl3)

    nx[1,2] <- nrow(mxcl1[mxcl1$group == "A", ])
    nx[2,2] <- nrow(mxcl2[mxcl2$group == "B", ])
    nx[3,2] <- nrow(mxcl3[mxcl3$group == "C", ])

    nx[1,3] <- (nx[1,2] + (nx[1,2] - nx[1,1])) / 23
    nx[2,3] <- (nx[2,2] + (nx[2,2] - nx[2,1])) / 16
    nx[3,3] <- (nx[3,2] + (nx[3,2] - nx[3,1])) / 56

    colnames(nx) <- c("samples", "count", "score")

    nx_best <- read.csv("nx_best.csv")

    if (round(sum(nx$score), digits = 5) > round(sum(nx_best$score), digits = 5)) {
      write.csv(nx, "nx_best.csv")
      print(paste(ex, " is more accurate", sep = ""))
      new_best <- 1
    } else if (round(sum(nx$score), digits = 5) >= round(sum(nx_best$score), digits = 5) && nrow(new) < num_e0_probes) {
      write.csv(nx, "nx_best.csv")
      print(paste(ex, " is less probes", sep = ""))
      new_best <- 1
    } else {
      new_best <- 0
    }

    if (new_best == 1) {
      em_see2 <- em_see[, -2]
      colnames(em_see2) <- c("master_list", "e0")
      write.csv(em_see2, "em_see.csv")
    } else {
      counter <- counter - 1
    }

    y <- y + 1
  }}

print("third phase, reintegration of probes")

new_best <- 2
num_sim <- 10000
counter <- 1

while (counter != 0) {
  y <- 1
  counter <- num_sim
  
  while (y < (num_sim + 1)) {
    ex <- paste("e", y, sep = "")
    print(paste("third pahse, trial ", ex, " counter ", counter, sep = ""))
    
    em_see <- read.csv("em_see.csv")
    em_see <- em_see[,-1]
    nprobes <- nrow(em_see)
    num_e0_probes <- sum(em_see$e0)
    
    set.seed(floor(runif(1, min = 0, max = (y * 10))))
    neg_probes <- floor(runif(1, min = 0, max = (num_e0_probes / 3)))
    pos_probes <- floor(runif(1, min = 0, max = (min((num_e0_probes / 2), (nprobes - num_e0_probes)))))
    em_see$new <- em_see$e0
    
    while (pos_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 0) {
        em_see$new[x] <- 1
        pos_probes <- pos_probes - 1
      }
    }
    
    while (neg_probes > 0) {
      x <- floor(runif(1, min = 1, max = (nprobes + 1)))
      if (em_see$new[x] == 1) {
        em_see$new[x] <- 0
        neg_probes <- neg_probes - 1
      }
    }
    
    new <- cbind(em_see$master_list, em_see$new)
    new[new == 0] <- NA
    new <- na.omit(new)
    new <- as.data.frame(new[,1])
    colnames(new) <- "Name"
    
    bx <- merge(x = new, y = bval_all, by.x = "Name", by.y = "...1")
    mx <- merge(x = new, y = mval_all, by.x = "Name", by.y = "...1")
    
    rownames(mx) <- mx[,1]
    mx <- mx[,-1]
    
    set.seed(20)
    clusters <- as.data.frame(colnames(mx))
    clusters$cluster <- kmeans(t(mx), 3, iter.max = 10000)$cluster
    colnames(clusters) <- c("sample", "cluster")
    
    ref <- read.csv("n2.csv")
    notes <- merge(x = ref, y = clusters, by.x = "sample", by.y = "sample")
    
    mxcl1 <- filter(notes, cluster == 1)
    mxcl2 <- filter(notes, cluster == 2)
    mxcl3 <- filter(notes, cluster == 3)
    
    nx <- c(0, 0, 0)
    nx <- data.frame(nx)
    rownames(nx) <- c("cl1_A", "cl2_B", "cl3_C")
    
    nx[1,1] <- nrow(mxcl1)
    nx[2,1] <- nrow(mxcl2)
    nx[3,1] <- nrow(mxcl3)
    
    nx[1,2] <- nrow(mxcl1[mxcl1$group == "A", ])
    nx[2,2] <- nrow(mxcl2[mxcl2$group == "B", ])
    nx[3,2] <- nrow(mxcl3[mxcl3$group == "C", ])
    
    nx[1,3] <- (nx[1,2] + (nx[1,2] - nx[1,1])) / 23
    nx[2,3] <- (nx[2,2] + (nx[2,2] - nx[2,1])) / 16
    nx[3,3] <- (nx[3,2] + (nx[3,2] - nx[3,1])) / 56
    
    colnames(nx) <- c("samples", "count", "score")
    
    nx_best <- read.csv("nx_best.csv")
    
    if (round(sum(nx$score), digits = 5) > round(sum(nx_best$score), digits = 5)) {
      write.csv(nx, "nx_best.csv")
      print(paste(ex, " is more accurate", sep = ""))
      new_best <- 1
    } else if (round(sum(nx$score), digits = 5) >= round(sum(nx_best$score), digits = 5) && nrow(new) > num_e0_probes) {
      write.csv(nx, "nx_best.csv")
      print(paste(ex, " is more probes", sep = ""))
      new_best <- 1
    } else {
      new_best <- 0
    }
    
    if (new_best == 1) {
      em_see2 <- em_see[, -2]
      colnames(em_see2) <- c("master_list", "e0")
      write.csv(em_see2, "em_see.csv")
    } else {
      counter <- counter - 1
    }
    
    y <- y + 1
  }}