#!/usr/bin/env bash
# SLOOP FREESURFER SEGMENTATION PIPELINE
# This script segments the cortex and deep structures of the brain using
# Freesurfer.
#
# It should be run in a folder with the following content:
#
#   dmri/t1w.nii.gz: A T1 weighted image that is registered to the DW images
#       of the same folder.
#
#

# Create a directory for the results.
OUTPUT_DIR="seg/"
mkdir ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

# Save freesurfer output in the current directory under subject id freesurfer.
SUBJECTS_DIR=$(pwd)

# Create a T1 with the stride BrainStorm expects.
#mrconvert \
#    t1w.nii.gz \
#    t1w_bs_stride.nii.gz \
#    -stride -1,3,-2 \
#    -force

# Perform the full reconstruction.
recon-all \
    -subject freesurfer \
    -i ../dmri/t1w.nii.gz \
    -all

# Compute the results in the native space.
# Convert /mri/T1.mgz (T1 MRI volume)
cd freesurfer/mri
mri_vol2vol \
    --mov T1.mgz \
    --targ rawavg.mgz \
    --regheader \
    --o ../../t1w.mgz \
    --no-save-reg

# Convert /mri/aseg.mgz (segmentation of subcortical structures)
mri_label2vol \
    --seg aseg.mgz \
    --temp rawavg.mgz \
    --o ../../aseg.mgz \
    --regheader aseg.mgz

#/surf/?h.pial (grey/csf interface)
tkregister2 \
    --mov rawavg.mgz \
    --targ orig.mgz \
    --reg register.native.dat \
    --noedit \
    --regheader

mri_surf2surf \
    --sval-xyz pial \
    --reg register.native.dat rawavg.mgz \
    --tval ../../lh.pial \
    --tval-xyz \
    --hemi lh \
    --s freesurfer 

mri_surf2surf \
    --sval-xyz pial \
    --reg register.native.dat rawavg.mgz \
    --tval ../../rh.pial \
    --tval-xyz \
    --hemi rh \
    --s freesurfer 

#/surf/?h.white (grey/white matter interface)
mri_surf2surf \
    --sval-xyz white \
    --reg register.native.dat rawavg.mgz \
    --tval ../../lh.white \
    --tval-xyz \
    --hemi lh \
    --s freesurfer 
mri_surf2surf \
    --sval-xyz white \
    --reg register.native.dat rawavg.mgz \
    --tval ../../rh.white \
    --tval-xyz \
    --hemi rh \
    --s freesurfer 
cd ../../

#/label/?h.*.annot (cortical surface-based atlases)
cp \
    -r \
    freesurfer/label \
    label
