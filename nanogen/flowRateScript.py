fname = "Overnight_T_{0:s}K_Force_{1:s}pN"

for j in range(0,4):

	if j==0:
		Temp = 300
	elif j==1:
		Temp = 75
	elif j==2:
		Temp = 20
	elif j==3: 
		Temp = 5

	for i in range(0,80):
		force = 10+i
		print "##########\n##########\n##########\nStarting Simulation of "+fname.format( str(Temp), str(force) )+"##########\n##########\n##########\n"
		ng.main( fname.format( str(Temp), str(force) ), 10, -1, 4, 4, Temp, 20000, force )
		print "##########\n##########\n##########\nFinished Simulation of "+fname.format( str(Temp), str(force) )+" at force = "+str(force)+"\n###########\n###########\n###########\n"