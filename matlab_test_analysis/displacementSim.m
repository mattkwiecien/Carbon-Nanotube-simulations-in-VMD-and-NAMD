function displacementSim(fin,nTot,temp,L,nRings,S)
% Parameters of Simulation
fname = strcat('/Users/nanotubes/Simulations/cnt200_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
% Length of simulations
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

% L=100;
% Extracting x y z velocities from the velocity matrix recovered from the
%              
% .veldcd file of simulation
x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(:,3:3:end); %Angstroms


nWater = nRings+S;
nCarbon = nTot - (nWater*3);

for i = 1:L

    clf
    CarbonZ = z(i,1:nCarbon);
    CarbonY = y(i,1:nCarbon);
    CarbonX = x(i,1:nCarbon);
    
    OxygenX = x(i,nCarbon+1:3:nTot);
    OxygenY = y(i,nCarbon+1:3:nTot);
    OxygenZ = z(i,nCarbon+1:3:nTot);
    
    hold on
    plot3(CarbonX,CarbonY,CarbonZ,'ko');
    plot3(OxygenX,OxygenY,OxygenZ,'ro');
    view(3)
    pause
    

end

OxygenPos = z(:,nCarbon+1:3:nTot);