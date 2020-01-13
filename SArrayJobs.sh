#!/bin/bash
#PBS -P cortical
#PBS -N SArrayJobs
#PBS -q defaultQ
#PBS -l nodes=1:ppn=8
#PBS -l walltime=167:50:59
#PBS -l mem=30GB
#PBS -e PBSout/
#PBS -o PBSout/
##PBS -V
#PBS -J 7-8


MATLAB_SOURCE_PATH1="post_analysis"
MATLAB_SOURCE_PATH2="/scratch/cortical/PostandPreProcessforNS"
MATLAB_PROCESS_FUNC="SGD_analysis_step_level"
DATA_DIR="/project/cortical/loss-landscape/trained_nets"
echo ${PBS_ARRAY_INDEX}
set -x
cd "$PBS_O_WORKDIR"

matlab  -nodisplay  -r "cd('${MATLAB_SOURCE_PATH1}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}') , \
                                                   cd('${MATLAB_SOURCE_PATH2}'), addpath(genpath(cd)), cd('${PBS_O_WORKDIR}'), \
                                                   cd('${DATA_DIR}'), addpath(genpath(cd)), ${MATLAB_PROCESS_FUNC}(${PBS_ARRAY_INDEX}), \
						   cd('${DATA_DIR}'), SGD_analysis_step_level_lecun(${PBS_ARRAY_INDEX}), cd('${DATA_DIR}'), transverse_excursion_avalanche_enviroment(${PBS_ARRAY_INDEX}), exit"

