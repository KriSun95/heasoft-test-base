# heasoft-test-base

## Raw NuSTAR Download

Download the data file through [here](https://heasarc.gsfc.nasa.gov/db-perl/W3Browse/w3table.pl?tablehead=name%3Dnumaster&Action=More+Options)

For deafult behaviour:

- Search with ObsID: 80414202001
- Select the observation, hit `Retrieve`, and then download the file from the link.

If you download different data and/or want to use different GTI and/or REG files, that is fine, don't worry. You just need to change the following variables in the shell script and follow the help documentation for the shell script:

- And the file names in the `.xcm` files in the `5-xspec-test` directory
  - e.g., `data 1:1 nu<OBSID>A06_cl_grade0_sr.pha 2:2 nu<OBSID>B06_cl_grade0_sr.pha`

These fields are currently set to:

- and, e.g., `data 1:1 nu80414202001A06_cl_grade0_sr.pha 2:2 nu80414202001B06_cl_grade0_sr.pha`
