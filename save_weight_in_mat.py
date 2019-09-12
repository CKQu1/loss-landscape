"""
    Calculate and visualize the loss surface.
    Usage example:
    >>  python plot_surface.py --x=-1:1:101 --y=-1:1:101 --model resnet56 --cuda
"""
import argparse
import copy
import h5py
import torch
import time
import socket
import os
import sys
import numpy as np
import torchvision
import torch.nn as nn
import dataloader
import evaluation
import projection as proj
import net_plotter
import plot_2D
import plot_1D
import model_loader
import scheduler
import mpi4pytorch as mpi
import scipy.io as sio

###############################################################
#                          MAIN
###############################################################
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='plotting loss surface')
    # data parameters
    parser.add_argument('--dataset', default='cifar10', help='cifar10 | imagenet')
    # model parameters
    parser.add_argument('--model', default='resnet56', help='model name')
    parser.add_argument('--max_epoch', default='500', help='maximum epoch')
    args = parser.parse_args()


    #--------------------------------------------------------------------------
    # Load models and extract parameters
    #--------------------------------------------------------------------------
    all_weights = []
    for i in range(arg.max_epoch+1):
        model_file = 'model_' + str(i) + '.t7'
        net = model_loader.load(args.dataset, args.model, model_file)
        w = net_plotter.get_weights(net) # initial parameters
        #s = copy.deepcopy(net.state_dict()) # deepcopy since state_dict are references
        #import pdb; pdb.set_trace()
        all_weights.append(w)

    sio.savemat(args.model + 'all_weights.mat',
                            mdict={'weight': all_weights},
                            )
