import nibabel as nib
import numpy as np

def main():
   
    import ipdb;ipdb.set_trace()
    segmentation_nii = nib.load('seg/aseg.nii.gz')   
    segmentation_img = segmentation_nii.get_data()

    mask = np.logical_or(segmentation_img == 10, segmentation_img == 49)

    mask_nii = nib.Nifti1Image(mask.astype('float'), segmentation_nii.get_affine())
    nib.save(mask_nii, 'thalamus.nii.gz')

if __name__ == "__main__":
    main()
