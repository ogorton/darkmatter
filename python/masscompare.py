import os
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import runCustomControl

exec_name = "../src/darkmatter.x"

# This script works by replacing MASS_KEYWORD with the desired value of the
# WIMP mass, then running the code with a control file "si28.control".

control_template = "xe131.control" # Filename ends in .template, this is the prefix.
inputfile = 'input.xe131'
workdir = os.getcwd()
label = "xe131"
# Where to find the resulting event rate spectra:
resultfile = "eventrate_spectra.dat"

plt.figure()

for wimp_mass in (7., 50., 500.):

    param_dict = { "MASS_KEYWORD" : wimp_mass }
    RecoilE, EventRate = runCustomControl.runCustomControl(exec_name, inputfile, control_template, param_dict,
        workdir, label)

    plt.plot(RecoilE, EventRate, label="$m_\chi=$%2.2f"%wimp_mass)

plt.xlabel("Recoil energy [kev]")
plt.ylabel("Event rate")
plt.yscale('log')
plt.xscale('log')
plt.legend()
plt.savefig("%s.WIMPmassCompare.pdf"%label)
plt.show()
