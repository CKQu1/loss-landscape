"""
    Calculate the hessian matrix of the projected surface and their eigen values.
"""

import argparse
import copy
import numpy as np
import h5py
import torch
import time
import socket
import os
import sys
import torchvision
import torch.nn as nn
import mpi4pytorch
import dataloader
import net_plotter
import plot_2D
import plot_1D
import model_loader
import scheduler

from hessian_eigenthings import compute_hessian_eigenthings
import scipy.io as sio


###############################################################
####                        MAIN
###############################################################

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='plotting loss surface')
    parser.add_argument('--mpi', '-m', action='store_true', help='use mpi')
    parser.add_argument('--cuda', '-c', action='store_true', help='use cuda')
    parser.add_argument('--threads', default=2, type=int, help='number of threads')
    parser.add_argument('--ngpu', type=int, default=1, help='number of GPUs to use for each rank, useful for data parallel evaluation')
    parser.add_argument('--batch_size', default=128, type=int, help='minibatch size')

    # data parameters
    parser.add_argument('--dataset', default='cifar10', help='cifar10 | imagenet')
    parser.add_argument('--datapath', default='cifar10/data', metavar='DIR', help='path to the dataset')
    parser.add_argument('--raw_data', action='store_true', default=False, help='no data preprocessing')
    parser.add_argument('--data_split', default=1, type=int, help='the number of splits for the dataloader')
    parser.add_argument('--split_idx', default=0, type=int, help='the index of data splits for the dataloader')
    parser.add_argument('--trainloader', default='', help='path to the dataloader with random labels')
    parser.add_argument('--testloader', default='', help='path to the testloader with random labels')

    # model parameters
    parser.add_argument('--model', default='resnet56', help='model name')
    parser.add_argument('--model_folder', default='', help='the common folder that contains model_file and model_file2')
    parser.add_argument('--model_file', default='', help='path to the trained model file')
    parser.add_argument('--model_file2', default='', help='use (model_file2 - model_file) as the xdirection')
    parser.add_argument('--model_file3', default='', help='use (model_file3 - model_file) as the ydirection')
    parser.add_argument('--loss_name', '-l', default='crossentropy', help='loss functions: crossentropy | mse')

    # direction parameters
    parser.add_argument('--dir_file', default='', help='specify the name of direction file, or the path to an eisting direction file')
    parser.add_argument('--dir_type', default='weights', help='direction type: weights | states (including BN\'s running_mean/var)')
    parser.add_argument('--x', default='-1:1:51', help='A string with format xmin:x_max:xnum')
    parser.add_argument('--y', default=None, help='A string with format ymin:ymax:ynum')
    parser.add_argument('--xnorm', default='', help='direction normalization: filter | layer | weight')
    parser.add_argument('--ynorm', default='', help='direction normalization: filter | layer | weight')
    parser.add_argument('--xignore', default='', help='ignore bias and BN parameters: biasbn')
    parser.add_argument('--yignore', default='', help='ignore bias and BN parameters: biasbn')
    parser.add_argument('--idx', default=0, type=int, help='the index for the repeatness experiment')
    parser.add_argument('--surf_file', default='', help='customize the name of surface file, could be an existing file.')

    # plot parameters
    parser.add_argument('--show', action='store_true', default=False, help='show plotted figures')
    parser.add_argument('--plot', action='store_true', default=False, help='plot figures after computation')

    args = parser.parse_args()

    torch.manual_seed(123)
    #--------------------------------------------------------------------------
    # Environment setup
    #--------------------------------------------------------------------------
    if args.mpi:
        comm = mpi4pytorch.setup_MPI()
        rank, nproc = comm.Get_rank(), comm.Get_size()
    else:
        comm, rank, nproc = None, 0, 1

    # in case of multiple GPUs per node, set the GPU to use for each rank
    if args.cuda:
        if not torch.cuda.is_available():
            raise Exception('User selected cuda option, but cuda is not available on this machine')
        gpu_count = torch.cuda.device_count()
        torch.cuda.set_device(rank % gpu_count)
        print('Rank %d use GPU %d of %d GPUs on %s' %
              (rank, torch.cuda.current_device(), gpu_count, socket.gethostname()))

    #--------------------------------------------------------------------------
    # Load models and extract parameters
    #--------------------------------------------------------------------------
    net = model_loader.load(args.dataset, args.model, args.model_file)
    if args.ngpu > 1:
        # data parallel with multiple GPUs on a single node
        net = nn.DataParallel(net, device_ids=range(torch.cuda.device_count()))
   

    #--------------------------------------------------------------------------
    # Setup dataloader
    #--------------------------------------------------------------------------
    # download CIFAR10 if it does not exit
    if rank == 0 and args.dataset == 'cifar10':
        torchvision.datasets.CIFAR10(root=args.dataset + '/data', train=True, download=True)

    mpi4pytorch.barrier(comm)

    trainloader, testloader = dataloader.load_dataset(args.dataset, args.datapath,
                                args.batch_size, args.threads, args.raw_data,
                                args.data_split, args.split_idx,
                                args.trainloader, args.testloader)

    #--------------------------------------------------------------------------
    # Setup loss function
    #--------------------------------------------------------------------------
    if args.loss_name == 'crossentropy':
        loss = torch.nn.functional.cross_entropy
    else:
        raise Exception('Add your loss function here')

    #--------------------------------------------------------------------------
    # Start the computation
    #--------------------------------------------------------------------------
    num_eigenthings = 5  # compute top 20 eigenvalues/eigenvectors

    eigenvals, eigenvecs = compute_hessian_eigenthings(net, trainloader,
                                                   loss, num_eigenthings,False,"power_iter",True,512)

    #--------------------------------------------------------------------------
    # save results
    #--------------------------------------------------------------------------
    sio.savemat(args.model_folder + '/eigendata2.mat',
                            mdict={'eigenvals': eigenvals,'eigenvecs': eigenvecs},
                            )

