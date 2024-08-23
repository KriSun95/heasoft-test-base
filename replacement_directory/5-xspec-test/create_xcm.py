import sys

OBSID = sys.argv[1]

apec1fit_fpma_cstat = f"""
########################################################
## Fit one NuSTAR FPM with single thermal APEC model 
## with the new Feld 92A coronal abundances - this is actual solar coronal, unlike "abund feld" in xspec
## Also using c-stat for fitting statistics - best choice when some low count bins
## 
##    Run as @apec1fit_fpm1_cstat.xcm in xspec, but manually need to do the last few lines in iplot
## 
## 18-Jan-2018 IGH Started based on earlier examples, originally coming from BG
## 05-Mar-2019 KC Edited to change the ranges for fit and filename (personal use)
########################################################

## Name of the pha file 
data 1:1 nu{OBSID}A06_cl_grade0_sr.pha

## Use the c-stat for fitting 
statistic cstat

setplot energy

## Fit over 2.5 to 7.4
## for A 
ignore *:0.-2.5 7.4-**

cpd /xw
plot

## Choose APEC for the model, VAPEC basically the same as APEC, but more control over abundances (use "abund" command instead)
## All models here https://heasarc.gsfc.nasa.gov/xanadu/xspec/manual/Models.html
model apec
/*

renorm
## Load in actual coronal abundances - "abund feld" is really photospheric!
abund file feld92a_coronal0.txt
fit 10000

setplot xlog off
plot ldata ratio

## Show free parameters
show free

## Show fit values
show fit

## Want the errors calculated as well?
## By default its 2.706\sig (90% conf) but want 1\sig 
# error 1 4
error 1.0 1 4

## Write out the fit results
## Careful as the following line will apend to this file if it already exists, instead of overwriting it
writefits mod_apec1fit_fpma_cstat.fits


notice *: 1.6-79.0

## Write out the plot of the spectrum and fit
## Need to run the next two lines manually

#iplot ldata ufspec rat
#wdata mod_apec1fit_fpma_cstat.txt
#exit


"""

apec1fit_fpmb_cstat = f"""
########################################################
## Fit one NuSTAR FPM with single thermal APEC model 
## with the new Feld 92A coronal abundances - this is actual solar coronal, unlike "abund feld" in xspec
## Also using c-stat for fitting statistics - best choice when some low count bins
## 
##    Run as @apec1fit_fpm1_cstat.xcm in xspec, but manually need to do the last few lines in iplot
## 
## 18-Jan-2018 IGH Started based on earlier examples, originally coming from BG
## 05-Mar-2019 KC Edited to change the ranges for fit and filename (personal use)
########################################################

## Name of the pha file 
data 1:1 nu{OBSID}B06_cl_grade0_sr.pha

## Use the c-stat for fitting 
statistic cstat

setplot energy

## Fit over 2.5 to 7
## for A 
ignore *:0.-2.5 7.0-**

cpd /xw
plot

## Choose APEC for the model, VAPEC basically the same as APEC, but more control over abundances (use "abund" command instead)
## All models here https://heasarc.gsfc.nasa.gov/xanadu/xspec/manual/Models.html
model apec
/*

renorm
## Load in actual coronal abundances - "abund feld" is really photospheric!
abund file feld92a_coronal0.txt
fit 10000

setplot xlog off
plot ldata ratio

## Show free parameters
show free

## Show fit values
show fit

## Want the errors calculated as well?
## By default its 2.706\sig (90% conf) but want 1\sig 
# error 1 4
error 1.0 1 4

## Write out the fit results
## Careful as the following line will apend to this file if it already exists, instead of overwriting it
writefits mod_apec1fit_fpmb_cstat.fits


notice *: 1.6-79.0

## Write out the plot of the spectrum and fit
## Need to run the next two lines manually

#iplot ldata ufspec rat
#wdata mod_apec1fit_fpmb_cstat.txt
#exit


"""

apec1fit_fpmab_cstat = f"""
########################################################
## Fit two NuSTAR FPM with single thermal APEC model 
## with the new Feld 92A coronal abundances - this is actual solar coronal, unlike "abund feld" in xspec
## Also using c-stat for fitting statistics - best choice when some low count bins
## 
##    Run as @apec2fit_fpm1_cstat_prb.xcm in xspec, but manually need to do the last few lines in iplot
## 
## 18-Jan-2018 IGH Started based on earlier examples from BG
## 05-Mar-2019 KC Edited to change the ranges for fit and filename (personal use)
########################################################

## Name of the pha files
data 1:1 nu{OBSID}A06_cl_grade0_sr.pha 2:2 nu{OBSID}B06_cl_grade0_sr.pha

## Use the c-stat for fitting 
statistic cstat

## Fit over 2.5 to 8
ignore *:0.-2.5 7.4-**

## Plot the data to check it looks ok
setplot energy
cpd /xw
plot

## Choose APEC for the model, VAPEC basically the same as APEC, but more control over abundances (use "abund" command instead)
## All models here https://heasarc.gsfc.nasa.gov/xanadu/xspec/manual/Models.html
## Also have multiplicative const factor to fit for FPMB (covers systematic diff between A and B)
model const*apec
1.0 -0.1
/*

## Only want the constant for FPMB to vary, and independent of FPMA fit
untie 6
thaw 6

renorm
## Load in actual coronal abundances - "abund feld" is really photospheric!
abund file feld92a_coronal0.txt
fit 10000

## Plot the fit to the data
setplot group 1-2
setplot add
setplot xlog off
plot ldata ratio

## Show free parameters
show free

## Show fit values
show fit

## Want the errors calculated as well 
## By default its 2.706\sig (90% conf) but want 1\sig 
#error 2 5 6
error 1.0 2 5 6

## Write out the fit results
## Careful as the following line will apend to this file if it already exists, instead of overwriting it
writefits mod_apec1fit_fpmab_cstat.fits

notice *: 1.6-79.0

## Write out the plot of the spectrum and fit
## Need to run the next two lines manually

#iplot ldata ufspec rat
#wdata mod_apec1fit_fpmab_cstat.txt
#exit


"""

def write_to_xcm(name, contents):
    with open(f"{name}.xcm", "w") as file:
        # Writing data to a file
        file.write(contents)

if __name__=="__main__":
    write_to_xcm("apec1fit_fpma_cstat", apec1fit_fpma_cstat)
    write_to_xcm("apec1fit_fpmb_cstat", apec1fit_fpmb_cstat)
    write_to_xcm("apec1fit_fpmab_cstat", apec1fit_fpmab_cstat)