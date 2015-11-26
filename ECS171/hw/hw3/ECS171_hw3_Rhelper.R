gene <- scan("ecs171.dataset.txt", what = '')
pattern <- grep("T[0-9]{3}", gene)
gene_index_start <- c(1, pattern)
gene_index_end <- c(pattern - 1, length(gene))
row_num <- length(gene_index_start)
col_num <- gene_index_end[1] - gene_index_start[1] + 1

gene_data_raw <- Map(function(i, j) gene[i:j], gene_index_start, gene_index_end)

colname <- gene_data_raw[[1]]

invisible(lapply(1:row_num, function(i) {
  if (length(gene_data_raw[[i]]) != col_num) gene_data_raw[[i]] <<- c(gene_data_raw[[i]], 0)
}))

gene_data <- data.frame(do.call('rbind', gene_data_raw), stringsAsFactors = FALSE)

gene_data <- gene_data[-1, ]
colnames(gene_data) <- colname

gene_data <- gene_data[, -length(gene_data)]

Medium_Stress <- unlist(Map(paste, gene_data$Medium, gene_data$Stress, sep = '.'))
gene_data[, 1] <- Medium_Stress
names(gene_data)[1] <- 'Medium_Stress'
gene_data$Medium_Stress <- as.numeric(as.factor(gene_data$Medium_Stress))

invisible(lapply(2:5, function(i) {
  gene_data[[i]] <<- as.numeric(as.factor(gene_data[[i]]))
}))

write.csv(gene_data, "~/Desktop/gene_data.csv", row.names = F)