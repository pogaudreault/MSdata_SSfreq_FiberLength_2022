#!/usr/bin/env bash
# SLOOP THALAMUS TRACKING PIPELINE
# This script runs the diffusion pipeline of the SLOOP project. The results are 
# written in a subdirectory.
#
# It should be run in a folder with the following content:
#
#   - dwi.nii.gz: The diffusion weighted MR images. 64 gradient directions is
#       assumed with the first image being the b0 (65 images in the file). To 
#       avoid flip issues, all dimensions should have a positive stride.
#
#   - bvec: The b-vectors of the DWI in the FSL format.
#
#   - bval: The b-values of the DWI in the FSL format.
#
# The processing steps are:
#
#   1. Extract the b0 brain (scilpy).
#   2. Correct for motion and eddy currents (eddy). 
#
# It assumes the following packages/scripts/applications are available:
#
#   - python: Python version 2.7
#
#   - scilpy: The SCIL python package.
#
#   - fsl5.0: FSL version 5.0.
#   
#   - fibercompression
#
#   - nlsam
#

# The path to the scilpy scripts folder.
SCILPY="/home/sam/research/scilpy/scripts/"

# The path to the cimem scripts folder.
CIMEM="/home/sam/cp/cimem/scripts/"

# The path to the nlsam script folder.
NLSAM="/home/sam/research/nlsam/script/"

# Create a directory for the results.
OUTPUT_DIR="thalamus/"
mkdir ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

python ${SCILPY}compute_local_tracking_pft.py \
    ../dmri/fodf.nii.gz \
    thalamus.nii.gz \
    ../dmri/map_include.nii.gz \
    ../dmri/map_exclude.nii.gz \
    streamlines_low.trk \
    --npv 1

fibercompression \
    streamlines_low.trk \
    streamlines_low.trk \
    -e 0.1 \
    -c \
    -f

# Track with a high number of seeds per voxel.
#python ${SCILPY}compute_local_tracking_pft.py \
#    fodf.nii.gz \
#    interface.nii.gz \
#    map_include.nii.gz \
#    map_exclude.nii.gz \
#    streamlines_high.trk \
#    --npv 10

#fibercompression \
#    streamlines_high.trk \
#    streamlines_high.trk \
#    -e 0.1 \
#    -c \
#    -f
