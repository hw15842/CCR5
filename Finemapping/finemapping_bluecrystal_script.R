


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

install_github("MRCIEU/TwoSampleMR")

library(TwoSampleMR)

ao <- available_outcomes()


chr03_positions <- read.table("chr03_46Mto47M.txt", header=T)

ref_snp <- grep("rs113010081", chr03_positions)

chr03_positions_filtered <- chr03_positions[!(chr03_positions$minor_allele_frequency<=0.001 & chr03_positions$impute_info<=0.8),]

chr03_positions_filtered <- rbind(chr03_positions_filtered, ref_snp)

nrow(chr03_positions_filtered)

## Assign each line a random number between 1 and 9

random_numbers <- as.integer(runif(4453, 1, 10))

table(random_numbers)

## Add this as another column to the dataframe ##

chr03_positions_filtered <- cbind(chr03_positions_filtered, random_numbers)


## Use split function to seperte into 9 datasets

data_split <- split(chr03_positions_filtered, chr03_positions_filtered$random_numbers)




#a <- as.data.frame( chr03_positions_filtered[1:1000,])
#b <- as.data.frame( chr03_positions_filtered[1001:2000,])
#c <- as.data.frame( chr03_positions_filtered[2001:3000,])
#d <- as.data.frame( chr03_positions_filtered[3001:4000,])
#e <- as.data.frame( chr03_positions_filtered[4001:4453,])
#head(a)
#nrow(a)
#head(b)
#nrow(b)
#nrow(c)
#nrow(d)
#nrow(e)


outcome_snps <- function (rsid){
  extract_outcome_data( snps = rsid, outcomes =  outcome_ID, proxies=FALSE)
}





a<- lapply(data_split$`1`$rsid, outcome_snps)
 a<- ldply(a, data.frame)

b<- lapply(data_split$`2`$rsid, outcome_snps)
 b<- ldply(b, data.frame)

c<- lapply(data_split$`3`$rsid, outcome_snps)
 c<- ldply(c, data.frame)

d<- lapply(data_split$`4`$rsid, outcome_snps)
 d<- ldply(d, data.frame)

e<- lapply(data_split$`5`$rsid, outcome_snps)
 e<- ldply(e, data.frame)

f<- lapply(data_split$`6`$rsid, outcome_snps)
 f<- ldply(f, data.frame)

g<- lapply(data_split$`7`$rsid, outcome_snps)
 g<- ldply(g, data.frame)

h<- lapply(data_split$`8`$rsid, outcome_snps)
 h<- ldply(h, data.frame)

i<- lapply(data_split$`9`$rsid, outcome_snps)
 i<- ldply(i, data.frame)




outcome_data <- rbind(a,b,c,d,e,f,g,h,i)
head(outcome_data)
nrow(outcome_data)



savefile1 <- paste(outcome_ID,"outcome_data_finemapping_with_proxy.txt", sep="_")

write.table(outcome_data, file=savefile1, quote=F, row.names=F, sep="\t")











