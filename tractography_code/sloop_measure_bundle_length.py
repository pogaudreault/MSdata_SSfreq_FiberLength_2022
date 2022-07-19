#!/usr/bin/env python

import argparse
import nibabel
import numpy

from dipy.tracking.streamline import length, set_number_of_points
from dipy.segment.clustering import QuickBundles

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('streamlines', type=str)
    parser.add_argument('subject', type=str)
    parser.add_argument('region', type=str)
    parser.add_argument('output', type=str)
    args = parser.parse_args()

    trk = nibabel.streamlines.load(args.streamlines)
    streamlines = trk.tractogram.streamlines

    quickbundles = QuickBundles(threshold=20)
    new_streamlines = set_number_of_points(streamlines, nb_points=20)
    streamline_clusters = quickbundles.cluster(new_streamlines)

    sizes = numpy.array([len(c.indices) for c in streamline_clusters])
    indices = numpy.argsort(sizes)[::-1]
    lengths = numpy.array([length(streamlines[j]) for j in streamline_clusters[indices[0]].indices])

    output = args.subject + ";" + args.region
    output += ";" + '{};{}'.format(sizes[indices[0]], numpy.median(lengths))

    for ii, i in enumerate(indices[0:1]):
        new_tracto = nibabel.streamlines.Tractogram(streamlines[streamline_clusters[i].indices])
        new_tracto.affine_to_rasmm = trk.tractogram.affine_to_rasmm
        new_header = trk.header.copy()
        new_header['nb_streamlines'] = len(streamline_clusters[i].indices)
        new_trk = nibabel.streamlines.trk.TrkFile(new_tracto, new_header)
        new_trk.save('bundles/streamlines.{}.{}.{:0>3}.abc.trk'.format(args.subject, args.region, ii))

    #import ipdb;ipdb.set_trace()
    #for ii, i in enumerate(indices):
    #    if len(streamline_clusters[i].indices) >= 50:
    #        new_tracto = nibabel.streamlines.Tractogram(streamlines[streamline_clusters[i].indices])
    #        new_tracto.affine_to_rasmm = trk.tractogram.affine_to_rasmm
    #        new_header = trk.header.copy()
    #        new_header['nb_streamlines'] = len(streamline_clusters[i].indices)
    #        new_trk = nibabel.streamlines.trk.TrkFile(new_tracto, new_header)
    #        new_trk.save('bundles/streamlines.{}.{}.{:0>3}.abc.trk'.format(args.subject, args.region, ii))

    with open(args.output, 'a') as f:
        f.write(output + '\n')


if __name__ == '__main__':
    main()
