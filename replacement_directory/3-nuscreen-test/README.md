# heasoft-test-base

## 3-nuscreen-test

To extract and test the NuSTAR data into all the usual products with some additional screening.

- Screen out the none Grade 0 events with nuscreen

### starting in the '2-nuproducts-test' folder

- e.g., `nuscreen infile=nu80414202001A06_cl.evt gtiscreen=no evtscreen=yes gtiexpr=NONE gradeexpr=0 statusexpr=NONE outdir=.../3-nuscreen-test hkfile=./nu80414202001A_fpm.hk outfile=nu80414202001A06_cl_grade0.evt`

### Acknowledgement of nustardas

If the NuSTARDAS software was helpful for your research work, the following
    acknowledgement would be appreciated: "This research has made use of the
    NuSTAR Data Analysis Software (NuSTARDAS) jointly developed by the ASI Space Science
    Data Center (SSDC, Italy) and the California Institute of Technology (Caltech, USA)."
