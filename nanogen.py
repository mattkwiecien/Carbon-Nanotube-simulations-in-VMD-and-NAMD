import numpy as np
from scipy import *
import subprocess
import time

#VMD generation of nanotube and periodic boundary conditions?
def tubeGenerator(filename):
	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

	# Commands as string inputs to run into the subprocess VMDin
	packages = 'package require nanotube\n'
	nanotube = 'nanotube -l 10 -n 4 -m 4\n'
	selectAll = 'set all [ atomselect top all ]\n'
	writePsf = '$all writepsf '+filename+'.psf\n'
	writePdb = '$all writepdb '+filename+'.pdb\n'


	# ## Not working... need gui?
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

#Generates periodic boundary conditions to join the top of a nanotube to the bottom of a nanotube
def bondGen():
	


def simulationWriter(filename, output = None, temp = None, basis = None):
	if temp is None:
		temp = 300
	if output is None:
		output = 'sim_short_fixed'
	if basis = None:
		basis = []

	#Read in lines of simulation file
	inFile = open('sim_short.conf','r')
	simLines = inFile.readlines()
	inFile.close()

	simLines[11] = 'structure          '+filename+'-per.psf\n'
	simLines[12] = 'coordinates        '+filename+'-per.pdb\n'
	simLines[14] = 'set temperature    '+str(temp)+'\n'
	simLines[15] = 'set outputname     '+output+'\n'

	#Write contents out to original file
	outFile = open('sim_short.conf','w')
	outFile.writelines(simLines)
	outFile.close()


def main(filename):
	tubeGenerator(filename)


