yeast <- read.table("~/Desktop/yeast.dat")

yeast <- yeast[, -1]
yeast$V10 <- as.numeric(as.factor(yeast$V10))
colnames(yeast) <- paste0("V",1:9)

write.table(yeast, '~/Desktop/yeast.txt', row.names = F, col.names = F)