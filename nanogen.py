import numpy as np
from scipy import *
import subprocess
import time
import os
import re
from itertools import chain


global basePath
basePath = "/Users/nanotubes/Simulations/"

# VMD generation of nanotube and periodic boundary conditions
def tubeGen(inFile, pbcFile, N_0, n, m):
	""" tubeGen creates a periodic nanotube with the following input parameters:  inFile 
	is the name of the initial nanotube with number of rings N_0 and dimensions n x m.  pbcFile is 
	the name of the same nanotube but now with periodic boundary conditions applied to it. """

	#Bonds lengths of different armchair nanotubes in nanometers
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

	#calculates the length of the nanotube based on bond lengths
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
	""" The solvate module will create an armchair swcnt with N_0 rings and add N_0+S water molecules inside
	the nanotube, then write out new psf and pdb files for the nanotube. """
	tPath, pPath = tubeGen(inFile,inFile,N_0,n,m)

	#Opens input nanotube psf and pdb files, and reads all the lines of each file into lists
	with open(pPath+inFile+".psf") as psfFile:
		psfLines = psfFile.readlines()
	with open(pPath+inFile+".pdb") as pdbFile:
		pdbLines = pdbFile.readlines()

	#Grabs the lengths of each of the lists
	lenPsf = len(psfLines)
	lenPdb = len(pdbLines)

	#Pdb format for oxygen and hydrogen
	oxygen = "ATOM    {:3d}  OH2 TIP3W8425       0.000   0.000   {:.3f}  1.00  0.00      WT1  O\n"
	hydro1 = "ATOM    {:3d}  H1  TIP3W8425       0.000   0.766   {:.3f}  1.00  0.00      WT1  H\n"
	hydro2 = "ATOM    {:3d}  H2  TIP3W8425       0.000  -0.766   {:.3f}  1.00  0.00      WT1  H\n"

	#Psf format for oxygen and hydrogen
	opsf = "     {:3d} WT1  8425 TIP3 OH2  OT    -0.834000       15.9994           0\n"
	h1psf = "     {:3d} WT1  8425 TIP3 H1   HT     0.417000        1.0080           0\n"
	h2psf = "     {:3d} WT1  8425 TIP3 H2   HT     0.417000        1.0080           0\n"

	#Bonds lengths for different armchair nanotubes
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

	#Calculates the apothem of each regular hexagon in the nanotube and then calculates the distance
	##between the center of each ring in the tube
	apothem = s*np.sqrt(3)/2
	l = (N_0-1)*s*np.sqrt(3)
	dist = l/N_0

	if S==0:

		#Finds the original number of atoms in the Pdb file
		nAtoms = lenPdb-2
		#Calculates the new number of atoms after solvating
		newAtoms = nAtoms+(3*N_0)
		#Calculates the new number of bonds and angles after solvating
		newBonds = int(nAtoms*(3./2)) + 2*N_0
		newAngles = nAtoms*3 + N_0

		#Initializing lists used below
		atoms = []
		bonds = []
		angles = []
		preAtoms = []
		postAngles = []

		#Iterates through all of the lines of the input Psf file, and records the index of the lines that contain
		## the string !NATOM, !NBOND, and !NTHETA, as wella as changes the line to update the new number of each
		for i in range(0,lenPsf):
			if "!NATOM" in psfLines[i]:
				psfLines[i] = "     {:3d} !NATOM\n".format( newAtoms )
				atomIndex = i
			elif "!NBOND" in psfLines[i]:
				psfLines[i] = "     {:3d} !NBOND: bonds\n".format( newBonds )
				bondIndex = i
			elif "!NTHETA" in psfLines[i]:
				psfLines[i] = "     {:3d} !NTHETA: angles\n".format( newAngles )
				angleIndex = i

		#Stores all of the original text lines that come before the atom section into a list
		for i in range(0,atomIndex):
			preAtoms.append(psfLines[i])

		#Stores the atoms into a list
		count = 1
		while psfLines[atomIndex+count].strip():
			atoms.append( psfLines[atomIndex+count] )
			count+=1
		#Stores the bonds into a list
		count = 1
		while psfLines[bondIndex+count].strip():
			bonds.append( psfLines[bondIndex+count] )
			count+=1
		#Stores the angles into a list
		count = 1
		while psfLines[angleIndex+count].strip():
			angles.append( psfLines[angleIndex+count] )
			count+=1
		#Stores all the text lines after the angles into a list
		for i in range(angleIndex+count,lenPsf):
			postAngles.append(psfLines[i])

		intBonds = []
		intAngles = []

		#Takes the bonds and angles in the original file and splits each line into individual numbers
		for bond in bonds:
			intBonds.append( bond.strip("\n").split() )
		for angle in angles:
			intAngles.append( angle.strip("\n").split() )

		#Compresses the list of lists into a single list of all of the angles and bonds in the original file
		intBonds = list(chain.from_iterable(intBonds))
		intAngles = list(chain.from_iterable(intAngles))	

		#Adds the new bonds and angles to the list of original bonds and angles
		for i in range(1, (3*N_0)+1, 3):
			intAngles.append(str(nAtoms+i+1))
			intAngles.append(str(nAtoms+i))
			intAngles.append(str(nAtoms+i+2))

			intBonds.append(str(nAtoms+i))
			intBonds.append(str(nAtoms+i+1))
			intBonds.append(str(nAtoms+i))
			intBonds.append(str(nAtoms+i+2))

		#Adds the new atoms to the original list of atoms
		for i in range(nAtoms+1, 3*N_0 + nAtoms+1, 3):
			atoms.append(opsf.format(i))
			atoms.append(h1psf.format(i+1))
			atoms.append(h2psf.format(i+2))

		#String format for the bonds and angles in the psf file
		sBondFormat = " {0: >8}{1: >8}{2: >8}{3: >8}{4: >8}{5: >8}{6: >8}{7: >8}\n"
		sAngleFormat = " {0: >8}{1: >8}{2: >8}{3: >8}{4: >8}{5: >8}{6: >8}{7: >8}{8: >8}\n"

		#Formats the list of bonds into the psf format with 8 columns
		bondsFinal = []
		for i in range(0,len(intBonds),8):
			try:
				bondsFinal.append( sBondFormat.format(intBonds[i],intBonds[i+1],intBonds[i+2],intBonds[i+3],
					intBonds[i+4], intBonds[i+5], intBonds[i+6], intBonds[i+7]) )
		
			except:
				diff = len(intBonds) - i
				tempStr = ""
				for j in range(i,i+diff):
					tempStr = tempStr + "{:>8}".format(intBonds[j])
				bondsFinal.append( " "+tempStr+"\n" )

		#Formates the list of angles into the psf format with 9 columns
		anglesFinal = []
		for i in range(0,len(intAngles),9):
			try:
				anglesFinal.append( sAngleFormat.format(intAngles[i],intAngles[i+1],intAngles[i+2],intAngles[i+3],
					intAngles[i+4], intAngles[i+5], intAngles[i+6], intAngles[i+7], intAngles[i+8]) )
		
			except:
				diff = len(intAngles) - i
				tempStr = ""
				for j in range(i,i+diff):
					tempStr = tempStr + "{:>8}".format(intAngles[j])
				anglesFinal.append( " "+tempStr+"\n" )

		#Adds the new atoms to the pdb file
		for i in range(0,3*N_0,3):
			if i==0:
				pdbLines[lenPdb-1] = oxygen.format(nAtoms+1, apothem)
				pdbLines.append( hydro1.format(nAtoms+(i+2), apothem+0.570) )
				pdbLines.append( hydro2.format(nAtoms+(i+3), apothem+0.570) )
			
			else:
				pdbLines.append( oxygen.format(nAtoms+i+1, apothem+((i/3)*dist)) )
				pdbLines.append( hydro1.format(nAtoms+(i+2), apothem+0.570+((i/3)*dist)) )
				pdbLines.append( hydro2.format(nAtoms+(i+3), apothem+0.570+((i/3)*dist)) )

		#Writes the new pdb lines to a new pdb file
		pdbLines.append("END\n")
		pdbOut = open(pPath+inFile+"-solv.pdb",'w')
		pdbOut.writelines(pdbLines)
		pdbOut.close()

		#Writes the new psf lines to a new psf file
		psfOut = open(pPath+inFile+"-solv.psf",'w')
		psfOut.writelines(preAtoms)
		psfOut.writelines(psfLines[atomIndex])
		psfOut.writelines(atoms)
		psfOut.writelines("\n"+psfLines[bondIndex])
		psfOut.writelines(bondsFinal)
		psfOut.writelines("\n"+psfLines[angleIndex])
		psfOut.writelines(anglesFinal)
		psfOut.writelines(postAngles)

		psfOut.close()

		return pPath


