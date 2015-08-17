import numpy as np
fname = "forceAdjust2_T_{0:s}K_F_{1:s}pN"

for j in range(0,4):

	if j==0:
		Temp = 300
	elif j==1:
		Temp = 75
	elif j==2:
		Temp = 20
	elif j==3: 
		Temp = 5

	forces = np.logspace(-2,.8,15)

	for force in forces:
		strForce = "{:.2f}".format(force) 
		print "##########\n##########\n##########\nStarting Simulation of "+fname.format( str(Temp), strForce )+"\n##########\n##########\n##########\n"
		ng.main( fname.format( str(Temp), strForce ), 200, -1, 4, 4, Temp, 200000, force )
		print "##########\n##########\n##########\nFinished Simulation of "+fname.format( str(Temp), strForce )+"\n###########\n###########\n###########\n"