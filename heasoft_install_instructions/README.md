# HEASoft Installation & Set-up Help

<span>&#x1f6a7;</span>_The information here is purely from my own notes and may or may not help someone else._<span>&#x1f6a7;</span> 

For my uses, this means:

- I only require the tools for NuSTAR and Xspec.
- This is on a Mac M1
- I use the `zsh`
  - Others might use `bash`, `csh`, or other

## Installing HEASoft

**Before starting**, DO NOT remove the source (src) HEASoft folder/files at any point, they are needed to update Xspec and alike.

- This is not made clear until going to update Xspec. Therefore, it is probably best to move the source file to the install location so it stays out the road.
- See [here](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/uninstall.html) to uninstall HEASoft if you have to. (AHHHHHHH!)

**Additionally**, you might have to recursively change the permissions of the directroy you want to place the HEASoft install while building it. **Remember to change permissions back**.

After larger system OS updates, I've found I have had to re-install HEASoft (but not CALDB for perhaps obvious reasons).

### Starting

Go to the [information page](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/).

Navigate to the MacOS HEASoft [installation page](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/macos.html) and also [download the software](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/download.html).

The following instructions are from the above links and I've tried to include the real example code lines I have used for easier/additional reference.

### To download

1. Select `Source Code`
   - (On Mac, find Darwin version with `uname -a` or `uname -r`)
2. Select `NuSTAR` and `Xspec`, this will also select all necessary packages as well.
   - Hit `Submit` and wait for it to download (2.5–4 GB)
   - Follow instructions; e.g., to apply patches to Xspec open new tab with patches and come back once all installed, etc.
