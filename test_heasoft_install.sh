#!/bin/zsh

# may need to: conda create -n heasoft-test python matplotlib numpy astropy
# and also: chmod 775 ./test_heasoft_install.sh

# run ./test_heasoft_install.sh help
# A script to test an HEASoft install to a previous one. 
# Run as `./test_heasoft_install.sh benchmark`
#       It will run HEASoft on your current configuration and store the outputs to then compare with a new, future HEASoft configuration.
# Run as `./test_heasoft_install.sh new`
#       It will compare the previous results to those obtained from the new currently installed HEASoft.
# If you want the XSPEC results printed to the screen after the testing then include 'print-result'; 
#       I.e., `./test_heasoft_install.sh benchmark print-result` or `./test_heasoft_install.sh new print-result`.
# The result is logged in the log file regardless whether they are printed to the screen.

#  change to the main directory to work in
SCRIPT_DIR=$( cd -- "$( dirname -- "${(%):-%N}" )" &> /dev/null && pwd )

# set up some defaults
TIME_INTERVAL_FILE=$SCRIPT_DIR"/analysis_selections/good_time_interval/time_gti.fits"
REGION_FILEA=$SCRIPT_DIR"/analysis_selections/region/reg_fpma.reg"
REGION_FILEB=$SCRIPT_DIR"/analysis_selections/region/reg_fpmb.reg"
OBSID="80414202001"
BENCHMARK_DIR="/benchmark"
BENCHMARK_DIR_EXT=""
COMPARE_TO_BENCHMARK="no"
PRINT_XSPEC_RESULT=0

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
        echo "Benchmark files do not exist. Please try to populate benchmark files in the"
        echo "'$SCRIPT_DIR'"
        echo "Run path/to/test_heasoft_install.sh with -h or --help for instructions."
        exit 1
    fi
}

BEGIN_STATEMENT="HEASoft should already be initialised by you, "

function usage() {
    echo ""
    echo "A script to test an HEASoft install to a previous one."
    echo ""
    echo "Things to consider:"
    echo " * Make sure you have visited the 'raw_nustar_download' directory and read the"
    echo "   'what2do.txt' file. We need a file _like_ 'w3browse-68892.tar' in this directory"
    echo "   containing the raw NuSTAR data (the download of the same data might have a"
    echo "   different name, just rename the file)."
    echo " * Make sure your HEASoft install has been sourced ('source /path/to/headas-init.sh')"
    echo "   and you're in an appropriate Python environment, e.g.,"
    echo "   'conda create -n heasoft-test python matplotlib numpy astropy' and check with"
    echo "   'which python3')."
    echo " * Make sure this script has appropriate permissions to run (e.g.,"
    echo "   'chmod 775 ./test_heasoft_install.sh'), although how you could see this and"
    echo "   this instruction still being useful is beyond me."
    echo ""
    echo "Whichever test is being run, make sure the corresponding directory (new or benchmark)"
    echo "doesn't already exist as the code will produce a message and not run otherwise."
    echo ""
    echo "The new or benchamrk directory will be created from the 'replacement_directory' folder."
    echo ""
    echo "Note: The result is logged in the log file regardless whether they are printed to the"
    echo "screen and benchmark must be run first."
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> [OPTIONS]"
    echo ""
    echo "Options:"
    echo " -h ,  --help                Display this help message"
    echo " -b*, --benchmark*           Define a benchmark run should be performed or folder"
    echo "                             name suffix to benchmark<suffix> to be used as a"
    echo "                             benchmark"
    echo "                                 - Default is \"benchmark\""
    echo "                                 - If given an arument then it will be appended to"
    echo "                                   the benchmark folder name."
    echo " -n*, --new*                 Define a new run should be performed"
    echo "                                 - Default is \"new\""
    echo "                                 - If given an arument then it will become the suffix"
    echo "                                   to the new run folder name (i.e., \"new<suffix>\")."
    echo "                                 - If both -b/--benchmark* and -n*/--new* are given"
    echo "                                   then a new run will be performed with the default"
    echo "                                   (or otherwise defined) benchmark folder"
    echo " -g*, --gti-file*            Define a custom GTI file to use"
    echo "                                 - Default is:"
    echo "                                   \"$TIME_INTERVAL_FILE\""
    echo " -ra*, --rega-file*            Define a custom region FPMA file to use"
    echo "                                 - Default is:"
    echo "                                   \"$REGION_FILEA\""
    echo " -rb*, --regb-file*            Define a custom region FPMA file to use"
    echo "                                 - Default is:"
    echo "                                   \"$REGION_FILEB\""
    echo " -o*, --obs-id*              Define a different NuSTAR observation ID"
    echo "                                 - Default is \"80414202001\""
    echo "                                 - Must correspond to the <w3browse-*.tar> file that"
    echo "                                   was downloaded"
    echo " -p , --print-xspec-result   Set that the final Xspec result should be printed"
    echo ""
    echo "Generic Eamples:"
    echo "## Run HEASoft on your current configuration, store the outputs, then compare with a new,"
    echo "## future HEASoft configuration (must be run first)"
    echo "path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -b"
    echo ""
    echo "## Compare previous results to those obtained from the new currently installed HEASoft"
    echo "path/to/test_heasoft_install.sh <path/to/w3browse-*.tar> -n"
    echo ""
    echo "Other Eamples:"
    echo ""
}

