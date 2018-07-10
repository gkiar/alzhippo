#!/usr/bin/env python2.7

import numpy as np
import nibabel as nib
from dipy.tracking import utils
from argparse import ArgumentParser
import os.path as op

def convert_fibs(inp, outp, parcellation):
    label_nii  = nib.load(parcellation)
    label_data = label_nii.get_data()

    fiber_npz = np.load(inp)
    fibers = fiber_npz[fiber_npz.keys()[0]]

    voxel_size = label_nii.header.get_zooms()
    shape = label_data.shape
    affine = label_nii.affine

    trackvis_header = nib.trackvis.empty_header()
    trackvis_header['voxel_size'] = voxel_size
    trackvis_header['dim'] = shape
    trackvis_header['voxel_order'] = "RAS"

    trackvis_point_space = utils.affine_for_trackvis(voxel_size)
    trk = utils.move_streamlines(fibers, trackvis_point_space, input_space=np.eye(4))
    trk = list(trk)

    for_save = [(sl, None, None) for sl in trk]
    nib.trackvis.write(outp, for_save, trackvis_header)


def main():
    parser = ArgumentParser(description="Converts npz fibers to trackviz")
    parser.add_argument("inputfib", action="store", help="Input fiber file")
    parser.add_argument("parcellation", action="store", help="Set of ROIs to map")
    parser.add_argument("--outputfib", "-o", action="store", help="Output file "
                        "(defaults to same name but with different extension")
    result = parser.parse_args()

    if result.outputfib is not None:
        outfib = result.outputfib
    else:
        outfib = result.inputfib.split('.')[0]+'.trk'

    print(outfib)
    convert_fibs(result.inputfib, outfib, result.parcellation)


if __name__ == "__main__":
    main()

