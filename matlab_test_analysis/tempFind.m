function [Tcarbon] = tempFind(fname)
% loading moving atoms
nAtoms = 920;
length = 30;
atomlist = 1:nAtoms;
xyzlist = readdcd(fname,atomlist);

%extracting x y z positions of atom1
vx = xyzlist(:,1:3:end);
vy = xyzlist(:,2:3:end); % A/ps
vz = xyzlist(:,3:3:end);

vx = vx.*(100*20.45482706); %1 A/ps = 100 m/s
vy = vy.*(100*20.45482706); %1 A/ps = 100 m/s
vz = vz.*(100*20.45482706); %1 A/ps = 100 m/s

mC = 1.994e-26;
mH = 1.674e-27;
mO = 2.657e-26;

% mWater = ones(1,120);
% for i=1:3:120
%     mWater(i) = mWater(i)*mO;
%     mWater(i+1) = mWater(i+1)*mH;
%     mWater(i+2) = mWater(i+2)*mH; 
% end
% mass = horzcat( mC.*ones(1,800), mWater );
mCarbon = mC.*ones(1,800);
mOxygen = mO.*ones(1,40);
mHydrogen = mH.*ones(1,40);

k = 1.38065e-23; %boltzmann J/K

KEcarbon = zeros(800,length);
KEoxy = zeros(40,length);
KEhydro1 = zeros(40,length);
KEhydro2 = zeros(40,length);

for i = 1:length
   KEcarbon(:,i) = 0.5 .* ( mCarbon .* sqrt( vx(i,1:800).^2 + vy(i,1:800).^2 + vz(i,1:800).^2).^2 );
   KEoxy(:,i) = 0.5.*( mOxygen .* sqrt(vx(i,801:3:920).^2 + vy(i,801:3:920).^2 + vz(i,801:3:920).^2).^2 );
   
   KEhydro1(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,802:3:920).^2 + vy(i,802:3:920).^2 + vz(i,802:3:920).^2).^2 );
   KEhydro2(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,803:3:920).^2 + vy(i,803:3:920).^2 + vz(i,803:3:920).^2).^2 );
end

KEaveOxy = mean(KEoxy);
KEaveH1 = mean(KEhydro1);
KEaveH2 = mean(KEhydro2);
KEaveCarbon = mean(KEcarbon);

Tcarbon = (2/3)*(1/k)* KEaveCarbon;
Toxy = (2/3)*(1/k)* KEaveOxy;
Th1 = (2/3)*(1/k)* KEaveH1;
Th2 = (2/3)*(1/k)* KEaveH2;

plot(1:length,Tcarbon,'--*r', 1:length,Toxy,'--*b', 1:length,Th1,'--*g', 1:length,Th2,'--*k')
xlabel('Time (ps)')
ylabel('Temperature (K)')
legend('Carbon','Oxygen', 'Hydrogen 1','Hydrogen 2')
title('T=800 K, L=40000 ps, 3 degrees of freedom on oxygen and hydrogen')

