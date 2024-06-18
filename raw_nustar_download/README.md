# heasoft-test-base

## Raw NuSTAR Download

Download the data file through [here](https://heasarc.gsfc.nasa.gov/db-perl/W3Browse/w3table.pl?tablehead=name%3Dnumaster&Action=More+Options)

- Search with ObsID: 80414202001
- Select the observation, hit `Retrieve`, and then download the file from the link.

- If you download different data and/or want to use different GTI and/or REG files, that is fine, don't worry. You just need to change the following variables in the shell script:
  - `DOWNLOADED_DATA`, `TIME_INTERVAL_FILE`, `REGION_FILE`, `OBSID`
    - The `TIME_INTERVAL_FILE` and `REGION_FILE` files being pointed to live in `analysisSelections/goodTimeInterval/` and `analysisSelections/region/`, respectively
  - And the file names in the `.xcm` files in the `5-xspec-test` directory
    - e.g., `data 1:1 nu<OBSID>A06_cl_grade0_sr.pha 2:2 nu<OBSID>B06_cl_grade0_sr.pha`

These fields are currently set to:

- `DOWNLOADED_DATA="w3browse-68892.tar"`
- `TIME_INTERVAL_FILE="time_gti"`
- `REGION_FILE="reg_fpm"`
- `OBSID="80414202001"`
- and, e.g., `data 1:1 nu80414202001A06_cl_grade0_sr.pha 2:2 nu80414202001B06_cl_grade0_sr.pha`
