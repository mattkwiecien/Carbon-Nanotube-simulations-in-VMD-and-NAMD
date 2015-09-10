import numpy as np
import nanogen as ng
fname = "Third_S{0:s}_minimize{1:s}"

for j in range(-1,2):

	for i in range(1,3):

		if i == 1: 
			minimize = 0
		elif i==2:
			minimize = 8000

		print "\n############################################################\n\
			Starting Simulation of "+fname.format( str(j),str(minimize) )+"\n\
				############################################################\n"

		ng.main( fname.format(str(j),str(minimize)), 200, j, 4, 4, 5, 500000, 0, minimize )

		print "\n############################################################\n\
			Finished Simulation of "+fname.format( str(j),str(minimize) )+"\n\
				############################################################\n"