### Colocalisation eqtl analysis ###

# pull in args
args	<- 	commandArgs(trailingOnly = TRUE)
outcome_ID 	<- 	toString(args[1]) #Outcome of interest



## INstall devtools ##
install.packages("devtools", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')
install.packages("plyr", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')
install.packages("data.table", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')

library(devtools)
library(plyr)
library(data.table)

## Install snpStats ##

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')

BiocManager::install("snpStats")


## Install coloc ##
install_github("cran/coloc", lib = "/newhome/hw15842/R/x86_64-pc-linux-gnu-library/3.5", repos='http://cran.us.r-project.org')
library(coloc)


## Set working directory##

setwd("/newhome/hw15842/PhD/CCR5/colocalisation")





### Get all the SNPs associated with the CCR5 gene from eQTLgen ### these are the ones extracted from the SMR data, these have the beta and se 

CCR5_snps_eQTLgen <- read.table("CCR5_snps_eQTLgen.txt", header=T)

head (CCR5_snps_eQTLgen)
nrow(CCR5_snps_eQTLgen)

### Get the effect allele frequency from the .esi smr file, there is a frequency column in table above but cant be sure what allele it is refering too so need to double check 

cis_eQTLS_all <- fread("cis-eQTLsFDR0.05-ProbeLevel.txt_besd.esi", header=F)

names(cis_eQTLS_all) <- c("Chromosome", "SNP", "genetic_distance", "base_pair_pos", "effect_allele", "other_allele", "eaf")

head(cis_eQTLS_all)
nrow(cis_eQTLS_all)


### merge CCR5 snps and all cis eqtls to get the effect allele frequencies ##


CCR5_snps_eQTLgen <- merge(CCR5_snps_eQTLgen, cis_eQTLS_all, by="SNP")

head (CCR5_snps_eQTLgen)
nrow(CCR5_snps_eQTLgen)


### Make a minor allele frequency column ##


CCR5_snps_eQTLgen$MAF <- ifelse (CCR5_snps_eQTLgen$eaf<=0.5, as.numeric(CCR5_snps_eQTLgen$eaf),
                         ifelse(CCR5_snps_eQTLgens$eaf>=0.5, as.numeric(1-(CCR5_snps_eQTLgen$eaf))))



## Variance = SE^2

# Create varbeta column #

CCR5_snps_eQTLgen$varbeta <- ((CCR5_snps_eQTLgen$SE)^2)

head(CCR5_snps_eQTLgen)
head(CCR5_snps_eQTLgen$SNP)


## Create dataset1 in format that can be used in coloc.abf function ## snp, pval, MAF, beta, Variance of beta, type(quant or case control) and Number of people (31684 from https://molgenis26.gcc.rug.nl/downloads/eqtlgen/cis-eqtl/SMR_formatted/README_cis_full_SMR)

dataset1 <- list(c(as.character(CCR5_snps_eQTLgen$SNP)), c(CCR5_snps_eQTLgen$p), c(CCR5_snps_eQTLgen$MAF), c(CCR5_snps_eQTLgen$b), 
                 c(CCR5_snps_eQTLgen$varbeta), c("quant"), c(31684))

names(dataset1) <- c("snp", "pvalues", "MAF", "beta", "varbeta", "type", "N")

lengths(dataset1)


## Create datset2 ##

## Outcome - pulled in from args - osteoporosis, wbc and rbc counts ##



## extract outcome data for the eqtl snps ##

file1 <- paste(outcome_ID,"blood_count_chr3_rsonly.txt", sep="_")

outcome <- fread(file1, header=T)

names(outcome) <- c("SNP", "chr", "position", "A1", "A2", "effect_allele", "eaf", "beta", "se", "p", "N", "info")

## extract the same snps as eqtls #

rsids <- data.frame(CCR5_snps_eQTLgen$SNP)

head(rsids)

names(rsids) <- c("SNP")

outcome <- merge(outcome, rsids, by="SNP")

head(outcome)
nrow(outcome)


## create MAF column ## 

outcome$MAF <- ifelse (outcome$eaf<=0.5, as.numeric(outcome$eaf),
                         ifelse(outcome$eaf>=0.5, as.numeric(1-(outcome$eaf)), NA))

# Create varbeta column #

outcome$varbeta <- ((outcome$se)^2)

head(outcome)
nrow(outcome)

head(outcome$SNP)



## Need to know number of cases and number of controls and get proportion of cases ## need it to put into dataset 2 - 
#	DONT HAVE YET FOR BLOOD TRAITS
### Blood cell count traits continuous so use quant



## Create dataset2 ##

dataset2 <- list(c(as.character(outcome$SNP)), c(outcome$p), c(outcome$MAF), c(outcome$beta),
                 c(outcome$varbeta), c("quant"), c(outcome$N)) # s = proportion of samples tht are cases 


names(dataset2) <- c("snp", "pvalues", "MAF", "beta", "varbeta", "type", "N")

lengths(dataset2)


head(dataset1[[1]],)
head(dataset2[[1]],)

#match(dataset1$snp, dataset2$snp)

## Remove any snps not starting with rs 

## Run coloc analysis ##

coloc_results <- coloc.abf(dataset1, dataset2)

coloc_results$summary

head(coloc_results$results)

coloc_results_summary <- as.data.frame(coloc_results$summary)

coloc_results_summary

coloc_results_all <- as.data.frame(coloc_results$results)

head(coloc_results_all)

savefile1 <- paste("coloc_results_summary",outcome_ID,".txt", sep="_")

savefile2 <- paste("coloc_results_all",outcome_ID,".txt", sep="_")

write.table(coloc_results_summary, file=savefile1, quote=F, row.names=T, sep="\t")

write.table(coloc_results_all, file=savefile2, quote=F, row.names=F, sep="\t")




