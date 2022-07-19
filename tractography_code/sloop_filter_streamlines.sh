#!/usr/bin/env bash

source=$1

for cohort in ${source}/young; do
    cname=$(basename ${cohort})
    for subject in ${cohort}/*; do
        sname=$(basename ${subject})
        for trial in ${subject}/*; do
            tname=$(basename ${trial})

            echo ${trial}

            # START NEW
            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.superior-frontal.left.mask.nii.gz \
                ${trial}/t1w.registered.superior-frontal.left.mask.dilated.nii.gz

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.superior-frontal.left.mask.dilated.0.nii.gz \
                ${trial}/streamlines.wm.npv10.sfl0.trk \
                -f

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.sfl0.trk \
                ${trial}/t1w.registered.thalamus.left.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.sfl0.th.trk \
                -f

            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.superior-frontal.right.mask.nii.gz \
                ${trial}/t1w.registered.superior-frontal.right.mask.dilated.nii.gz

            echo python sloop_split_mask.py \
                ${trial}/t1w.registered.superior-frontal.right.mask.dilated.nii.gz \
                3

            scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.superior-frontal.right.mask.dilated.2.nii.gz \
                ${trial}/streamlines.wm.npv10.sfr2.trk \
                -f

            scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.sfr2.trk \
                ${trial}/t1w.registered.thalamus.right.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.sfr2.th.trk \
                -f
            # END NEW


            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.superior-frontal.left.mask.nii.gz \
                ${trial}/t1w.registered.superior-frontal.left.mask.dilated.nii.gz

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.superior-frontal.left.mask.dilated.nii.gz \
                ${trial}/streamlines.wm.npv10.sfl.trk \
                -f

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.sfl.trk \
                ${trial}/t1w.registered.thalamus.left.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.sfl.th.trk \
                -f

            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.caudal-middle-frontal.left.mask.nii.gz \
                ${trial}/t1w.registered.caudal-middle-frontal.left.mask.dilated.nii.gz

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.caudal-middle-frontal.left.mask.dilated.nii.gz \
                ${trial}/streamlines.wm.npv10.cmfl.trk \
                -f

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.cmfl.trk \
                ${trial}/t1w.registered.thalamus.left.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.cmfl.th.trk \
                -f

            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.rostral-middle-frontal.left.mask.nii.gz \
                ${trial}/t1w.registered.rostral-middle-frontal.left.mask.dilated.nii.gz

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.rostral-middle-frontal.left.mask.dilated.nii.gz \
                ${trial}/streamlines.wm.npv10.rmfl.trk \
                -f

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.rmfl.trk \
                ${trial}/t1w.registered.thalamus.left.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.rmfl.th.trk \
                -f

            echo python ~/research/projects/sloop/code/sloop_dilate_mask.py \
                ${trial}/t1w.registered.caudal-anterior-cingulate.left.mask.nii.gz \
                ${trial}/t1w.registered.caudal-anterior-cingulate.left.mask.dilated.nii.gz

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.trk \
                ${trial}/t1w.registered.caudal-anterior-cingulate.left.mask.dilated.nii.gz \
                ${trial}/streamlines.wm.npv10.cacl.trk \
                -f

            echo scil_filter_streamlines.py \
                ${trial}/streamlines.wm.npv10.cacl.trk \
                ${trial}/t1w.registered.thalamus.left.mask.nii.gz \
                ${trial}/streamlines.wm.npv10.cacl.th.trk \
                -f
        done
    done
done
