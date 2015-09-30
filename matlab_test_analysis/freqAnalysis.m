function freqAnalysis(fin,temp,L,nRings,S)
% Parameters of Simulation
fname = strcat('/Users/mkwieci2/Simulations/cnt200_4x4/PBC/',num2str(temp),'/',num2str(L),'/',fin);
% Length of simulations
Nfactor = 16;

nWater = nRings+S;
nTot = (nRings*Nfactor)+(nWater*3);
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

% L=100;
% Extracting x y z velocities from the velocity matrix recovered from the
%              
% .dcd file of simulation
x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(:,3:3:end); %Angstroms


nCarbon = nRings*Nfactor;
Wells = zeros(1,nWater);

for i = 1:L

    OxygenZ(i) = z(i,nCarbon+7);

end
figure
set(gca,'fontsize',16)
box on
hold on
lambda = (1.418*sqrt(3));
plot(1:L,OxygenZ./lambda,'-b')
xlabel('time (fs)')
ylabel('Z/\lambda')
% title('Flexible tube, T = 0, S = 0, N_{oxygen} = 1')