def simWrite(pbcFile, CNTpath, temp = 300, length = 20000, output = "waterSim"):
	""" simWrite generates a .conf file to use as input to namd2. To organize simulations
	with different parameters, simWrite will create a directory for the simulation using 
	the following template: ~/Simulations/cntl_nxm/temp/length/sim.dcd, sim.conf.  """

	simPath = CNTpath+str(temp)+"/"+str(length)+"/"
	if ~os.path.exists(simPath):
		os.system("mkdir -p "+simPath)

	# Grabs the CNT basis vectors
	x,y,z = getCNTBasis(CNTpath+pbcFile)

	# Read in lines of simulation file
	with open(basePath+"templates/sim_template.conf") as inFile:
		simLines = inFile.readlines()

	simLines[11] = "structure          "+CNTpath+pbcFile+"-solv.psf\n"
	simLines[12] = "coordinates        "+CNTpath+pbcFile+"-solv.pdb\n"

	simLines[14] = "set temperature    {:3d}\n".format(temp)
	simLines[34] = "cellBasisVector1    {:.3f}   0.   0.\n".format(x)
	simLines[35] = "cellBasisVector2    0.   {:.3f}   0.\n".format(y)
	simLines[36] = "cellBasisVector3    0.    0.   {:.3f}\n".format(z)

	simLines[15] = "set outputname     "+simPath+output+"\n"
	simLines[74] = "fixedAtomsFile      "+CNTpath+pbcFile+"-solv.pdb\n"
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
	with open(CNT+"-prebond.pdb") as basisFile:
		header = basisFile.next()


	# Splits the first line of the CNT-prebond file, and finds the x,y,z basis vectors of the CNT 
	basis = re.split('\s+',header)
	xVec = eval(basis[1])
	yVec = eval(basis[2])
	zVec = eval(basis[3])
	
	return xVec, yVec, zVec

def main(inFile,N_0,S,n,m):
	pbcPath = solvate(inFile,N_0,S,n,m)
	simPath = simWrite(inFile,pbcPath,300,30000,"waterSims")
	#runSim(simPath)

