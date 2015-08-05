function [mean_vel, std_vel] = tempFind(fname)
% loading moving atoms
nAtoms = 187;
length = 10;
atomlist = 1:nAtoms;
xyzlist = readdcd(fname,atomlist);

%extracting x y z positions of atom1
vx = xyzlist(:,1:3:end);
vy = xyzlist(:,2:3:end); % A/1 ps
vz = xyzlist(:,3:3:end);

vx = vx.*(20.45482706); %1 A/ps 
vy = vy.*(20.45482706); %1 A/ps 
vz = vz.*(20.45482706); %1 A/ps 


% mC = 1.994e-26;
% mH = 1.674e-27;
% mO = 2.657e-26;

nCarbon = 160;
nWater = 9;
nTot = nCarbon+(nWater*3);


% mCarbon = mC.*ones(1,nCarbon);
% mOxygen = mO.*ones(1,nWater);
% mHydrogen = mH.*ones(1,nWater);
% k = 1.38065e-23; %boltzmann J/K
% KEcarbon = zeros(nCarbon,length);
% KEoxy = zeros(nWater,length);
% KEhydro1 = zeros(nWater,length);
% KEhydro2 = zeros(nWater,length);

vWater = zeros(nWater,length);


for i = 1:length
%    KEcarbon(:,i) = 0.5 .* ( mCarbon .* sqrt( vx(i,1:nCarbon).^2 + vy(i,1:nCarbon).^2 + vz(i,1:nCarbon).^2).^2 );
%    KEoxy(:,i) = 0.5.*( mOxygen .* sqrt(vx(i,nCarbon+1:3:nTot).^2 + vy(i,nCarbon+1:3:nTot).^2 + vz(i,nCarbon+1:3:nTot).^2).^2 );
%    KEhydro1(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,nCarbon+2:3:nTot).^2 + vy(nCarbon+2:3:nTot).^2 + vz(nCarbon+2:3:nTot).^2).^2 );
%    KEhydro2(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,nCarbon+3:3:nTot).^2 + vy(i,nCarbon+3:3:nTot).^2 + vz(i,nCarbon+3:3:nTot).^2).^2 );

   vWater(:,i) = sqrt( vx(i,nCarbon+1:3:nTot).^2 + vy(i,nCarbon+1:3:nTot).^2 + vz(i,nCarbon+1:3:nTot).^2 );
end

% KEaveOxy = mean(KEoxy);
% KEaveH1 = mean(KEhydro1);
% KEaveH2 = mean(KEhydro2);
% KEaveCarbon = mean(KEcarbon);
% Tcarbon = (2/3)*(1/k)* KEaveCarbon;
% Toxy = (2/3)*(1/k)* KEaveOxy;
% Th1 = (2/3)*(1/k)* KEaveH1;
% Th2 = (2/3)*(1/k)* KEaveH2;
% plot(1:length,Tcarbon,'--*r', 1:length,Toxy,'--*b', 1:length,Th1,'--*g', 1:length,Th2,'--*k')
% hold on
% set(gca,'fontsize',14)
% xlabel('Time (ps)')
% ylabel('Temperature (K)')
% legend('Carbon','Oxygen', 'Hydrogen 1','Hydrogen 2')
% title('T=1 K, L=10 ps, S = -1, 300 rings')

plot(1:length, mean(vWater,1), '--*b','linewidth',2)
hold on

plot(1:length, mean(vx(:,nCarbon+1:3:nTot),2),'--r', 1:length, mean(vy(:,nCarbon+1:3:nTot),2),'--r', 1:length, mean(vz(:,nCarbon+1:3:nTot),2),'--k')
hold on
set(gca, 'fontsize', 14)
xlabel('Time (ps)')
ylabel('Velocity (A/ps)')
legend('|v| water', 'vx water', 'vy water', 'vz water')
title('f = 33 pN')

% %(:,5:end)
% mean_vel = mean(mean(vWater(:,5:end),1));
% std_vel = std(mean(vWater(:,5:end),1));

end



