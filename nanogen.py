import numpy as np
from scipy import *
import subprocess
import time

#VMD generation of nanotube and periodic boundary conditions?
def tubeGenerator(filename):
	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

	# Commands as string inputs to run into the subprocess VMDin
	package1 = 'package require nanotube\n'
	package2 = 'package require pbctools\n'
	nanotube = 'nanotube -l 10 -n 4 -m 4\n'

	box = 'pbc box -on\n'
	boxCenter = 'pbc box -center com\n'
	basisFile = 'set out [open '+filename+'_basis.txt w]\n'
	basisWrite = 'foreach n [split $cell " "] {puts $out $n}\n'
	basisClose = 'close $out\n'

	wrap = 'pbc wrap -center com\n'

	selectAll = 'set all [ atomselect top all ]\n'
	writePsf = '$all writepsf '+filename+'.psf\n'
	writePdb = '$all writepdb '+filename+'.pdb\n'


	VMDin.stdin.write(package1)
	VMDin.stdin.write(package2)
	VMDin.stdin.write(nanotube)

	VMDin.stdin.write(box)
	VMDin.stdin.write(boxCenter)
	VMDin.stdin.write(basisFile)
	VMDin.stdin.write(basisWrite)
	VMDin.stdin.write(basisClose)
	VMDin.stdin.write(wrap)

	VMDin.stdin.write(selectAll)
	VMDin.stdin.write(writePsf)
	VMDin.stdin.write(writePdb)

	# finished creating periodic nanotubes in VMD
	VMDin.stdin.flush()
	VMDin.stdin.close
	VMDin.communicate()
	if VMDin.returncode==0:
		print "finished"

#finds cell basis
def cellBasis(filename):
	basisFile = open(filename+'_basis.txt','r')
	basisLines = basisFile.readlines()
	basisFile.close()

	xVec = eval(basisLines[0].strip("{\n"))
	yVec = eval(basisLines[1].strip("\n"))
	zVec = eval(basisLines[2].strip("\n"))
	
	return xVec, yVec, zVec

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


