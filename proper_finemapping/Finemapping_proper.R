##########################
### Finemapping_proper ###
##########################

library (devtools)
library(plyr)
library(dplyr)
library(data.table)

setwd("/newhome/hw15842/PhD/CCR5/proper_finemapping")

### Need to get the summary stats files into the correct format

## rsid, chromosome, position, noneff_allele, eff_allele, maf, beta, se



finemapping_sorting_data_function <- function(outcome_trait) {

	X <- fread(outcome_trait)
	X$maf <- ifelse (X$EAF<=0.5, as.numeric(X$EAF),
                    ifelse(X$EAF>=0.5, as.numeric(1-(X$EAF)), NA))
	X <- subset(X, select=-c(EAF, REF, P, N, INFO))
	names(X) <- c("rsid", "chromosome", "position", "eff_allele", "noneff_allele", "beta", "se", "maf")
	X <- subset(X, select=c(1,2,3,5,4,8,6,7))
	return(X)

}

temp = list.files(path="/newhome/hw15842/PhD/CCR5/proper_finemapping", pattern=".sumstats.gz")
temp

Z1 <- lapply(temp, finemapping_sorting_data_function)

names(Z1) <- temp


for (x in names(Z1))
  write.table(Z1[[x]], file=paste(x, "reordered_for_finemapping.txt", sep="_"), sep="\t", quote=F, row.names=F)





UC <- fread("UC_de_Lange_2017_HW_EDITS.assoc.tsv.gz")
UC$maf <- ifelse (UC$freq<=0.5, as.numeric(UC$freq),
                   ifelse(UC$freq>=0.5, as.numeric(1-(UC$freq)), NA))
X <- subset(X, select=-c(freq, p, n))
UC$chromosome <- c(100)
UC$position <- c(100)
names(X) <- c("rsid", "eff_allele", "noneff_allele", "beta", "se", "maf", "chromosome", "position")
X <- subset(X, select=c(1,7,8,3,2,6,4,5))


write.table(X, file="UC_de_Lange_2017_HW_EDITS.assoc.tsv.gz_reordered_for_finemapping.txt")


