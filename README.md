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
Note: The result is logged in the log file regardless whether they are printed to the screen and benchmark must be run first.

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

Note: The result is logged in the log file regardless whether they are printed to the
screen and benchmark must be run first.

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
 -p , --print-xspec-result   Set that the final Xspec result should be printed

Generic Eamples:
## Run HEASoft on your current configuration, store the outputs, then compare with a new,
## future HEASoft configuration (must be run first)
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b

## Compare previous results to those obtained from the new currently installed HEASoft
path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -n

Other Eamples:
```

## Known Issues

Running the shell script not in its directory can cause an error within HEASoft due to long path legnths (especially when appending to either the "benchmark" or "new" directories being generated). Running ths script in its own directory can help with this, although running the same command again might work for some reason..
