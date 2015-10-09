function tubeRadius(fin,temp,L,nRings,S)
% Parameters of Simulation
fname = strcat('/Users/mkwieci2/Simulations/cnt600_4x4/PBC/',num2str(temp),'/',num2str(L),'/',fin);
% Length of simulations
Nfactor = 16;

nWater = nRings+S;
nCarbon = nRings*Nfactor;
nTot = (nRings*Nfactor)+(nWater*3);
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(;,3:3:end);
mean_x_pos = mean(x(:,1:nCarbon),1);
mean_y_pos = mean(y(:,1:nCarbon),1);
std_x = std(x(:,1:nCarbon));
std_y = std(y(:,1:nCarbon));

figure
set(gca,'fontsize',16)
box on
hold on
plot(mean_x_pos,mean_y_pos,'--ob')
xlabel('x-position (Angstroms)')
ylabel('y-position (Angstroms)')
title('Heated carbons, 1000fs simulation')



