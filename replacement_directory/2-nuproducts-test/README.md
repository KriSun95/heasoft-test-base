# heasoft-test-base

## 2-nuproducts-test

To extract and test the initial NuSTAR data into all the usual products.

### Unzip

Unzip the data

- `>>> gunzip -r ./...`

### run nupipeline

Run the pipeline

- e.g., `nupipeline obsmode=SCIENCE_SC indir=./80414202001 steminputs=nu80414202001 outdir=event_cl entrystage=1 exitstage=2 pntra=OBJECT pntdec=OBJECT statusexpr="STATUS==b0000xx00xx0xx000" cleanflick=no hkevtexpr=NONE clobber=yes runsplitsc=yes splitmode=STRICT`

### Acknowledgement of nustardas

If the NuSTARDAS software was helpful for your research work, the following
    acknowledgement would be appreciated: "This research has made use of the
    NuSTAR Data Analysis Software (NuSTARDAS) jointly developed by the ASI Space Science
    Data Center (SSDC, Italy) and the California Institute of Technology (Caltech, USA)."
