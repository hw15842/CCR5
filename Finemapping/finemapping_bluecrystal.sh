#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00


WORK_DIR="/newhome/hw15842/PhD/CCR5"
module add languages/R-3.5.1-ATLAS-gcc-6.1

R CMD BATCH --no-save --no-restore '--args outcome_ID ' /newhome/hw15842/PhD/CCR5/finemapping_bluecrystal_script.R /newhome/hw15842/PhD/CCR5/finemapping_bluecrystal_script.out 
