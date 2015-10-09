function flowVsTime(fin,temp,L,nRings,S,M)

fname = strcat('/Users/mkwieci2/Simulations/cnt',num2str(nRings),'_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
Nfactor = 16;
nWater = nRings+S;
nCarbon = nRings*Nfactor;
nTot = nCarbon+(nWater*3);

atomlist = 1:nTot;
xyzlist = readdcd(fname,atomlist);
% Extracting x y z velocities from the velocity matrix recovered from the
% .veldcd file of simulation
vx = xyzlist(:,1:3:end);
vy = xyzlist(:,2:3:end); 
vz = xyzlist(:,3:3:end);
% Velocities need to be multiplied by a factor to convert units to
% angstroms/picosecond, done below
vx = vx.*(20.45482706).*1000; %1 A/ps 
vy = vy.*(20.45482706).*1000; %1 A/ps 
vz = vz.*(20.45482706).*1000; %1 A/ps 

vWater = zeros(nWater,L); 
for i = M+1:L+M
    vWater(:,i-8) = vz(i,nCarbon+1:3:nTot);
end

%mean of each oxygen atom's velocity over the simulation
mean_vel = mean(vWater,1);
%std of each oxygen atom's velocity over the simulation
std_vel = std(vWater,1);

figure
hold on
box on
set(gca,'fontsize',14)
% errorbar(1:L,mean_vel,std_vel,'--*b','linewidth',2)
plot(1:L,mean_vel,'--*b','linewidth',1)
ylabel('Flowrate (A/ns)')
xlabel('Time (ps)')
title('Flowrate vs Time for 0.5ns simulation with F=0.80pN')

end