function err() {
    echo "Error in use."
    echo "Please run:"
    echo " - 'path/to/test_heasoft_install.sh -h', or"
    echo " - 'path/to/test_heasoft_install.sh --help'."
    exit 1
}

# \e[<fg_bg>;5;<ANSI_color_code>m
# colour for foreground (<fg_bg>=38) or to the background (<fg_bg>=48)
# <ANSI_color_code> if 0--255
DEFAULT_C="\e[0m"
RUNNING_C="\e[48;5;30m"
PASSED_C="\e[48;5;28m"
FAILED_C="\e[48;5;1m"

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

function has_argument() {
    ## check if the flag has a value
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*)  ]];
}

function extract_argument() {
    ## get the value from a flag
    echo "${2:-${1#*=}}"
}

# Function to handle options and arguments
function handle_options() {
    ## handles the optional inputs to the script
    while [ $# -gt 0 ]; do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;
            -b* | --benchmark*)
                if has_argument $@; then
                    BENCHMARK_DIR="/benchmark"$(extract_argument $@)
                    BENCHMARK_DIR_EXT=$(extract_argument $@)
                fi
                ;;
            -n* | --new*)
                # Test new configuration
                COMPARE_TO_BENCHMARK="yes"
                echo $BEGIN_STATEMENT"starting HEASoft processing to test against cached examples." | tee $TERM_OUTFILE 2>&1

                if ! has_argument $@; then
                    HEASOFT_OUTPUT_FILE="/new"
                    TERM_OUTFILE=$SCRIPT_DIR"/run_new_heasoft_install.log"
                else
                    HEASOFT_OUTPUT_FILE="/new"$(extract_argument $@)
                    TERM_OUTFILE=$SCRIPT_DIR"/run_new"$(extract_argument $@)"_heasoft_install.log"
                fi
                dir_exist_check $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
                ;;
            -g* | --gti-file*)
                if ! has_argument $@; then
                    echo "GTI file was not specified." >&2
                    usage
                    exit 1
                fi
                TIME_INTERVAL_FILE=$(extract_argument $@)
                ;;
            -ra* | --rega-file*)
                if ! has_argument $@; then
                    echo "Region FPMA file was not specified." >&2
                    usage
                    exit 1
                fi
                REGION_FILEA=$(extract_argument $@)
                ;;
            -rb* | --regb-file*)
                if ! has_argument $@; then
                    echo "Region FPMB file was not specified." >&2
                    usage
                    exit 1
                fi
                REGION_FILEB=$(extract_argument $@)
                ;;
            -o* | --obs-id*)
                if ! has_argument $@; then
                    echo "Observation ID was not specified." >&2
                    usage
                    exit 1
                fi
                OBSID=$(extract_argument $@)
                ;;
            -p | --print-xspec-result)
                PRINT_XSPEC_RESULT=1
                ;;
        esac
        shift
    done
}

## go through the inputs and set things up
handle_options "$@"

DOWNLOADED_DATA=$1 # "w3browse-68892.tar"
DOWNLOADED_DATA_FILE=$(basename "$DOWNLOADED_DATA")
if [[ $DOWNLOADED_DATA = "" ]] then
    err
