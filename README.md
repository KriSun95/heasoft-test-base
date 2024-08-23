# heasoft-test-base

A repository to test an HEASoft install to a previous one.

Things to consider **before running**:

1. **Make sure** you have visited the `raw_nustar_download` directory and read the `README.md` file. We need a file _like_ `w3browse-68892.tar`, this can be placed in the `raw_nustar_download`.
2. **Make sure** your HEASoft install has been sourced and you're in an appropriate Python environment (e.g., `conda create -n heasoft-test python matplotlib numpy astropy`)."
   1. _E.g., `source $HEADAS/headas-init.sh` and check that `which python3` prints out the Python interpreter of the right environment with the required packages._
3. **Make sure** this script has appropriate permissions to run (e.g., `chmod 775 ./test_heasoft_install.sh`), although how you could see this and this instruction still being useful is beyond me."

Run as `./test_heasoft_install.sh --help` or `./test_heasoft_install.sh -h` to get the usage documentation (also shown below).

Whichever test is being run, make sure the corresponding directory (new or benchmark) doesn`t already exist as the code will produce a message and not run otherwise.

The new or benchamrk directory will be created from the `replacement_directory` folder.

## Data Download

_As described in the `raw_nustar_download` directory._

Download the data file through [here](https://heasarc.gsfc.nasa.gov/db-perl/W3Browse/w3table.pl?tablehead=name%3Dnumaster&Action=More+Options)

For deafult behaviour that will behave with the provided GTI and REG files:

- Search with ObsID: 80414202001
- Select the observation, hit `Retrieve`, and then download the file from the link.

If you download different data and/or want to use different GTI and/or REG files, that is fine, don't worry. Follow the help documentation for the shell script.

## Usage

```bash
A script to test an HEASoft install to a previous one.

Things to consider:
 * Make sure you have visited the 'raw_nustar_download' directory and read the
   'what2do.txt' file. We need a file _like_ 'w3browse-68892.tar' in this directory
   containing the raw NuSTAR data (the download of the same data might have a
   different name, just rename the file).
 * Make sure your HEASoft install has been sourced ('source /path/to/headas-init.sh')
   and you're in an appropriate Python environment, e.g.,
   'conda create -n heasoft-test python matplotlib numpy astropy' and check with
   'which python3').
 * Make sure this script has appropriate permissions to run (e.g.,
   'chmod 775 ./test_heasoft_install.sh'), although how you could see this and
   this instruction still being useful is beyond me.

Whichever test is being run, make sure the corresponding directory (new or benchmark)
doesn't already exist as the code will produce a message and not run otherwise.

The new or benchamrk directory will be created from the 'replacement_directory' folder.

Be aware of Path legnths, HEASoft does _not_ like long path lengths, but only sometimes.

Flags: Make sure to use the syntax `-flag <input>` (or just `-flag`, if appropriate) 
and _not_ `-flag=<input>`.

Usage: $0 [OPTIONS]

path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> [OPTIONS]

Options:
 -h ,  --help                Display this help message
 -b*, --benchmark*           Define a benchmark run should be performed or folder
                             name suffix to benchmark<suffix> to be used as a
                             benchmark
                                 - Default is \"benchmark\"
                                 - If given an arument then it will be appended to
                                   the benchmark folder name.
 -n*, --new*                 Define a new run should be performed
                                 - Default is \"new\"
                                 - If given an arument then it will become the suffix
                                   to the new run folder name (i.e., \"new<suffix>\").
                                 - If both -b/--benchmark* and -n*/--new* are given
                                   then a new run will be performed with the default
                                   (or otherwise defined) benchmark folder
 -g*, --gti-file*            Define a custom GTI file to use
                                 - Default is:
                                   \"$TIME_INTERVAL_FILE\"
 -ra*, --rega-file*            Define a custom region FPMA file to use
                                 - Default is:
                                   \"$REGION_FILEA\"
 -rb*, --regb-file*            Define a custom region FPMA file to use
                                 - Default is:"
                                   \"$REGION_FILEB\"
 -o*, --obs-id*              Define a different NuSTAR observation ID
                                 - Default is \"80414202001\"
                                 - Must correspond to the <w3browse-*.tar> file that
                                   was downloaded

Standard Eamples:"
-----------------"
## Get script description and usage
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -h

## Run HEASoft on your current configuration, store the outputs, then compare with a new,
## future HEASoft configuration (must be run first)
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b
"
## Compare previous results to those obtained from the new currently installed HEASoft
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -n
"
Fancier Eamples:
----------------
## Run a benchmark and save to a folder benchmark1
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b 1
## or equivalently"
 - path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> --benchmark 1

## Run a new run and save to a folder new2024-08-23
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -n 2024-08-23

## Run a new run and save to a folder new2024-09 and compare to a benchamrk folder
## called benchmark2 (the order of the flags does not matter)
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b 2 -n 2024-09

## Run a new run and save to a folder new2024-081 and compare to a benchamrk folder
## called benchmark1, while pointing to a new time interval and region files (the
## order of the flags does not matter)
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -n 2024-081 -b 1\ 
                                -g path/to/time_gti_file.fits -ra path/to/reg_file.reg\ 
                                -rb path/to/reg_file.reg

## Run a benchmark with downloaded data that has a different NuSTAR OBSID
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b -o <new_data_OBSID>
```

## Known Issues

1. Running the shell script not in its directory can cause an error within HEASoft due to long path legnths (especially when appending to either the "benchmark" or "new" directories being generated). Running ths script in its own directory can help with this, although running the same command again might work for some reason..
