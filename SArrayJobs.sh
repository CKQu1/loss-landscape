#!/bin/bash
#PBS -P cortical
#PBS -N SArrayJobs
#PBS -q defaultQ
#PBS -l nodes=1:ppn=2
#PBS -l walltime=23:50:59
#PBS -l mem=32GB
#PBS -e PBSout/
#PBS -o PBSout/
##PBS -V
#PBS -J 1-31


MATLAB_SOURCE_PATH1="post_analysis"
MATLAB_SOURCE_PATH2="/scratch/cortical/PostandPreProcessforNS"
MATLAB_PROCESS_FUNC="SGD_analysis"
DATA_DIR="trained_nets"
echo ${PBS_ARRAY_INDEX}
set -x
cd "$PBS_O_WORKDIR"

matlab  -nodisplay  -r "cd('${MATLAB_SOURCE_PATH1}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}') , \
                                                   cd('${MATLAB_SOURCE_PATH2}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}'), \
                                                   cd('${DATA_DIR}'), addpath(genpath(cd)), ${MATLAB_PROCESS_FUNC}(${PBS_ARRAY_INDEX}), exit" # Create ${INPUT_APPENDIX} file

