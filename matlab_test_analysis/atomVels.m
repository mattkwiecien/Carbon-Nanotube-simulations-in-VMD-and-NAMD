function atomVels(fin,temp,L,S)
% Parameters of Simulation
fname = strcat('/Users/mkwieci2/Simulations/cnt200_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
% Length of simulations
nTot = 3813;
nRings = 200;
atomlist = 1:nTot;
xyzlist = readdcd(fname,atomlist);

% L=100;
% Extracting x y z velocities from the velocity matrix recovered from the
% .veldcd file of simulation
vx = xyzlist(:,1:3:end);
vy = xyzlist(:,2:3:end); 
vz = xyzlist(:,3:3:end);

% Velocities need to be multiplied by a factor to convert units to
% angstroms/picosecond, done below
vx = vx.*(20.45482706).*100; %1 A/ps 
vy = vy.*(20.45482706).*100; %1 A/ps 
vz = vz.*(20.45482706).*100; %1 A/ps 

nWater = nRings+S;
nCarbon = nTot - (nWater*3);

% Two modes here: 0 is what is used for simply getting the mean and
% standard deviation of the water molecules.  1 is used for bug checking
% the simulation and ensuring that the kinetic energy and temperature is
% correct.

% Masses of different atoms
mH = 1.674e-27; % kg
mO = 2.6567626e-26; % kg
mC = 1.99442e-26; %kg 
% Boltzmann constant
k = 1.38065e-23; %boltzmann J/K

% Using the fact that KE = 1/2 mv^2 to find KE of each atom.
O_x = zeros(L,length(nCarbon+1:3:nTot));
O_y = zeros(L,length(nCarbon+1:3:nTot));
O_z = zeros(L,length(nCarbon+1:3:nTot));

H1_x = zeros(L,length(nCarbon+2:3:nTot));
H2_x = zeros(L,length(nCarbon+3:3:nTot));

H1_y = zeros(L,length(nCarbon+2:3:nTot));
H2_y = zeros(L,length(nCarbon+3:3:nTot));

H1_z = zeros(L,length(nCarbon+2:3:nTot));
H2_z = zeros(L,length(nCarbon+3:3:nTot));

C_x = zeros(L,length(1:nCarbon));
C_y = zeros(L,length(1:nCarbon));
C_z = zeros(L,length(1:nCarbon));

X_rat = zeros(1,L);
Y_rat = zeros(1,L);
Z_rat = zeros(1,L);

% for L time steps
for i = 1:L

   O_x(i,:) = (0.5*mO).*(vx(i,nCarbon+1:3:nTot).^2);
   O_y(i,:) = (0.5*mO).*(vy(i,nCarbon+1:3:nTot).^2);
   O_z(i,:) = (0.5*mO).*(vz(i,nCarbon+1:3:nTot).^2); % [KE] = kg m^2 s^-2

   H1_x(i,:) = (0.5*mH).*(vx(i,nCarbon+2:3:nTot).^2);
   H1_y(i,:) = (0.5*mH).*(vy(i,nCarbon+2:3:nTot).^2);
   H1_z(i,:) = (0.5*mH).*(vz(i,nCarbon+2:3:nTot).^2);
   
   H2_x(i,:) = (0.5*mH).*(vx(i,nCarbon+3:3:nTot).^2);
   H2_y(i,:) = (0.5*mH).*(vy(i,nCarbon+3:3:nTot).^2);
   H2_z(i,:) = (0.5*mH).*(vz(i,nCarbon+3:3:nTot).^2);
   
   C_x(i,:) = (0.5*mC).*(vx(i,1:nCarbon).^2);
   C_y(i,:) = (0.5*mC).*(vy(i,1:nCarbon).^2);
   C_z(i,:) = (0.5*mC).*(vz(i,1:nCarbon).^2);

   X_rat(i) = mean(abs(vx(i,1:nCarbon))) / mean(abs(vx(i,nCarbon+1:3:nTot)));
   Y_rat(i) = mean(abs(vy(i,1:nCarbon))) / mean(abs(vy(i,nCarbon+1:3:nTot)));
   Z_rat(i) = mean(abs(vz(i,1:nCarbon))) / mean(abs(vz(i,nCarbon+1:3:nTot)));

end

fprintf('The ratio of v_{c}/v_{w} in the x-direction is %.4f.\n', mean(X_rat))
fprintf('The ratio of v_{c}/v_{w} in the y-direction is %.4f.\n', mean(Y_rat))
fprintf('The ratio of v_{c}/v_{w} in the z-direction is %.4f.\n', mean(Z_rat))

% From the fact that KE = 3/2 k T we have
%  T = 2 KE / k for each degree of freedom.
TOx = (2/k).*O_x;
TOy = (2/k).*O_y;
TOz = (2/k).*O_z;

TH1x = (2/k).*H1_x;
TH1y = (2/k).*H2_y;
TH1z = (2/k).*H2_z;

TH2x = (2/k).*H2_x;
TH2y = (2/k).*H2_y;
TH2z = (2/k).*H2_z;

Cx = (2/k).*C_x;
Cy = (2/k).*C_y;
Cz = (2/k).*C_z;


figure
hold on
set(gca,'fontsize',16)
set(gca,'linewidth',2)
xlabel('Time (ps)')
ylabel('Temperature (K)')

plot(1:L, mean(TOx,2),'--*k')
plot(1:L, mean(TOy,2),'--*r')
plot(1:L, mean(TOz,2),'--*b')

plot(1:L, mean(TH1x,2),'--ok')
plot(1:L, mean(TH1y,2),'--or')
plot(1:L, mean(TH1z,2),'--ob')

plot(1:L, mean(TH2x,2),'--^k')
plot(1:L, mean(TH2y,2),'--^r')
plot(1:L, mean(TH2z,2),'--^b')


    

end