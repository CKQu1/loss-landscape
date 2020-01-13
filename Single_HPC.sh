#!/bin/bash
#PBS -P cortical
#PBS -N Single_HPC
#PBS -q defaultQ
#PBS -l nodes=1:ppn=2
#PBS -l walltime=23:59:59
#PBS -l mem=20GB
#PBS -e PBSout
#PBS -o PBSout
##PBS -V
##PBS -J 1-5

#module load hdf5/1.8.16
#module load opencv

MATLAB_SOURCE_PATH1="/scratch/cortical/loss-landscape/post_analysis"
MATLAB_SOURCE_PATH2="/scratch/cortical/PostandPreProcessforNS"
MATLAB_PROCESS_FUNC="remove_useless_propert_mat_DNN"
#DATA_DIR="temp2"

set -x
cd "$PBS_O_WORKDIR"
cd /scratch/cortical

matlab  -nodisplay  -r "cd('${MATLAB_SOURCE_PATH1}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}') , \
                                                       cd('${MATLAB_SOURCE_PATH2}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}'), \
                                                       ${MATLAB_PROCESS_FUNC}, exit" 


