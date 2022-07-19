#!/usr/bin/env python

import argparse
import nibabel
import numpy
import scipy.ndimage.morphology

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('image', type=str)
    parser.add_argument('output', type=str)
    args = parser.parse_args()

    img = nibabel.load(args.image)
    data = img.get_data()

    new_data = scipy.ndimage.morphology.binary_dilation(data, iterations=2)
    new_img = nibabel.Nifti1Image(new_data.astype(float), img.get_affine())

    nibabel.save(new_img, args.output)

if __name__ == '__main__':
    main()
