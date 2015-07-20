function [Tcarbon] = tempFind(fname)
% loading moving atoms
nAtoms = 920;
length = 10;
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

mWater = ones(1,120);
for i=1:3:120
    mWater(i) = mWater(i)*mO;
    mWater(i+1) = mWater(i+1)*mH;
    mWater(i+2) = mWater(i+2)*mH; 
end

% mass = horzcat( mC.*ones(1,800), mWater );

mCarbon = mC.*ones(1,800);
k = 1.38065e-23; %boltzmann J/K

% KE = zeros(nAtoms,length);
% 
% for i = 1:length
%     KE(:,i) = 0.5 * ( mass .* sqrt(vx(i,:).^2 + vy(i,:).^2 + vz(i,:).^2).^2 );
% end


KEcarbon = zeros(800,length);
KEoxy = zeros(40,length);
KEhydro1 = zeros(40,length);
KEhydro2 = zeros(40,length);

for i = 1:length
   KEcarbon(:,i) = 0.5 .* ( mCarbon .* sqrt( vx(i,1:800).^2 + vy(i,1:800).^2 + vz(i,1:800).^2).^2 );
   %KEwater(:,i) = 0.5 * ( mWater .* sqrt(vx(i,801:920).^2 + vy(i,801:920).^2 + vz(i,801:920).^2).^2);
   KEoxy(:,i) = 0.5.*( mO.* sqrt(vx(i,801:3:920).^2 + vy(i,801:3:920).^2 + vz(i,801:3:920).^2).^2 );
   KEhydro1(:,i) = 0.5.*( mH.* sqrt(vx(i,802:3:920).^2 + vy(i,802:3:920).^2 + vz(i,802:3:920).^2).^2 );
   KEhydro2(:,i) = 0.5.*( mH.* sqrt(vx(i,803:3:920).^2 + vy(i,803:3:920).^2 + vz(i,803:3:920).^2).^2 );
end

KEaveOxy = mean(KEoxy);
KEaveH1 = mean(KEhydro1);
KEaveH2 = mean(KEhydro2);
KEaveCarbon = mean(KEcarbon);

Tcarbon = (2/3)*(1/k)* KEaveCarbon;
Toxy = (2/3)*(1/k)* KEaveOxy;
Th1 = (2/3)*(1/k)* KEaveH1;
Th2 = (2/3)*(1/k)* KEaveH2;

plot(0:length-1,Tcarbon,'--*r', 0:length-1,Toxy,'--*b', 0:length-1,Th1,'--*g', 0:length-1,Th2,'--*k')
legend('Carbon','Oxy', 'H1','H2')
title('Coeff water = 1, Coeff carbon = 1')

