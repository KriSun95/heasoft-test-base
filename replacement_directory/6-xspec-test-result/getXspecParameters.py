import sys

from plots import xspecParams


if __name__=="__main__":
    # run plot
    _param_files = ["mod_apec1fit_fpma_cstat",
                    "mod_apec1fit_fpmb_cstat",
                    "mod_apec1fit_fpmab_cstat",
                    ]

    print("\n")

    for _pf in _param_files:
        _to_check = ['STATISTIC', 'factor', 'gainSlope', "normalisation", "temperature", "break", "photonindex"]
        fitting_values = xspecParams(f"./{_pf}.fits", *_to_check)
        _fitting_values = {param:value[0] for (param,value) in fitting_values.items() if ((not param.startswith("E")) and (param not in ["emfact",'kev2mk']))}

        _l = 20
        _space = " "*10

        if str(sys.argv[1])=="compare":
            bench_fitting_values = xspecParams(f"../../{sys.argv[2]}/6-xspec-test-result/{_pf}.fits", *_to_check)
            _bench_fitting_values = {param:value[0] for (param,value) in bench_fitting_values.items() if ((not param.startswith("E")) and (param not in ["emfact",'kev2mk']))}
            print(f"{_pf}.fits result:")
            print("Param".ljust(_l//2)+_space+"Benchmark".ljust(_l)+_space+"New".ljust(_l))
            for p in _bench_fitting_values.keys():
                print(f"{p.ljust(_l//2)}:{_space}{str(_bench_fitting_values[p]).ljust(_l)}{_space}{str(_fitting_values[p]).ljust(_l)}")
            print("\n")
        else:
            print(f"{_pf}.fits result:")
            print("Param".ljust(_l//2)+_space+"Benchmark".ljust(_l))
            for p in _fitting_values.keys():
                print(f"{p.ljust(_l//2)}:{_space}{str(_fitting_values[p]).ljust(_l)}")
            print("\n")
            print("\n")

