#!/bin/bash
#PBS -P THAP 
#PBS -N plot_land
#PBS -q defaultQ 
#PBS -l select=1:ncpus=1:ngpus=1:mem=16gb
#PBS -l walltime=167:59:59
#PBS -e PBSout/
#PBS -o PBSout/
##PBS -J 1-30

# make sure you have built a virtual system on python 3.6.5 
# and install pytorch just like how you install tensorflow on HPC:
# 	virtualenv --system-site-packages tf #tf is in your home directory
#	module load cuda/9.1.85 openmpi-gcc/3.0.0-cuda
#	pip install /usr/local/pytorch/torch-1.0.0a0+1a247f8.magma.cuda.9.1-cp36-cp36m-linux_x86_64.whl

cd ~
source tf/bin/activate
cd "$PBS_O_WORKDIR"
#params=`sed "${PBS_ARRAY_INDEX}q;d" job_params`
#param_array=( $params )
#python3 main.py --patch_size=13 --num_patches=1 --loc_hidden=2110 --glimpse_hidden=128 --num_glimpses=10 --valid_size=0.1 --batch_size=2110 --batchnorm_flag_phi=True --batchnorm_flag_l=True --batchnorm_flag_g=True --batchnorm_flag_h=True --glimpse_scale=1 --weight_decay=0.002 --dropout_phi=0.2 --dropout_l=0.3 --dropout_g=0.2 --dropout_h=0.3 --use_gpu=False --dataset_name='CIFAR' --train_patience=50 --epochs=500

#--batch_szie= --loc_hidden=192 --hidden_size=320 --glimpse_hidden= --num_glimpse= --glimpse_scale= --loss_fun_action= --loss_fun_baseline=

python plot_trajectory.py --model resnet14 --model_folder ./trained_nets/resnet14_sgd_lr\=0.1_bs\=1024_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn

python plot_trajectory.py --model resnet14_noshort --model_folder ./trained_nets/resnet14_noshort_sgd_lr=0.1_bs=1024_wd=0_mom=0_save_epoch=1/ --dir_type weights --max_epoch 500 --ignore biasbn

python plot_surface.py --cuda --model resnet20 --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/resnet20_noshort_sgd_lr=0.1_bs=1024_wd=0_mom=0_save_epoch=1/model_500.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

python plot_surface.py --cuda --model resnet20 --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/resnet20_sgd_lr\=0.1_bs\=512_wd\=0_mom\=0_save_epoch\=1/model_500.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

python plot_surface.py --cuda --model resnet20_noshort --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/resnet20_noshort_sgd_lr\=0.1_bs\=1024_wd\=0_mom\=0_save_epoch\=1/model_500.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot


# python plot_trajectory.py --cuda --model resnet56_noshort --model_folder ./trained_nets/resnet56_noshort_sgd_lr\=0.1_bs\=1024_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn

# python plot_trajectory.py --cuda --model resnet56 --model_folder ./trained_nets/resnet56_sgd_lr\=0.1_bs\=1024_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn

# python plot_trajectory.py --cuda --model resnet110_noshort --model_folder ./trained_nets/resnet110_noshort_sgd_lr\=0.1_bs\=256_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn

# python plot_trajectory.py --cuda --model resnet110 --model_folder ./trained_nets/resnet110_sgd_lr\=0.1_bs\=256_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn

# python plot_trajectory.py --cuda --model alex --model_folder ./trained_nets/alex_noshort_sgd_lr\=0.1_bs\=1024_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 1300 --ignore biasbn

# python plot_trajectory.py --cuda --model alex --model_folder ./trained_nets/alex_sgd_lr\=0.1_bs\=512_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 1300 --ignore biasbn




#python plot_surface.py --cuda --model alex --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/alex_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_300.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

# python plot_surface.py --cuda --model alex --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/alex_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_1205.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

# python plot_surface.py --cuda --model alex --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/alex_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_100.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

# python plot_surface.py --cuda --model alex --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/alex_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_50.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

# python plot_surface.py --cuda --model alex --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/alex_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_30.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot
