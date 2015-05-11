import numpy as np
from scipy import *
import subprocess
import time
## PARAMETERS
FILENAME = 'test'

# Opening a pipe to VMD in the shell
VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

# Commands as string inputs to run into the subprocess VMDin
packages = 'package require nanotube\n'
nanotube = 'nanotube -l 10 -n 4 -m 4\n'
selectAll = 'set all [ atomselect top all ]\n'
writePsf = '$all writepsf '+FILENAME+'.psf\n'
writePdb = '$all writepdb '+FILENAME+'.pdb'

# Sending the commands to the VMDin subprocess 
# (figure out way to put above commands in script and run script through subprocess)
VMDin.communicate(input=packages + nanotube + selectAll + writePsf + writePdb)

#When VMD is finished running, close VMD
if VMDin.returncode==0:
	print "finished"

