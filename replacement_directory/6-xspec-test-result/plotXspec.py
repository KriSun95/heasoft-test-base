import matplotlib.pyplot as plt

from plots import plotXspec_allTogether


if __name__=="__main__":
    # run plot
    xspec_output = ["./mod_apec1fit_fpma_cstat",
                    "./mod_apec1fit_fpmb_cstat",
                    "./mod_apec1fit_fpmab_cstat",
                    ]

    fitting_mode = ["1apec",
                    "1apec",
                    "1apec",
                    ]
    fitting_ranges = [[[2.5,7.4]],
                      [[2.5,7.0]],
                      [[2.5,7.4]],
                        ]

    for xo, fm, fr in zip(xspec_output, fitting_mode, fitting_ranges):
        fig, axs = plt.subplots(figsize=(5,7))
        plotXspec_allTogether(xo, fm, fitting_ranges=fr, x_lim=[2,8], y_lim=[1e-1,3e3])
        plt.savefig(xo+".pdf", bbox_inches="tight")
        plt.close()


    