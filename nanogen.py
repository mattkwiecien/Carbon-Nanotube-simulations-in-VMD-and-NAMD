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
writePdb = '$all writepdb '+FILENAME+'.pdb\n'
### Not working... need gui?
periodic = 'mol new {'+FILENAME+'.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
loop = 'animate style Loop'
periodic2 = 'mol addfile {'+FILENAME+'.psf} type {psf} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
periodic3 = 'mol addfile {'+FILENAME+'.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
periodic4 = 'animate write psf {'+FILENAME+'-per-prebond.psf} beg 0 end 0 skip 1\n'
periodic5 = 'animate write pdb {'+FILENAME+'-per-prebond.pdb} beg 0 end 0 skip 1\n'
periodic6 = 'mol new {'+FILENAME+'-per.psf} type {psf} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
periodic7 = 'mol addfile {'+FILENAME+'-per.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0'

# Sending the commands to the VMDin subprocess 
# (figure out way to put above commands in script and run script through subprocess)
VMDin.communicate(input=packages + nanotube + selectAll + writePsf + writePdb + periodic + periodic2 + periodic3 + periodic4 + periodic5 + periodic6)
time.sleep(10)
#When VMD is finished running, close VMD
if VMDin.returncode==0:
	print "finished"

