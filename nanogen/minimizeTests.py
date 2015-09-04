import numpy as np
import nanogen as ng
fname = "minimize_{0:s}ps"

for j in range(1,11):

	minLength = j*2000

	print "\n############################################################\n\
		Starting Simulation of "+fname.format( str(minLength) )+"\n\
			############################################################\n"

	ng.main( fname.format(str(minLength)), 200, -1, 4, 4, 5, 25000, 0, minLength )

	print "\n############################################################\n\
		Finished Simulation of "+fname.format( str(minLength) )+"\n\
			############################################################\n"