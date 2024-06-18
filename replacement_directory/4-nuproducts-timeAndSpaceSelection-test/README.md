# heasoft-test-base

## 4-nuproducts-timeAndSpaceSelection-test

To extract and test the NuSTAR data into all the spectral information.

- Get SPEC, RF, and RMF for time and region screening add time fits file to nuproducts call

## In the '3-nuscreen-test' folder

- e.g., `nuproducts indir=./ instrument=FPMA steminputs=nu80414202001 outdir=./ extended=no runmkarf=yes runmkrmf=yes infile=nu80414202001A06_cl_grade0.evt bkgextract=no srcregionfile=./evt_2101_wholeTime/fpma_tf.reg  attfile=./nu80414202001_att.fits hkfile=./nu80414202001A_fpm.hk usrgtifile=./evt_2101_wholeTime/newA_gti.fits`

### Acknowledgement of nustardas

If the NuSTARDAS software was helpful for your research work, the following
    acknowledgement would be appreciated: "This research has made use of the
    NuSTAR Data Analysis Software (NuSTARDAS) jointly developed by the ASI Space Science
    Data Center (SSDC, Italy) and the California Institute of Technology (Caltech, USA)."
