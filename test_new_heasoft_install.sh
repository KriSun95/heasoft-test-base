#!/bin/zsh

# may need to: conda create -n heasoft-test python matplotlib numpy astropy
# and also: chmod 775 ./test_new_heasoft_install.sh

# run ./test_new_heasoft_install.sh help
# A script to test an HEASoft install to a previous one. 
# Run as `./test_new_heasoft_install.sh benchmark`
#       It will run HEASoft on your current configuration and store the outputs to then compare with a new, future HEASoft configuration.
# Run as `./test_new_heasoft_install.sh new`
#       It will compare the previous results to those obtained from the new currently installed HEASoft.
# If you want the XSPEC results printed to the screen after the testing then include 'print-result'; 
#       I.e., `./test_new_heasoft_install.sh benchmark print-result` or `./test_new_heasoft_install.sh new print-result`.
# The result is logged in the log file regardless whether they are printed to the screen.

#  change to the main directory to work in
SCRIPT_DIR=$( cd -- "$( dirname -- "${(%):-%N}" )" &> /dev/null && pwd )

function dir_exist_check() {
    # if this dir exists then don't want to overwrite so produce warning for user to delete if necessary
    if [ -d "$1" ]; then
        echo "$1 files exist. Please delete the '$SCRIPT_DIR$1' directory and try again."
        exit 1
    fi
}

function check_benchmark() {
    # if the new XSPEC is being tested then benchmark should exist already
    # Note: both 'benchmark' and 'new'should be exactly the same structure etc. However, the 'new'will just be compared to 'benchmark' at the end
    if [ -d $1 ]; then
    else
        echo "Benchmark files do not exist. Please try to populate benchmark files in the '$SCRIPT_DIR' directory by running as './test_new_heasoft_install.sh benchmark' first and try again."
        exit 1
    fi
}

BEGIN_STATEMENT="HEASoft should already be initialised by you, "
# run as ./test_new_heasoft_install.sh -h and the $1 here is -h, use flags to either run current HEASoft install or to test files made from new HEASoft configuration against files from the old/current configuration 
if [[ $1 = "benchmark" ]]
then
    # Get benchmark for how HEASoft should be
    TERM_OUTFILE=$SCRIPT_DIR"/run_benchmark_heasoft_install.log"
    HEASOFT_OUTPUT_FILE="/benchmark"
    COMPARE_TO_BENCHMARK="no"
    dir_exist_check $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
    echo $BEGIN_STATEMENT"starting HEASoft install to create cached examples." | tee $TERM_OUTFILE 2>&1
elif [[ $1 = "new" ]]
then
    # Test new configuration
    TERM_OUTFILE=$SCRIPT_DIR"/test_new_heasoft_install.log"
    HEASOFT_OUTPUT_FILE="/new"
    COMPARE_TO_BENCHMARK="yes"
    dir_exist_check $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
    check_benchmark $SCRIPT_DIR"/benchmark"
    echo $BEGIN_STATEMENT"starting HEASoft processing to test against cached examples." | tee $TERM_OUTFILE 2>&1
elif [[ $1 = "help" ]]
then
    echo "A script to test an HEASoft install to a previous one."
    echo "Things to consider:"
    echo "* Make sure you have visited the 'raw_nustar_download' directory and read the 'what2do.txt' file. We need a file _like_ 'w3browse-68892.tar' in this directory containing the raw NuSTAR data (the download of the same data might have a different name, just rename the file)."
    echo "* Make sure your HEASoft install has been sourced ('source $HEADAS/headas-init.sh') and you're in an appropriate Python environment (e.g., 'conda create -n heasoft-test python matplotlib numpy astropy' and check with 'which python3')."
    echo "* Make sure this script has appropriate permissions to run (e.g., 'chmod 775 ./test_new_heasoft_install.sh'), although how you could see this and this instruction still being useful is beyond me."
    echo ""
    echo "Run as './test_new_heasoft_install.sh benchmark':\n   * It will run HEASoft on your current configuration and store the outputs to then compare with a new, future HEASoft configuration (must be run first)."
    echo "Run as './test_new_heasoft_install.sh new':\n   * It will compare the previous results to those obtained from the new currently installed HEASoft."
    echo "If you want the XSPEC results printed to the screen after the testing then include 'print-result';\n   *I.e., './test_new_heasoft_install.sh benchmark print-result' or './test_new_heasoft_install.sh new print-result'."
    echo "Whichever test is being run, make sure the corresponding directory (new or benchmark) doesn't already exist as the code will produce a message and not run otherwise."
    echo "The new or benchamrk directory will be created from the 'replacement_directory' folder."
    echo "Note, the result is logged in the log file regardless whether they are printed to the screen and benchmark must be run first."
    exit 1
else
    echo "Please run './test_new_heasoft_install.sh help' or just go with the following."
    echo "Run as either:\n   *'./test_new_heasoft_install.sh benchmark' to populate folder with a \"standard\" HEASoft run.\n   *'./test_new_heasoft_install.sh new' to test new HEASoft against the \"standard\" HEASoft."
    echo "To print the XSPEC result instead of it just being shown in the log-file, include 'print-result':\n   *'./test_new_heasoft_install.sh benchmark print-result' or,\n   *'./test_new_heasoft_install.sh new print-result'."
    echo "Note, the benchmark must be run first."
    exit 1