3. Make sure to have prerequisites
   - [X11](https://www.xquartz.org), Xcode/Homebrew for compilers, do not `sudo install` things like the instructions say.
     - `xcode-select --install`
     - `brew install gcc@12`
     - `brew install libpng`
4. Put the following (or equivalent) at the END of your .zshrc (or equivalent) file:

```bash
## for HEASoft
# set /usr/bin ahead of all other paths
export PATH="/usr/bin:$PATH"
# unset any flags set by other software
unset CFLAGS CXXFLAGS FFLAGS LDFLAGS build_alias
# compilers
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
export PERL=/usr/bin/perl
export FC=/opt/homebrew/bin/gfortran-12
export PYTHON=$HOME/miniconda3/bin/python3
```

5. In base Python (can remove later) do `conda install astropy numpy scipy pip`
   - The Python version linked could be a virtual environment I believe
6. **Check compilers (etc.) are working and exist**, check the variables (export) names
   - E.g., `echo $CC` or `echo $CXX`, etc. in the terminal
7. Change to directory with the src directory in it (e.g., `cd /usr/local/heasoft`)
    - This is where I decided to store my installation and is what might require the permission to be recursively changed.
8. Unzip it (e.g., `tar -zxf heasoft-6.31.1src.tar`)
9.  Change directory into the BUILD_DIR folder (e.g., `cd heasoft-6.31.1/BUILD_DIR`)
10. Configure time
    - E.g., `./configure --with-png=/opt/homebrew --prefix=/usr/local/heasoft/heasoft-6.31.1`
    - **I threw the output into a file** with `./configure --with-png=/opt/homebrew --prefix=/usr/local/heasoft/heasoft-6.31.1 > /Users/kris/Documents/umnPostdoc/documents/howTo/heasoft/1-installingHEASoft-config.txt  2>&1` 
      - and we get a healthy handful of warnings.
11. Now for make-time
    - E.g., `make > /Users/kris/Documents/umnPostdoc/documents/howTo/heasoft/1-installingHEASoft-build.log 2>&1`
       - Again, throwing the terminal output to a file (this can take a while).
12. Finally install
    - E.g., `make install > /Users/kris/Documents/umnPostdoc/documents/howTo/heasoft/1-installingHEASoft-install.log 2>&1`
13. May have to change permissions of the init file to give user privileges
    - `chmod 775 aarch64-apple-darwin22.3.0/headas-init.sh`
14. And add the equivalent of the following to the shell file

```bash
# HEASoft
export HEADAS="/usr/local/heasoft/heasoft-6.31.1/aarch64-apple-darwin22.3.0"
alias gohea="source $HEADAS/headas-init.sh"
```

Now we can move onto

1. Downloading and setting up CALDB
   - See **Installing CALDB** section or [installation page](https://heasarc.gsfc.nasa.gov/docs/heasarc/caldb/install.html)
2. Updating Xspec
   - See **Updating Xspec** section or [installation page](https://heasarc.gsfc.nasa.gov/xanadu/xspec/python/html/buildinstall.html).

## Installing CALDB

Go to [installation page](https://heasarc.gsfc.nasa.gov/docs/heasarc/caldb/install.html) for instructions.

1. Set an environment variable for the CALDB directory
   - In .zshrc file (or equivalent) set `export CALDB=“/usr/local/caldb”`
2. Make and go to the directory $CALDB
   - E.g., `sudo mkdir /usr/local/caldb && cd $CALDB`
   - Use `sudo` because of the directory we’ve chosen to install in if you're lazy like me
       - Would be better temporarily recursively editing permissions to the folder chosen
3. Download the tar file and extract it all in the directory we’ve just set up
   1. `sudo wget https://heasarc.gsfc.nasa.gov/FTP/caldb/software/tools/caldb_setup_files.tar.Z`
   2. `sudo tar -zxvf caldb_setup_files.tar.Z`
4. Now go into the directory and find the appropriate shell init script
   - `$CALDB/software/tools/caldbinit.sh` or equivalent
   - Open it in a text editor and change the top (commented out) lines from

```bash
#CALDB=/FTP/caldb; export CALDB
#CALDBCONFIG=$CALDB/software/tools/caldb.config; export CALDBCONFIG
#CALDBALIAS=$CALDB/software/tools/alias_config.fits; export CALDBALIAS
```

to

```bash
CALDB=/usr/local/caldb; export CALDB
CALDBCONFIG=$CALDB/software/tools/caldb.config; export CALDBCONFIG
CALDBALIAS=$CALDB/software/tools/alias_config.fits; export CALDBALIAS
```

_Note that only the top line has changed._

If HEASoft is installed then this allows you to access CALDB, no need to source the shell script manually for CALDB.

- I.e., if we `gohea` the can access CALDB with commands like `caldbinfo` and such after following the **Installing HEASoft** section.

### Downloading calibration data

1. Go back to the $CALDB directory
2. Go to [mission calibration list](https://heasarc.gsfc.nasa.gov/docs/heasarc/caldb/caldb_supported_missions.html) for a list of mission calibration files.
3. Download the `goodfiles_<mission>_<instrument>_tar.Z` files you want and unpack them
   - This may include patch files too, this will make a data folder with stuff in it.

For example:

```bash
cd $CALDB
tar -zxvf goodfiles_nustar_fpm.tar
tar -zxvf goodfiles_nustar_fpm_clockcor.tar
rm -i goodfiles_nustar_fpm*.tar
```

These files may also end in `.tar.Z`.

Can, and **should**, then check this has all worked properly with `caldbinfo INST <mission> <instrument>`

- `caldbinfo INST NuSTAR FPM` here

## Updating Xspec

Go to [instructions page](https://heasarc.gsfc.nasa.gov/docs/software/heasoft/xanadu/xspec/issues/issues.html) for instructions (if you can believe it).

Download the patch installer `patch_install_4.16.tcl` to `…heasoft.6.31.1/Xspec/src`.

- See the **Installing HEASoft** section for this location

Then download the latest patch file (something like `Xspatch_121300c.tar`) to the `…heasoft.6.31.1/Xspec/src` directory. 

Now, in the same directory, run `tclsh patch_install_4.16.tcl`.
