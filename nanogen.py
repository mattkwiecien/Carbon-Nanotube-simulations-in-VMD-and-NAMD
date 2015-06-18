import numpy as np
from scipy import *
import subprocess
import time

#VMD generation of nanotube and periodic boundary conditions
def tubeGenerator(fileIn, fileOut, l, n, m):
	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

	# runs CNTtools.tcl script to generate nanotube and generate PBCs
	CNTtools = 'package require CNTtools 1.0\n'
	genNT = 'genNT '+fileIn+' '+str(l)+' '+str(n)+' '+str(m)+'\n'
	pbcNT = 'pbcNT '+fileIn+' '+fileOut+' default\n'

	# run commands through pipe and saves to file
	VMDin.stdin.write(sourceCNT)
	VMDin.stdin.write(CNTtools)
	VMDin.stdin.write(genNT)
	VMDin.stdin.write(pbcNT)

	# finished creating periodic nanotubes in VMD
	VMDin.stdin.flush()
	VMDin.stdin.close
	VMDin.communicate()
	if VMDin.returncode==0:
		print "finished"

# find cell basis
# def cellBasis(filename):
# 	basisFile = open(filename+'_basis.txt','r')
# 	basisLines = basisFile.readlines()
# 	basisFile.close()

# 	xVec = eval(basisLines[0].strip("{\n"))
# 	yVec = eval(basisLines[1].strip("\n"))
# 	zVec = eval(basisLines[2].strip("\n"))
	
# 	return xVec, yVec, zVec

def simulationWriter(filename, output = None, temp = None, basis = None):
	if temp is None:
		temp = 300
	if output is None:
		output = 'sim_short_fixed'
	if basis is None:
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


