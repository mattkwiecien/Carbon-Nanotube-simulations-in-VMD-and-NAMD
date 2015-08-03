% loading moving atoms
fname = 'forceOff.veldcd';
nAtoms = 377;
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

mCarbon = mC.*ones(1,320);
mOxygen = mO.*ones(1,19);
mHydrogen = mH.*ones(1,19);

k = 1.38065e-23; %boltzmann J/K

KEcarbon = zeros(320,length);
KEoxy = zeros(19,length);
KEhydro1 = zeros(19,length);
KEhydro2 = zeros(19,length);
vWater = zeros(19,length);

whos
for i = 1:length
   KEcarbon(:,i) = 0.5 .* ( mCarbon .* sqrt( vx(i,1:320).^2 + vy(i,1:320).^2 + vz(i,1:320).^2).^2 );
   KEoxy(:,i) = 0.5.*( mOxygen .* sqrt(vx(i,321:3:377).^2 + vy(i,321:3:377).^2 + vz(i,321:3:377).^2).^2 );
   
   KEhydro1(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,322:3:377).^2 + vy(i,322:3:377).^2 + vz(i,322:3:377).^2).^2 );
   KEhydro2(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,323:3:377).^2 + vy(i,323:3:377).^2 + vz(i,323:3:377).^2).^2 );
   
   vWater(:,i) = sqrt( vx(i,321:3:377).^2 + vy(i,321:3:377).^2 + vz(i,321:3:377).^2 );
end

KEaveOxy = mean(KEoxy);
KEaveH1 = mean(KEhydro1);
KEaveH2 = mean(KEhydro2);
KEaveCarbon = mean(KEcarbon);

Tcarbon = (2/3)*(1/k)* KEaveCarbon;
Toxy = (2/3)*(1/k)* KEaveOxy;
Th1 = (2/3)*(1/k)* KEaveH1;
Th2 = (2/3)*(1/k)* KEaveH2;


% plot(1:length,Tcarbon,'--*r', 1:length,Toxy,'--*b', 1:length,Th1,'--*g', 1:length,Th2,'--*k')
% hold on
% set(gca,'fontsize',14)
% xlabel('Time (ps)')
% ylabel('Temperature (K)')
% legend('Carbon','Oxygen', 'Hydrogen 1','Hydrogen 2')
% title('T=1 K, L=10 ps, S = -1, 300 rings')

plot(1:length, mean(vWater,1), '--*b','linewidth',2)
hold on
set(gca, 'fontsize', 14)
xlabel('Time (ps)')
ylabel('Velocity (A/ps)')
legend('Water')
title('f = 0 pN')


