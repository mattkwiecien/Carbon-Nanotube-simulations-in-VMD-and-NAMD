import numpy as np
import nanogen as ng
fname = "FastRun3_T_{0:s}K"

for j in range(0,4):

	if j==0:
		Temp = 300
	elif j==1:
		Temp = 75
	elif j==2:
		Temp = 20
	elif j==3: 
		Temp = 5

	print "\n############################################################\n\
		Starting Simulation of "+fname.format( str(Temp) )+"\n\
			############################################################\n"

	ng.main( fname.format(str(Temp)), 200, -1, 4, 4, Temp, 100, 0 )

	print "\n############################################################\n\
		Finished Simulation of "+fname.format( str(Temp) )+"\n\
			############################################################\n"