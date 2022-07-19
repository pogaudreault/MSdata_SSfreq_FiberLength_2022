#!/usr/bin/env python

import argparse
import nibabel
import numpy
import scipy.ndimage.morphology

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('image', type=str)
    parser.add_argument('n', type=int)
    args = parser.parse_args()

    img = nibabel.load(args.image)
    data = img.get_data()

    x_data = data.sum(2).sum(0)
    first = next((i for i, x in enumerate(x_data) if x), None)
    last = data.shape[1] - 1 - \
        next((i for i, x in enumerate(reversed(x_data)) if x), None)

    block_size = (last - first) // args.n
    start = first
    for i in range(args.n):
        end = start + block_size + 1
        new_data = numpy.zeros_like(data)
        new_data[:, start:end, :] = data[:, start:end, :]
        new_img = nibabel.Nifti1Image(new_data.astype(float), img.get_affine())
        name = args.image.replace('nii.gz', '{}.nii.gz'.format(i))
        nibabel.save(new_img, name)
        start += block_size

if __name__ == '__main__':
    main()
