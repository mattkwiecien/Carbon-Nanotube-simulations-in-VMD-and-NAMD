import numpy as np
import nanogen as ng
fname = "RingSim{0:s}"

for j in range(-1,2):

	print "\n############################################################\n\
		Starting Simulation of "+fname.format( str(j) )+"\n\
			############################################################\n"

	ng.main( fname.format(str(j)), 200, j, 4, 4, 5, 100000, 0, 0 )

	print "\n############################################################\n\
		Finished Simulation of "+fname.format( str(j) )+"\n\
			############################################################\n"