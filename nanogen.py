import numpy as np
from scipy import *
import subprocess
import time
## PARAMETERS
def tubeGenerator(FILENAME):
	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

	# Commands as string inputs to run into the subprocess VMDin
	packages = 'package require nanotube\n'
	nanotube = 'nanotube -l 10 -n 4 -m 4\n'
	selectAll = 'set all [ atomselect top all ]\n'
	writePsf = '$all writepsf '+FILENAME+'.psf\n'
	writePdb = '$all writepdb '+FILENAME+'.pdb\n'

	### Not working... need gui?
	# periodic = 'mol new {'+FILENAME+'.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
	# loop = 'animate style Loop'
	# periodic2 = 'mol addfile {'+FILENAME+'.psf} type {psf} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
	# periodic3 = 'mol addfile {'+FILENAME+'.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
	# periodic4 = 'animate write psf {'+FILENAME+'-per-prebond.psf} beg 0 end 0 skip 1\n'
	# periodic5 = 'animate write pdb {'+FILENAME+'-per-prebond.pdb} beg 0 end 0 skip 1\n'
	# periodic6 = 'mol new {'+FILENAME+'-per.psf} type {psf} first 0 last -1 step 1 waitfor -1 autobonds 0\n'
	# periodic7 = 'mol addfile {'+FILENAME+'-per.pdb} type {pdb} first 0 last -1 step 1 waitfor -1 autobonds 0'

	VMDin.stdin.write(packages)
	VMDin.stdin.write(nanotube)
	VMDin.stdin.write(selectAll)
	VMDin.stdin.write(writePsf)
	VMDin.stdin.write(writePdb)

	# finished creating periodic nanotubes in VMD
	VMDin.stdin.flush()
	VMDin.stdin.close
	VMDin.communicate()
	if VMDin.returncode==0:
		print "finished"

def main(FILENAME):
	tubeGenerator(FILENAME)


