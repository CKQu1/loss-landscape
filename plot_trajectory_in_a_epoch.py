"""
    Plot the optimization path in the space spanned by principle directions.
"""

import numpy as np
import torch
import copy
import math
import h5py
import os
import argparse
import model_loader
import net_plotter
from projection import setup_PCA_directions, project_trajectory
import plot_2D
import scipy.io as sio


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot optimization trajectory')
    parser.add_argument('--dataset', default='cifar10', help='dataset')
    parser.add_argument('--model', default='resnet56', help='trained models')
    parser.add_argument('--model_folder', default='', help='folders for models to be projected')
    parser.add_argument('--dir_type', default='weights',
        help="""direction type: weights (all weights except bias and BN paras) |
                                states (include BN.running_mean/var)""")
    parser.add_argument('--ignore', default='', help='ignore bias and BN paras: biasbn (no bias or bn)')
    parser.add_argument('--prefix', default='model_', help='prefix for the checkpint model')
    parser.add_argument('--suffix', default='.t7', help='prefix for the checkpint model')
    parser.add_argument('--start_epoch', default=0, type=int, help='min index of epochs')
    parser.add_argument('--max_epoch', default=300, type=int, help='max number of epochs')
    parser.add_argument('--save_epoch', default=1, type=int, help='save models every few epochs')
    parser.add_argument('--dir_file', default='', help='load the direction file for projection')

    args = parser.parse_args()

    #--------------------------------------------------------------------------
    # load the final model
    #--------------------------------------------------------------------------
    last_model_file = args.model_folder + '/' + args.prefix + str(args.max_epoch) + args.suffix
    net = model_loader.load(args.dataset, args.model, last_model_file)
    w = net_plotter.get_weights(net)
    s = net.state_dict()

    #--------------------------------------------------------------------------
    # collect models to be projected
    #--------------------------------------------------------------------------
    model_files = []
    for epoch in range(args.start_epoch, args.max_epoch + args.save_epoch, args.save_epoch):
        model_file = args.model_folder + '/' + args.prefix + str(epoch) + args.suffix
        assert os.path.exists(model_file), 'model %s does not exist' % model_file
        model_files.append(model_file)

    
    w = sio.loadmat('trained_nets/' + save_folder + '/model_' + str(args.epoch) + '_sub_loss_w.mat')
    w = list(w)

    #--------------------------------------------------------------------------
    # load or create projection directions
    #--------------------------------------------------------------------------
    # if args.dir_file:
    #     dir_file = args.dir_file
    # else:
    #     dir_file = setup_PCA_directions(args, model_files, w, s)

 
    # Name the .h5 file that stores the PCA directions.
    folder_name = args.model_folder + '/PCA_' + args.dir_type
    if args.ignore:
        folder_name += '_ignore=' + args.ignore
    folder_name += '_save_epoch=' + str(args.save_epoch)
    os.system('mkdir ' + folder_name)
    dir_name = folder_name + '/directions.h5'

    # skip if the direction file exists
    if os.path.exists(dir_name):
        f = h5py.File(dir_name, 'a')
        if 'explained_variance_' in f.keys():
            f.close()
            return dir_name

    # load models and prepare the optimization path matrix
    matrix = []
    for i in range(1,len(w)): 
        d = net_plotter.get_diff_weights(w[0], w[i])        
        d = tensorlist_to_tensor(d)
        matrix.append(d.numpy())

    # Perform PCA on the optimization path matrix
    print ("Perform PCA on the models")
    pca = PCA(n_components=2)
    pca.fit(np.array(matrix))
    pc1 = np.array(pca.components_[0])
    pc2 = np.array(pca.components_[1])
    print("angle between pc1 and pc2: %f" % cal_angle(pc1, pc2))

    print("pca.explained_variance_ratio_: %s" % str(pca.explained_variance_ratio_))

    # convert vectorized directions to the same shape as models to save in h5 file.
    
    xdirection = npvec_to_tensorlist(pc1, w[0])
    ydirection = npvec_to_tensorlist(pc2, w[0])    

    if args.ignore == 'biasbn':
        net_plotter.ignore_biasbn(xdirection)
        net_plotter.ignore_biasbn(ydirection)

    f = h5py.File(dir_name, 'w')
    h5_util.write_list(f, 'xdirection', xdirection)
    h5_util.write_list(f, 'ydirection', ydirection)

    f['explained_variance_ratio_'] = pca.explained_variance_ratio_
    f['singular_values_'] = pca.singular_values_
    f['explained_variance_'] = pca.explained_variance_
    
    f.close()
    print ('PCA directions saved in: %s' % dir_name)

    return dir_name


    #--------------------------------------------------------------------------
    # projection trajectory to given directions
    #--------------------------------------------------------------------------
    # proj_file = project_trajectory(dir_file, w, s, args.dataset, args.model,
    #                             model_files, args.dir_type, 'cos')

     proj_file = dir_file + '_proj_' + proj_method + '.h5'
    if os.path.exists(proj_file):
        print('The projection file exists! No projection is performed unless %s is deleted' % proj_file)
        return proj_file

    # read directions and convert them to vectors
    directions = net_plotter.load_directions(dir_file)
    dx = nplist_to_tensor(directions[0])
    dy = nplist_to_tensor(directions[1])

    xcoord, ycoord = [], []
    for model_file in model_files:
        net2 = model_loader.load(dataset, model_name, model_file)
        if dir_type == 'weights':
            w2 = net_plotter.get_weights(net2)
            d = net_plotter.get_diff_weights(w, w2)
        elif dir_type == 'states':
            s2 = net2.state_dict()
            d = net_plotter.get_diff_states(s, s2)
        d = tensorlist_to_tensor(d)

        x, y = project_2D(d, dx, dy, proj_method)
        print ("%s  (%.4f, %.4f)" % (model_file, x, y))

        xcoord.append(x)
        ycoord.append(y)

    f = h5py.File(proj_file, 'w')
    f['proj_xcoord'] = np.array(xcoord)
    f['proj_ycoord'] = np.array(ycoord)
    f.close()
    
    #--------------------------------------------------------------------------
    # plot
    #--------------------------------------------------------------------------
    plot_2D.plot_trajectory(proj_file, dir_file)
