import matplotlib.pyplot as plt

from subprocessXspec import XSPECfit


if __name__=="__main__":
    # run fit
        
    # paths to the directories with the .xcm file I want to run
    directories = ["./",
                   "./",
                   "./",
                    ]
    # the .xcm file that is in the corresponding directories entry
    xspecBatchFiles = ["apec1fit_fpma_cstat.xcm",
                       "apec1fit_fpmb_cstat.xcm",
                       "apec1fit_fpmab_cstat.xcm"
                        ]

    # run the .xcm files in the appropriate directory while creating a log file of each run and removing any .log, .fits, .txt files that may 
    # already be there with the same name as the output files of this code
    XSPECfit(directory=directories, xspecBatchFile=xspecBatchFiles, logFile=True, overwrite=True)
