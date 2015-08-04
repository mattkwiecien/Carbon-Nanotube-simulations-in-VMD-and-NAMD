fname = "T_{0:s}K_Force_{1:s}pN.veldcd"

for j in range(0,4):

	if j==0:
		Temp = 300
	elif j==1:
		Temp = 75
	elif j==2:
		Temp = 20
	elif j==3: 
		Temp = 5

	for i in range(0,10):
		if i==0:
			force = .005
		elif i==1:
			force = .01
		elif i==2:
			force = .02
		elif i==3:
			force = .05
		elif i==4:
			force = 0.1
		elif i==5:
			force = 0.2
		elif i==6:
			force = 0.5
		elif i==7:
			force = 1.0
		elif i==8:
			force = 2.0
		elif i==9:
			force = 5.0

		ng.main( fname.format( str(Temp), str(force) ), 30, -1, 4, 4, Temp, 100000, force )
		print "Starting Simulation of "+fname.format( str(Temp), str(force) )+"\n"
		print "Finished Simulation of "+fname.format( str(Temp), str(force) )+"at force = "+str(force)+"\n"