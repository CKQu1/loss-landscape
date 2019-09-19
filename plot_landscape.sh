#Producing plots along random normalized directions
python plot_surface.py --cuda --model resnet56_noshort --x=-1.5:1.5:41 --dir_type states --model_file ./trained_nets/resnet56_noshort_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_10.t7 --dir_type weights --xnorm filter --xignore biasbn --plot

#2D
python plot_surface.py --cuda --model resnet56_noshort --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/resnet56_noshort_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_300.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn  --plot

# trajectory
python plot_trajectory.py --model resnet56_noshort --model_folder ./trained_nets/resnet56_noshort_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/ --dir_type weights --max_epoch 500 --ignore biasbn
python plot_surface.py --cuda --model resnet56_noshort --proj_file /project/cortical/loss-landscape/trained_nets/resnet56_noshort_sgd_lr=0.1_bs=128_wd=0_mom=0_save_epoch=1/PCA_weights_ignore=biasbn_save_epoch=1/directions.h5_proj_cos.h5 --surf_file /project/cortical/loss-landscape/trained_nets/resnet56_noshort_sgd_lr=0.1_bs=128_wd=0_mom=0_save_epoch=1/model_300.t7_weights_xignore=biasbn_xnorm=filter_yignore=biasbn_ynorm=filter.h5_[-1.0,1.0,51]x[-1.0,1.0,51].h5 --dir_file /project/cortical/loss-landscape/trained_nets/resnet56_noshort_sgd_lr=0.1_bs=128_wd=0_mom=0_save_epoch=1/PCA_weights_ignore=biasbn_save_epoch=1/directions.h5 --x=-1:1:51 --y=-1:1:51 --model_file ./trained_nets/resnet56_noshort_sgd_lr\=0.1_bs\=128_wd\=0_mom\=0_save_epoch\=1/model_300.t7 --dir_type weights --xnorm filter --xignore biasbn --ynorm filter --yignore biasbn  --plot

#hessian
python plot_hessian_eigen.py --cuda --threads=4 