fi

# add some stuff to terminal and log files
echo "Testing will be based on the succesful execution of the code and final XSPEC results." | tee -a $TERM_OUTFILE 2>&1
echo "Run Date & Time: "$(date +%d.%m.%y-%H:%M:%S) | tee -a $TERM_OUTFILE 2>&1

#  only need dir structure so instead of selecting specific files to keep just delete all and replace with the bones of the structure again
echo "\n\n" >> $TERM_OUTFILE 2>&1
cp -R $SCRIPT_DIR"/replacement_directory" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
echo "\n\n" >> $TERM_OUTFILE 2>&1

# \e[<fg_bg>;5;<ANSI_color_code>m
# colour for foreground (<fg_bg>=38) or to the background (<fg_bg>=48)
# <ANSI_color_code> if 0--255
DEFAULT_C="\e[0m"
RUNNING_C="\e[48;5;30m"
PASSED_C="\e[48;5;10m"
FAILED_C="\e[48;5;9m"

function test_line() {
    ## save me from writing out running/passed/failed and file management all the time
 
    # make sure to know what is running, coloured output in terminal but no mess in file then have two lines
    echo "Test$3:$1 - "$DEFAULT_C$RUNNING_C"Running"$DEFAULT_C 
    echo "Test$3:$1 - Running" >> $TERM_OUTFILE 2>&1
    echo "COMMAND:\n    $2" >> $TERM_OUTFILE 2>&1
    echo "OUTPUT:" >> $TERM_OUTFILE 2>&1
    echo $4 >> $TERM_OUTFILE 2>&1

    # $2 can be multiple separated inputs (e.g., 'command -flags inputs') so eval
    # dump output to file with warnings and all
    # update terminal string (blah - Running) to either 'blah - Passed' or 'blah - Failed', if failed then terminate the test
    eval $2 >> $TERM_OUTFILE 2>&1 && EXIT_VALUE=0 || EXIT_VALUE=1

    if [[ $EXIT_VALUE = 0 ]]
    then
        echo -e "\e[1A\e[KTest$3:$1 - "$DEFAULT_C$PASSED_C"Passed"$DEFAULT_C 
        echo "Test$3:$1 - Passed" >> $TERM_OUTFILE 2>&1
    else
        echo -e "\e[1A\e[KTest$3:$1 - "$DEFAULT_C$FAILED_C"Failed"$DEFAULT_C
        echo "Test$3:$1 - Failed" >> $TERM_OUTFILE 2>&1
    fi

    # add spaces at the end of the dump output into the text file
    echo "\n\n\n" >> $TERM_OUTFILE 2>&1
    return $EXIT_VALUE
}

function normal_line() {
    # save normal lines to the output file and run them
    echo "$@">> $TERM_OUTFILE 2>&1
    $@ >> $TERM_OUTFILE 2>&1
}
function normal_lines_end() {
    # normal lines only separated by one \n so add this to the end of them all
    echo "\n\n" >> $TERM_OUTFILE 2>&1
}

# set up some file names, hard coded the now
DOWNLOADED_DATA="w3browse-68892.tar"
TIME_INTERVAL_FILE="time_gti"
REGION_FILE="reg_fpm"
OBSID="80414202001"

# some other variables
STATUSEXPR="STATUS==b0000xx00xx0xx000"
FIRST_FILES_DIR=$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/2-nuproducts-test"
MOVING_STUFF_LINE="Moving stuff around, beep beep."

# start by moving the data over, unzipping it ready to be used in HEASoft
echo $MOVING_STUFF_LINE >> $TERM_OUTFILE 2>&1
normal_line cd $FIRST_FILES_DIR
normal_line cp "../../raw_nustar_download/$DOWNLOADED_DATA" "./"
normal_line tar -xf $DOWNLOADED_DATA
normal_line gunzip -r $OBSID
normal_line rm $DOWNLOADED_DATA 
normal_line cd $OBSID 
normal_lines_end

# test nupipeline
test_line "Get orbit and CHU EVT files (nupipeline)" "nupipeline obsmode=SCIENCE_SC indir=$FIRST_FILES_DIR/$OBSID steminputs=nu$OBSID outdir=event_cl entrystage=1 exitstage=2 pntra=OBJECT pntdec=OBJECT statusexpr=$STATUSEXPR cleanflick=no hkevtexpr=NONE clobber=yes runsplitsc=yes splitmode=STRICT" 1

# move directory to where the event files are
normal_line cd "./event_cl"

