import numpy as np
from scipy import *
import subprocess
import time

#VMD generation of nanotube and periodic boundary conditions
def tubeGen(inFile, outFile, l, n, m):
	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(['vmd','-dispdev', 'none'], stdin=subprocess.PIPE)

	# runs CNTtools.tcl script to generate nanotube and generate PBCs
	CNTtools = 'package require CNTtools 1.0\n'
	genNT = 'genNT '+inFile+' '+str(l)+' '+str(n)+' '+str(m)+'\n'
	pbcNT = 'pbcNT '+inFile+' '+outFile+' default\n'

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
def getCNTBasis(outFile):
	basisFile = open(filename+'-prebond.pdb','r')
	basisLines = basisFile.readlines()
	basisFile.close()

	basis = basisLines[0].split(" ")
	xVec = eval(basis[2])
	yVec = eval(basis[4])
	zVec = eval(basis[6])
	
	return xVec, yVec, zVec

def simWrite(outFile, output = None, temp = None):
	x,y,z = getCNTBasis(filename)

	if temp is None:
		temp = 300
	if output is None:
		output = 'sim_short'

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


def main(inFile,outFile,l,n,m):
	tubeGen(inFile,outFile,l,n,m)


