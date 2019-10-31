import torch
import math
import h5py
import model_loader
import net_plotter
import argparse
import numpy as np
import os
import h5_util
import copy

def tensorlist_to_tensor(weights):
    """ Concatnate a list of tensors into one tensor.

        Args:
            weights: a list of parameter tensors, e.g. net_plotter.get_weights(net).

        Returns:
            concatnated 1D tensor
    """
    return torch.cat([w.view(w.numel()) if w.dim() > 1 else torch.FloatTensor(w) for w in weights])


def nplist_to_tensor(nplist):
    """ Concatenate a list of numpy vectors into one tensor.

        Args:
            nplist: a list of numpy vectors, e.g., direction loaded from h5 file.

        Returns:
            concatnated 1D tensor
    """
    v = []
    for d in nplist:
        w = torch.tensor(d*np.float64(1.0))
        # Ignoreing the scalar values (w.dim() = 0).
        if w.dim() > 1:
            v.append(w.view(w.numel()))
        elif w.dim() == 1:
            v.append(w)
    return torch.cat(v)


def npvec_to_tensorlist(direction, params):
    """ Convert a numpy vector to a list of tensors with the same shape as "params".

        Args:
            direction: a list of numpy vectors, e.g., a direction loaded from h5 file.
            base: a list of parameter tensors from net

        Returns:
            a list of tensors with the same shape as base
    """
    if isinstance(params, list):
        w2 = copy.deepcopy(params)
        idx = 0
        for w in w2:
            w.copy_(torch.tensor(direction[idx:idx + w.numel()]).view(w.size()))
            idx += w.numel()
        assert(idx == len(direction))
        return w2
    else:
        s2 = []
        idx = 0
        for (k, w) in params.items():
            s2.append(torch.Tensor(direction[idx:idx + w.numel()]).view(w.size()))
            idx += w.numel()
        assert(idx == len(direction))
        return s2

def convert_matlab_pca_data(args, direction_matlab_name,direction_python_name):
    # class ARGS:
    #     dataset='cifar10'       
    #     model='resnet56'
    #     model_folder='folders for models to be projected'
    #     dir_type='weights'
    #     ignore='biasbn'
    #     prefix='model_'
    #     suffix='.t7'
    #     start_epoch=0
    #     max_epoch=500
    #     save_epoch=1

    # args = ARGS()    

    # args.model_folder = model_folder
    # args.model = model

    last_model_file = args.model_folder + '/' + args.prefix + str(args.max_epoch) + args.suffix
    net = model_loader.load(args.dataset, args.model, last_model_file)
    w = net_plotter.get_weights(net)

    # read in matlab pca results
    f = h5py.File(direction_matlab_name, 'r')
    fpy = h5py.File(direction_python_name, 'w')    

    fpy['explained_variance_ratio_'] = np.array(f['explained_variance_ratio_'])
    fpy['explained_variance_'] = np.array(f['explained_variance_'])    
    
    pc1 = np.array(f['directionx'])
    pc2 = np.array(f['directiony'])

    f.close()

    # convert vectorized directions to the same shape as models to save in h5 file.
    # import pdb; pdb.set_trace()

    if args.dir_type == 'weights':
        xdirection = npvec_to_tensorlist(pc1, w)
        ydirection = npvec_to_tensorlist(pc2, w)
    elif args.dir_type == 'states':
        xdirection = npvec_to_tensorlist(pc1, s)
        ydirection = npvec_to_tensorlist(pc2, s)

    if args.ignore == 'biasbn':
        net_plotter.ignore_biasbn(xdirection)
        net_plotter.ignore_biasbn(ydirection)
    # import pdb; pdb.set_trace()
    h5_util.write_list(fpy, 'xdirection', xdirection)
    h5_util.write_list(fpy, 'ydirection', ydirection)
    
    fpy.close()
    print ('PCA directions saved in: %s' % direction_python_name)

    
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

    args = parser.parse_args()

    for tiny_epoch in range(1,501):      
        direction_matlab_name = args.model_folder + '/PCA_tiny_epoch' + str(tiny_epoch) + '/directions_matlab.h5'
        direction_python_name = args.model_folder + '/PCA_tiny_epoch' + str(tiny_epoch) + '/directions.h5'
        convert_matlab_pca_data(args, direction_matlab_name,direction_python_name)

