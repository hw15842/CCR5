
######################################
### MCH_MSCV_rerun_better_clumping ###
######################################

# pull in args
args  <-  commandArgs(trailingOnly = TRUE)
WD   <-  toString(args[1]) #Phenotypic exposure or outcome of interest

setwd(WD)

library (devtools)

library(plyr)

library(data.table)


library(R.utils)


library(TwoSampleMR)

#ao <- available_outcomes()

MCH_clumped_res_1 <- read.table ("MCH_clumping_results_all.txt", header=T)
MSCV_clumped_res_1 <- read.table("MSCV_clumping_results_all.txt", header=T)

MCH_clumped_res_2 <- clump_data(MCH_clumped_res_1)
MSCV_clumped_res_2 <- clump_data(MSCV_clumped_res_1)



###########################
## MRbase outcome traits ##
###########################

outcome_traits_mrbase <- read.csv("list_of_395_traits.csv", header=T)

#remove NAs 
outcome_traits_mrbase <- outcome_traits_mrbase[!is.na(outcome_traits_mrbase$MR.Base.id),]


### MCH ###

#run_mr_MCH <- function(outcome_ID){
  
#  outcome_1 <- extract_outcome_data(snps = MCH_clumped_res_2$SNP, outcome = outcome_ID, proxies=FALSE)
#  dat1 <- harmonise_data(MCH_clumped_res_2, outcome_1)
#  res1 <- mr(dat1, method_list = "mr_ivw")
#  return(res1)
#}

#results_MRbase_MCH <- lapply(outcome_traits_mrbase$MR.Base.id, run_mr_MCH)
#results_MRbase_MCH_table <- ldply(results_MRbase_MCH, data.frame)
#write.table(results_MRbase_MCH_table, file="results_MRbase_MCH_table_new_clumping_data.txt", quote=F, sep="\t")

### MSCV ###

#run_mr_MSCV <- function(outcome_ID){
#  
#  outcome_1 <- extract_outcome_data(snps = MSCV_clumped_res_2$SNP, outcome = outcome_ID, proxies=FALSE)
#  dat1 <- harmonise_data(MSCV_clumped_res_2, outcome_1)
#  res1 <- mr(dat1, method_list = "mr_ivw")
#  return(res1)
#}#

#results_MRbase_MSCV <- lapply(outcome_traits_mrbase$MR.Base.id, run_mr_MSCV)
#results_MRbase_MSCV_table <- ldply(results_MRbase_MSCV, data.frame)
#write.table(results_MRbase_MSCV_table, file="results_MRbase_MSCV_table_new_clumping_data.txt", quote=F, sep="\t")


######################
#### Other traits #### 
######################

other_trait_names <- read.table("other_traits_URLs.txt")

#read_other_traits <- function(trait_name){#

#	paste_file1 <- paste("https://data.broadinstitute.org/alkesgroup/UKBB/", trait_name, sep="")
#	other_trait <- fread(paste_file1)
#	other_trait <- format_data(other_trait, type="outcome", snp_col="SNP", 
#                    beta_col="Beta", se_col="se", eaf_col="EAF", effect_allele_col="A1", 
#                    other_allele_col="A2", pval_col="P", pos_col="POS", chr_col="CHR")#

#	savefile1 <- paste("other_trait", trait_name, sep="_")
#	assign(savefile1, other_trait ,envir = globalenv())
#	write.table(other_trait, file=savefile1, quote=F, sep="\t")#

#}#

#X <- lapply(other_trait_names$V1, read_other_traits)


### read in the files that were made above 

read_in_files <- function(trait_file){

	paste_file1 <- paste("other_trait", trait_name, sep="_")
	other_trait <- fread(paste_file1)
	assign(paste_file1, other_trait, envir=globalenv())

}

X <- lapply(other_trait_names$V1, read_in_files)

head(X)

### MCH ###

run_mr_MCH_other <- function(outcome_ID){
  
  dat1 <- harmonise_data(MCH_clumped_res_2, outcome_ID)
  res1 <- mr(dat1, method_list = "mr_ivw")
  return(res1)
}

results_other_MCH <- lapply(X, run_mr_MCH_other)
results_other_MCH_table <- ldply(results_other_MCH, data.frame)
write.table(results_other_MCH_table, file="results_other_MCH_table_new_clumping_data.txt", quote=F, sep="\t")

### MSCV ###

run_mr_MSCV_other <- function(outcome_ID){
  
  dat1 <- harmonise_data(MSCV_clumped_res_2, outcome_ID)
  res1 <- mr(dat1, method_list = "mr_ivw")
  return(res1)
}

results_other_MSCV <- lapply(X, run_mr_MSCV_other)
results_other_MSCV_table <- ldply(results_other_MSCV, data.frame)
write.table(results_other_MSCV_table, file="results_other_MSCV_table_new_clumping_data.txt", quote=F, sep="\t")


#### Bring all results together ##


results_all_MCH <- rbind(results_MRbase_MCH_table, results_other_MCH_table)


results_all_MSCV <- rbind(results_MRbase_MSCV_table, results_other_MSCV_table)

write.table(results_all_MCH, file="results_all_MCH_new_clumping_data.txt", quote=F, sep="\t")

write.table(results_all_MSCV, file="results_all_MSCV_new_clumping_data.txt", quote=F, sep="\t")
