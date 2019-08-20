

# pull in args
args	<- 	commandArgs(trailingOnly = TRUE)
outcome_ID 	<- 	toString(args[1]) #Outcome of interest



setwd("/newhome/hw15842/PhD/CCR5/Finemapping")

install.packages("devtools", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')
install.packages("plyr", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')
install.packages("data.table", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')

library (devtools)
library(plyr)
library(data.table)


file1 <- paste("blood",outcome_ID,"chr3_46Mto47M.txt", sep="_")

outcome_nonmrbase <- read.table(file1, header=TRUE)


chr03_positions <- read.table("chr03_46Mto47M.txt", header=T)

chr03_positions_filtered <- chr03_positions[!(chr03_positions$minor_allele_frequency<=0.001 & chr03_positions$impute_info<=0.8),]

ref_snp <- grep("rs113010081", chr03_positions)

chr03_positions_filtered <- rbind(chr03_positions_filtered, ref_snp)


chr03_positions_filtered_rsids <- chr03_positions_filtered$rsid

chr03_positions_filtered_rsids <- data.frame(chr03_positions_filtered_rsids)

names(chr03_positions_filtered_rsids)[1] <- "SNP"



head(chr03_positions_filtered_rsids)

head(outcome_nonmrbase)



outcome_nonmrbase_filtered <- merge(outcome_nonmrbase, chr03_positions_filtered_rsids, by="SNP")


file2 <- paste("blood",outcome_ID,"outcome_data_finemapping_with_proxy.txt", sep="_")


write.table(outcome_nonmrbase_filtered, file=file2, quote=F, row.names=F, sep="\t")





