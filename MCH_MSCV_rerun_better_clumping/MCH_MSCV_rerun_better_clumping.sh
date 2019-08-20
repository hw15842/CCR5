#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=36:00:00


WORK_DIR="/newhome/hw15842/PhD/CCR5/MCH_MSCV_rerun_better_clumping"
module add languages/R-3.5.1-ATLAS-gcc-6.1

R CMD BATCH --no-save --no-restore '--args /newhome/hw15842/PhD/CCR5/MCH_MSCV_rerun_better_clumping' /newhome/hw15842/PhD/CCR5/MCH_MSCV_rerun_better_clumping/MCH_MSCV_rerun_better_clumping.R /newhome/hw15842/PhD/CCR5/MCH_MSCV_rerun_better_clumping/MCH_MSCV_rerun_better_clumping.out


