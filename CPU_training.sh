#!/bin/bash
#PBS -P THAP
#PBS -N land_noise
#PBS -q defaultQ 
#PBS -l select=1:ncpus=1:ngpus=1:mem=24gb
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
#python3 main.py --patch_size=13 --num_patches=1 --loc_hidden=256 --glimpse_hidden=128 --num_glimpses=10 --valid_size=0.1 --batch_size=256 --batchnorm_flag_phi=True --batchnorm_flag_l=True --batchnorm_flag_g=True --batchnorm_flag_h=True --glimpse_scale=1 --weight_decay=0.002 --dropout_phi=0.2 --dropout_l=0.3 --dropout_g=0.2 --dropout_h=0.3 --use_gpu=False --dataset_name='CIFAR' --train_patience=50 --epochs=500

#--batch_szie= --loc_hidden=192 --hidden_size=320 --glimpse_hidden= --num_glimpse= --glimpse_scale= --loss_fun_action= --loss_fun_baseline= 

#python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=128

# python plot_surface.py --cuda --model resnet14 --x=-1:1:201 --y=-1:1:201 --model_file ./trained_nets/resnet14_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_500.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot
# python plot_surface.py --cuda --model resnet14 --x=-1:1:201 --y=-1:1:201 --model_file ./trained_nets/resnet14_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_500.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot


#python -m cifar10.main --model='resnet20' --epochs=500  --batch_size=128
#python -m cifar10.main --model='resnet20_noshort' --epochs=500  --batch_size=128

#python -m cifar10.main --model='resnet56' --epochs=500  --batch_size=128
#python -m cifar10.main --model='resnet56_noshort' --epochs=500  --batch_size=128

#python -m cifar10.main --model='resnet110' --epochs=500  --batch_size=128
#python -m cifar10.main --model='resnet110_noshort' --epochs=500  --batch_size=128

python compute_hessian_eig_GZ.py --cuda --batch_size=1024 --model='resnet14' --model_folder='./trained_nets/resnet14_sgd_lr=0.1_bs=1024_wd=0_mom=0_save_epoch=1' --num_eigenthings=20
python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=1024 --lr=0.01
python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=1024 --lr=0.001
python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=1024 --lr=0.5
python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=1024 --lr=0.05


#python -m cifar10.main --model='resnet56' --epochs=500  --batch_size=512
#python -m cifar10.main --model='resnet56_noshort' --epochs=500  --batch_size=512

#python -m cifar10.main --model='resnet110' --epochs=500  --batch_size=512
#python -m cifar10.main --model='resnet110_noshort' --epochs=500  --batch_size=512


#python -m cifar10.main --model='resnet56' --epochs=500  --batch_size=1024
#python -m cifar10.main --model='resnet56_noshort' --epochs=500  --batch_size=1024

#python -m cifar10.main --model='resnet110' --epochs=500  --batch_size=256
#python -m cifar10.main --model='resnet110_noshort' --epochs=500  --batch_size=256

#python -m cifar10.main --model='alex' --epochs=500  --batch_size=128
#python -m cifar10.main --model='alex' --epochs=500  --batch_size=512
#python -m cifar10.main --model='alex' --epochs=500  --batch_size=1024

#python -m cifar10.main --model='resnet14_noshort' --epochs=500  --batch_size=128
#python -m cifar10.main --model='resnet14' --epochs=500  --batch_size=128

# python plot_surface.py --cuda --model fc20 --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/fc20_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_1300.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot

# python plot_surface.py --cuda --model fc56 --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/fc56_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_1300.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn --plot


# python plot_trajectory.py --cuda --model fc20 --model_folder ./trained_nets/fc20_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 1300 --ignore biasbn

# python plot_trajectory.py --cuda --model fc56 --model_folder ./trained_nets/fc56_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 1300 --ignore biasbn


