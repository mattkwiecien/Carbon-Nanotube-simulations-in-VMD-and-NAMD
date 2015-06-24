import numpy as np
from scipy import *
import subprocess
import time
import os

global basePath
basePath = "/Users/nanotubes/Simulations/"

# VMD generation of nanotube and periodic boundary conditions
def tubeGen(inFile, outFile, l, n, m):
	""" tubeGen creates a periodic nanotube with the following input parameters:  inFile 
	is the name of the initial nanotube of length l with dimensions n x m.  outFile is 
	the name of the same nanotube but now with periodic boundary conditions applied to it. """
	
	tubePath = basePath+"cnt"+str(l)+"_"+str(n)+"x"+str(m)+"/"
	pbcPath = tubePath+"PBC/"
	os.system("mkdir "+tubePath)
	os.system("mkdir "+pbcPath)

	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(["vmd","-dispdev", "none"], stdin=subprocess.PIPE)

	# runs CNTtools.tcl script to generate nanotube and generate PBCs
	sourceCNT = "source CNTtools.tcl\n"
	CNTtools = "package require CNTtools 1.0\n"

	genNT = "genNT "+inFile+" "+tubePath+" "+str(l)+" "+str(n)+" "+str(m)+"\n"
	pbcNT = "pbcNT "+tubePath+inFile+" "+pbcPath+outFile+" default\n"

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

def simWrite(CNTfile, temp = 300, length = 20000, output = "sim_fix"):
	""" simWrite generates a .conf file to use as input to namd2.   """
	# Grabs the CNT basis vectors
	x,y,z = getCNTBasis(CNTfile)

	# Read in lines of simulation file
	inFile = open(fpath+"templates/sim_template.conf","r")
	simLines = inFile.readlines()
	inFile.close()

	simLines[11] = "structure          "+CNTfile+".psf\n"
	simLines[12] = "coordinates        "+CNTfile+".pdb\n"
	simLines[14] = "set temperature    "+str(temp)+"\n"
	simLines[15] = "set outputname     "+output+"\n"
	simLines[74] = "fixedAtomsFile      "+CNTfile+".pdb\n"
	simLines[99] = "run "+str(length)+" ;# 10ps\n"

	# Write contents out to original file
	outFile = open(output, "w")
	outFile.writelines(simLines)
	outFile.close()

# def simSaver

# find cell basis
def getCNTBasis(CNT):
	""" getCNTBasis finds the basis of a nanotube with filename outFile. """
	# Opens the CNT prebond file and reads the lines
	basisFile = open(CNT+"-prebond.pdb","r")
	basisLines = basisFile.readlines()
	basisFile.close()

	# Splits the first line of the CNT-prebond file, and finds the x,y,z basis vectors of the CNT 
	basis = basisLines[0].split(" ")
	xVec = eval(basis[2])
	yVec = eval(basis[4])
	zVec = eval(basis[6])
	
	return xVec, yVec, zVec

def main(inFile,outFile,l,n,m):
	tubeGen(inFile,outFile,l,n,m)