fi

# if it's a new run, make sure the benchmark dir being pointed to exists
if [[ $COMPARE_TO_BENCHMARK = "yes" ]] then
    check_benchmark $SCRIPT_DIR$BENCHMARK_DIR
else
    # Get benchmark for how HEASoft should be
    # only want to run this is -n is not given
    TERM_OUTFILE=$SCRIPT_DIR"/run_benchmark"$BENCHMARK_DIR_EXT"_heasoft_install.log"
    echo $BEGIN_STATEMENT"starting HEASoft install to create cached examples." | tee $TERM_OUTFILE 2>&1
    HEASOFT_OUTPUT_FILE=$BENCHMARK_DIR
    dir_exist_check $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
fi

# add some stuff to terminal and log files
echo "Testing will be based on the succesful execution of the code and final XSPEC results." | tee -a $TERM_OUTFILE 2>&1
echo "Run Date & Time: "$(date +%d.%m.%y-%H:%M:%S) | tee -a $TERM_OUTFILE 2>&1

#  only need dir structure so instead of selecting specific files to keep just delete all and replace with the bones of the structure again
echo "\n\n" >> $TERM_OUTFILE 2>&1
normal_line cp -R $SCRIPT_DIR"/replacement_directory" $SCRIPT_DIR$HEASOFT_OUTPUT_FILE
echo "\n\n" >> $TERM_OUTFILE 2>&1

# some other variables
STATUSEXPR="STATUS==b0000xx00xx0xx000"
FIRST_FILES_DIR=$SCRIPT_DIR$HEASOFT_OUTPUT_FILE"/2-nuproducts-test"
MOVING_STUFF_LINE="Moving stuff around, beep beep."

# start by moving the data over, unzipping it ready to be used in HEASoft
echo $MOVING_STUFF_LINE >> $TERM_OUTFILE 2>&1
normal_line cd $FIRST_FILES_DIR
normal_line cp $DOWNLOADED_DATA "./"
normal_line tar -xf $DOWNLOADED_DATA_FILE
normal_line gunzip -r $OBSID
normal_line rm $DOWNLOADED_DATA_FILE
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
test_line "Filter to time and region (FPMA, nuproducts)" "nuproducts indir=./ instrument=FPMA steminputs=nu"$OBSID" outdir=../4-nuproducts-timeAndSpaceSelection-test/ extended=no runmkarf=yes runmkrmf=yes infile=nu"$OBSID"A06_cl_grade0.evt bkgextract=no srcregionfile="$REGION_FILEA" attfile=./nu"$OBSID"_att.fits hkfile=./nu"$OBSID"A_fpm.hk usrgtifile="$TIME_INTERVAL_FILE 3a
test_line "Filter to time and region (FPMB, nuproducts)" "nuproducts indir=./ instrument=FPMB steminputs=nu"$OBSID" outdir=../4-nuproducts-timeAndSpaceSelection-test/ extended=no runmkarf=yes runmkrmf=yes infile=nu"$OBSID"B06_cl_grade0.evt bkgextract=no srcregionfile="$REGION_FILEB" attfile=./nu"$OBSID"_att.fits hkfile=./nu"$OBSID"B_fpm.hk usrgtifile="$TIME_INTERVAL_FILE 3b

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
    normal_line python3 "getXspecParameters.py" "compare" "$BENCHMARK_DIR"
    normal_lines_end
    if [[ $PRINT_XSPEC_RESULT = 1 ]]
    then
        echo $XSPEC_RESULT_LINE 
        python3 "getXspecParameters.py" "compare" "$BENCHMARK_DIR"
    fi
else
    # Just run the benchmark so nothing to compare to
    echo $XSPEC_RESULT_LINE >> $TERM_OUTFILE 2>&1
    normal_line python3 "getXspecParameters.py" "no-compare"
    normal_lines_end
    if [[ $PRINT_XSPEC_RESULT = 1 ]]
    then
        echo $XSPEC_RESULT_LINE 
        python3 "getXspecParameters.py" "no-compare"
    fi
fi

# final line
echo "Finished testing. Now get sciencing if all the tests passed!" | tee -a $TERM_OUTFILE 2>&1
