# heasoft-test-base

A repository to test an HEASoft install to a previous one.
Things to consider:

* Make sure you have visited the `raw_nustar_download` directory and read the `README.md` file. We need a file _like_ `w3browse-68892.tar` in this directory containing the raw NuSTAR data.
* Make sure your HEASoft install has been sourced and you`re in an appropriate Python environment (e.g., `conda create -n heasoft-test python matplotlib numpy astropy`)."
* Make sure this script has appropriate permissions to run (e.g., `chmod 775 ./test_new_heasoft_install.sh`), although how you could see this and this instruction still being useful is beyond me."

Run as `./test_new_heasoft_install.sh benchmark`:  

* It will run HEASoft on your current configuration and store the outputs to then compare with a new, future HEASoft configuration (must be run first).
Run as `./test_new_heasoft_install.sh new`:

* It will compare the previous results to those obtained from the new currently installed HEASoft.
  
If you want the Xspec results printed to the screen after the testing then include `print-result`;

* I.e., `./test_new_heasoft_install.sh benchmark print-result` or `./test_new_heasoft_install.sh new print-result`.

Whichever test is being run, make sure the corresponding directory (new or benchmark) doesn`t already exist as the code will produce a message and not run otherwise.

The new or benchamrk directory will be created from the `replacement_directory` folder.
Note, the result is logged in the log file regardless whether they are printed to the screen and benchmark must be run first.
