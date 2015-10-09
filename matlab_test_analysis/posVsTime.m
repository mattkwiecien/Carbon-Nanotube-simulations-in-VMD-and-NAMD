function posVsTime(fin,temp,L,nRings,S,M)
fname = strcat('/Users/mkwieci2/Simulations/cnt600_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
Nfactor = 16;
nWater = nRings+S;
nCarbon =nRings*Nfactor;
nTot = (nRings*Nfactor)+(nWater*3);
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(:,3:3:end); %Angstroms

lambda = (1.418*sqrt(3));

z = z./lambda;

for i = M+1:L+M
    z0(i-8) = z(i,nCarbon+3);
end
figure
box on
hold on
title('Position vs Time for a single Oxygen, T=5K, 0.5 ns, N_{rings}=600, S=-1')
ylabel('z-position (Angstroms/\lambda)')
xlabel('time (ps)')
set(gca,'fontsize',14)
whos
plot(M+1:L+M,z0,'-')

