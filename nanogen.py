import numpy as np
from scipy import *
import subprocess
import time
import os

global basePath
basePath = "/Users/nanotubes/Simulations/"

# VMD generation of nanotube and periodic boundary conditions
def tubeGen(inFile, pbcFile, l, n, m):
	""" tubeGen creates a periodic nanotube with the following input parameters:  inFile 
	is the name of the initial nanotube of length l with dimensions n x m.  pbcFile is 
	the name of the same nanotube but now with periodic boundary conditions applied to it. """
	
	tubePath = basePath+"cnt"+str(l)+"_"+str(n)+"x"+str(m)+"/"
	pbcPath = tubePath+"PBC/"
	if ~os.path.exists(pbcPath):
		os.system("mkdir -p "+pbcPath)

	# Opening a pipe to VMD in the shell
	VMDin=subprocess.Popen(["vmd","-dispdev", "none"], stdin=subprocess.PIPE)

	# runs CNTtools.tcl script to generate nanotube and generate PBCs
	sourceCNT = "source CNTtools.tcl\n"
	CNTtools = "package require CNTtools 1.0\n"

	genNT = "genNT "+inFile+" "+tubePath+" "+str(l)+" "+str(n)+" "+str(m)+"\n"
	pbcNT = "pbcNT "+tubePath+inFile+" "+pbcPath+pbcFile+" default\n"
	fixNT = "fixNT "+pbcPath+pbcFile+"\n"

	# run commands through pipe and saves to file
	VMDin.stdin.write(sourceCNT)
	VMDin.stdin.write(CNTtools)
	VMDin.stdin.write(genNT)
	VMDin.stdin.write(pbcNT)
	VMDin.stdin.write(fixNT)

	# finished creating periodic nanotubes in VMD
	VMDin.stdin.flush()
	VMDin.stdin.close
	VMDin.communicate()
	if VMDin.returncode==0:
		return tubePath, pbcPath


def simWrite(pbcFile, CNTpath, temp = 300, length = 20000, output = "sim_fixed"):
	""" simWrite generates a .conf file to use as input to namd2. To organize simulations
	with different parameters, simWrite will create a directory for the simulation using 
	the following template: ~/Simulations/cntl_nxm/temp/length/sim.dcd, sim.conf.  """

	simPath = CNTpath+str(temp)+"/"+str(length)+"/"
	if ~os.path.exists(simPath):
		os.system("mkdir -p "+simPath)

	# Grabs the CNT basis vectors
	x,y,z = getCNTBasis(CNTpath+pbcFile)

	# Read in lines of simulation file
	inFile = open(basePath+"templates/sim_template.conf","r")
	simLines = inFile.readlines()
	inFile.close()

	simLines[11] = "structure          "+CNTpath+pbcFile+".psf\n"
	simLines[12] = "coordinates        "+CNTpath+pbcFile+".pdb\n"

	simLines[14] = "set temperature    "+str(temp)+"\n"
	simLines[34] = "cellBasisVector1    "+str(x)+"   0.   0.\n"
	simLines[35] = "cellBasisVector2    0.   "+str(y)+"   0.\n"
	simLines[36] = "cellBasisVector3    0.    0   "+str(z)+"\n"

	simLines[15] = "set outputname     "+simPath+output+"\n"
	simLines[74] = "fixedAtomsFile      "+CNTpath+pbcFile+".pdb\n"
	simLines[99] = "run "+str(length)+" ;# 10ps\n"

	# Write contents out to original file
	if os.path.exists(simPath):
		outFile = open(simPath+output+".conf", "w")
		outFile.writelines(simLines)
		outFile.close()
		paramFile = basePath+"templates/par_all27_prot_lipid.prm"
		os.system("cp "+paramFile+" "+simPath)
		return simPath+output+".conf"

def runSim(simPath):
	""" given an input path to a simulation file, runSim will call namd2 to run the simulation """
	Namd2in=subprocess.Popen(["namd2",simPath], stdin=subprocess.PIPE)
	Namd2in.stdin.flush()
	Namd2in.stdin.close
	Namd2in.communicate()
	if Namd2in.returncode==0:
		print "################################################################\nSimulation finished\nSimulation file saved into "+simPath.replace(".conf",".dcd")+".\n################################################################\n"

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

def main(inFile,pbcFile,l,n,m):
	initPath, pbcPath = tubeGen(inFile,pbcFile,l,n,m)
	simPath = simWrite(pbcFile,pbcPath,500,40000,"dirtest")
	runSim(simPath)

