#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=36:00:00


WORK_DIR="/newhome/hw15842/PhD/CCR5/MR-Phewas_MCH"
module add languages/R-3.5.1-ATLAS-gcc-6.1

R CMD BATCH --no-save --no-restore  '--args MSCV'  /newhome/hw15842/PhD/CCR5/MR-Phewas_MCH/MR-Phewas_MCH_395traits.R /newhome/hw15842/PhD/CCR5/MR-Phewas_MCH/MR-Phewas_MCH_395traits.out 


