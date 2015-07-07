import numpy as np
from scipy import *
import subprocess
import time
import os
import re


global basePath
basePath = "/Users/nanotubes/Simulations/"

# VMD generation of nanotube and periodic boundary conditions
def tubeGen(inFile, pbcFile, N_0, n, m):
	""" tubeGen creates a periodic nanotube with the following input parameters:  inFile 
	is the name of the initial nanotube with number of rings N_0 and dimensions n x m.  pbcFile is 
	the name of the same nanotube but now with periodic boundary conditions applied to it. """

	if n & m == 3:
		s = 0.1447 #nm
	elif n & m == 4:
		s = 0.1432
	elif n & m == 5:
		s = 0.1429 #nm
	elif n & m == 6:
		s = 0.1422
	else:
		print "\nCannot currently create nanotubes with those dimensions.\n"

	l = (N_0-1)*s*np.sqrt(3)

	tubePath = basePath+"cnt"+str(N_0)+"_"+str(n)+"x"+str(m)+"/"
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


def solvate(inFile, N_0, S, n, m):

	tPath, pPath = tubeGen(inFile,inFile,N_0,n,m)

	psfFile = open(pPath+inFile+".psf",'rwa')
	pdbFile = open(pPath+inFile+".pdb",'rwa')
	psfLines = psfFile.readlines()
	pdbLines = pdbFile.readlines()
	psfFile.close()
	pdbFile.close()

	lenPsf = len(psfLines)
	lenPdb = len(pdbLines)

	oxygen = "ATOM    {:3d}  OH2 TIP3W8425       0.000   0.000   {:.3f}  1.00  0.00      WT1  O\n"
	hydro1 = "ATOM    {:3d}  H1  TIP3W8425       0.000   0.766   {:.3f}  1.00  0.00      WT1  H\n"
	hydro2 = "ATOM    {:3d}  H2  TIP3W8425       0.000  -0.766   {:.3f}  1.00  0.00      WT1  H\n"

	if n & m == 3:
		s = 1.447 
	elif n & m == 4:
		s = 1.432
	elif n & m == 5:
		s = 1.429 
	elif n & m == 6:
		s = 1.422
	else:
		print "\nCannot currently create nanotubes with those dimensions.\n"

	apothem = s*np.sqrt(3)/2
	diameter = 2*s

	if S==0:
		nAtoms = lenPdb-2
		newAtoms = nAtoms+(3*N_0)
		print nAtoms, newAtoms
		for i in range(0,lenPsf):
			if "!NATOM" in psfLines[i]:
				psfLines[i] = "     {:3d} !NATOM\n".format( newAtoms )
			elif "!NBOND" in psfLines[i]:
				psfLines[i] = "     {:3d} !NBOND: bonds\n".format( (nAtoms*(3/2)) + (2*N_0) )
			elif "!NTHETA" in psfLines[i]:
				psfLines[i] = "     {:3d} !NTHETA: angles\n".format( (nAtoms*3) + N_0 )


		for i in range(0,3*N_0,3):
			if i==0:
				pdbLines[lenPdb-1] = oxygen.format(nAtoms+1, apothem)
				pdbLines.append( hydro1.format(nAtoms+(i+2), apothem+.570) )
				pdbLines.append( hydro2.format(nAtoms+(i+3), apothem+.570) )
			
			else:
				pdbLines.append( oxygen.format(nAtoms+i+1, apothem+((i/3)*diameter)) )
				pdbLines.append( hydro1.format(nAtoms+(i+2), apothem+0.570+((i/3)*diameter)) )
				pdbLines.append( hydro2.format(nAtoms+(i+3), apothem+0.570+((i/3)*diameter)) )

		pdbLines.append("END\n")
		pdbOut = open(pPath+inFile+"_solv.pdb",'w')
		pdbOut.writelines(pdbLines)
		pdbOut.close()

		psfOut = open(pPath+inFile+"_solv.psf",'w')
		psfOut.writelines(psfLines)
		psfOut.close()

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

	simLines[14] = "set temperature    {:3d}\n".format(temp)
	simLines[34] = "cellBasisVector1    {:.3f}   0.   0.\n".format(x)
	simLines[35] = "cellBasisVector2    0.   {:.3f}   0.\n".format(y)
	simLines[36] = "cellBasisVector3    0.    0.   {:.3f}\n".format(z)

	simLines[15] = "set outputname     "+simPath+output+"\n"
	simLines[74] = "fixedAtomsFile      "+CNTpath+pbcFile+".pdb\n"
	simLines[99] = "run {:5d} ;# 10ps\n".format(length)

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
	# Opens the CNT prebond file and reads the header of the file
	basisFile = open(CNT+"-prebond.pdb","r")
	header = basisFile.next()
	basisFile.close()

	# Splits the first line of the CNT-prebond file, and finds the x,y,z basis vectors of the CNT 
	basis = re.split('\s+',header)
	xVec = eval(basis[1])
	yVec = eval(basis[2])
	zVec = eval(basis[3])
	
	return xVec, yVec, zVec

def main(inFile,pbcFile,N_0,n,m):
	initPath, pbcPath = tubeGen(inFile,pbcFile,N_0,n,m)
	simPath = simWrite(pbcFile,pbcPath,500,20000,"ringtest")
	runSim(simPath)

