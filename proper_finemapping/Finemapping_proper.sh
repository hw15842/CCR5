#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00

WORK_DIR="/newhome/hw15842/PhD/CCR5/proper_finemapping"
module add languages/R-3.5.1-ATLAS-gcc-6.1

R CMD BATCH --no-save --no-restore /newhome/hw15842/PhD/CCR5/proper_finemapping/Finemapping_proper.R //newhome/hw15842/PhD/CCR5/proper_finemapping/Finemapping_proper.out