# screen the event files, testing nuscreen
test_line "Screen counts to grade 0 (FPMA, nuscreen)" "nuscreen infile=nu"$OBSID"A06_cl.evt gtiscreen=no evtscreen=yes gtiexpr=NONE gradeexpr=0 statusexpr=NONE outdir="$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/ hkfile=./nu"$OBSID"A_fpm.hk outfile=nu"$OBSID"A06_cl_grade0.evt" 2a
test_line "Screen counts to grade 0 (FPMB, nuscreen)" "nuscreen infile=nu"$OBSID"B06_cl.evt gtiscreen=no evtscreen=yes gtiexpr=NONE gradeexpr=0 statusexpr=NONE outdir="$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/ hkfile=./nu"$OBSID"B_fpm.hk outfile=nu"$OBSID"B06_cl_grade0.evt" 2b

# get ready to filter with time and space so move the files needed to de-clutter
echo $MOVING_STUFF_LINE >> $TERM_OUTFILE 2>&1
normal_line cp "./nu"$OBSID"_att.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"_mast.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"A_fpm.hk" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"A_det1.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"A_oa.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"B_fpm.hk" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"B_det1.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cp "./nu"$OBSID"B_oa.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_line cd $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/3-nuscreen-test/"
normal_lines_end

# filter w.r.t. time and space, testing nuproducts
test_line "Filter to time and region (FPMA, nuproducts)" "nuproducts indir=./ instrument=FPMA steminputs=nu"$OBSID" outdir=../4-nuproducts-timeAndSpaceSelection-test/ extended=no runmkarf=yes runmkrmf=yes infile=nu"$OBSID"A06_cl_grade0.evt bkgextract=no srcregionfile=../../analysis_selections/region/"$REGION_FILE"a.reg  attfile=./nu"$OBSID"_att.fits hkfile=./nu"$OBSID"A_fpm.hk usrgtifile=../../analysis_selections/good_time_interval/"$TIME_INTERVAL_FILE".fits" 3a
test_line "Filter to time and region (FPMB, nuproducts)" "nuproducts indir=./ instrument=FPMB steminputs=nu"$OBSID" outdir=../4-nuproducts-timeAndSpaceSelection-test/ extended=no runmkarf=yes runmkrmf=yes infile=nu"$OBSID"B06_cl_grade0.evt bkgextract=no srcregionfile=../../analysis_selections/region/"$REGION_FILE"b.reg  attfile=./nu"$OBSID"_att.fits hkfile=./nu"$OBSID"B_fpm.hk usrgtifile=../../analysis_selections/good_time_interval/"$TIME_INTERVAL_FILE".fits" 3b

# take the spectral files outputted and move them to another directory
echo $MOVING_STUFF_LINE >> $TERM_OUTFILE 2>&1
normal_line cd $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/4-nuproducts-timeAndSpaceSelection-test/"
normal_line cp "./nu"$OBSID"A06_cl_grade0_sr.pha" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cp "./nu"$OBSID"A06_cl_grade0_sr.arf" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cp "./nu"$OBSID"A06_cl_grade0_sr.rmf" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cp "./nu"$OBSID"B06_cl_grade0_sr.pha" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cp "./nu"$OBSID"B06_cl_grade0_sr.arf" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cp "./nu"$OBSID"B06_cl_grade0_sr.rmf" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_line cd $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/5-xspec-test/"
normal_lines_end

# fit the data, testing XSPEC
test_line "Run XSPEC code (xspec)" "python3 runXspec.py" 4 "See log files in "$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"5-xspec-test directory."

# take the products from fitting, read to be plotted
echo $MOVING_STUFF_LINE >> $TERM_OUTFILE 2>&1
normal_line cp "./mod_apec1fit_fpma_cstat.txt" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cp "./mod_apec1fit_fpma_cstat.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cp "./mod_apec1fit_fpmb_cstat.txt" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cp "./mod_apec1fit_fpmb_cstat.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cp "./mod_apec1fit_fpmab_cstat.txt" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cp "./mod_apec1fit_fpmab_cstat.fits" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_line cd $SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/6-xspec-test-result/"
normal_lines_end

# plot the fits to the data, testing the output of xspec makes sense
test_line "Plot XSPEC result (xspec)" "python3 plotXspec.py" 5 "See plots in "$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"6-xspec-test-result directory."

# record the results other than just in the plots, can output to terminal too if 'print-result'is given too
XSPEC_RESULT_LINE="XSPEC Results:"
if [[ $COMPARE_TO_BENCHMARK = "yes" ]]
then
    # compare the 'new' HEASoft install to the benchark
    echo $XSPEC_RESULT_LINE >> $TERM_OUTFILE 2>&1
    normal_line python3 "getXspecParameters.py"  "compare"
    normal_lines_end
    if [[ $2 = "print-result" ]]
    then
        echo $XSPEC_RESULT_LINE 
        python3 "getXspecParameters.py" "compare"
    fi
else
    # Just run the benchmark so nothing to compare to
    echo $XSPEC_RESULT_LINE >> $TERM_OUTFILE 2>&1
    normal_line python3 "getXspecParameters.py" "no-compare"
    normal_lines_end
    if [[ $2 = "print-result" ]]
    then
        echo $XSPEC_RESULT_LINE 
        python3 "getXspecParameters.py" "no-compare"
    fi
fi

# final line
echo "Finished testing. Now get sciencing if all the tests passed!" | tee -a $TERM_OUTFILE 2>&1
