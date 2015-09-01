%plotthing
file_prefix = 'FixedC2';
forces = [0.01, 0.01873817, 0.03511192, 0.06579332,...
    0.12328467, 0.23101297, 0.43287613, 0.81113083,...
    1.51991108, 2.84803587, 5.33669923, 10.];

temps = zeros(6,length(forces));
stds = zeros(6,length(forces));

for i = 1:length(forces)
    force = forces(i);
    fname = sprintf(strcat(file_prefix,'_T_75K_F_%.2fpN.veldcd'),force);
    
    [~,~,temps(:,i),stds(:,i)] = tempFind(fname,3813,75,25,200,-1,1);

end

Tx = temps(1,:); Ty = temps(2,:); Tz = temps(3,:); 
TCx = temps(4,:); TCy = temps(5,:); TCz = temps(6,:);

Sx = stds(1,:); Sy = stds(2,:); Sz = stds(3,:);
SCx = stds(4,:); SCy = stds(5,:); SCz = stds(6,:);

figure
hold on
set(gca,'fontsize',14)
set(gca,'linewidth',2)
xlabel('Force (pN)')
ylabel('Temperature (K)')
set(gca,'xscale','log')
set(gca,'yscale','log')
title('Fixed (4,4) CNT with S = -1, T_{therm} = 300K','fontsize',20)
errorbar(forces,Tx,Sx,'--*r')
errorbar(forces,Ty,Sy,'--*k')
errorbar(forces,Tz,Sz,'--*b')
errorbar(forces,TCx,SCx,'-or')
errorbar(forces,TCy,SCy,'-ok')
errorbar(forces,TCz,SCz,'-ob')
legend('T_{Water_{x}}','T_{Water_{y}}', 'T_{Water_{z}}', 'T_{Carbon_{x}}','T_{Carbon_{y}}','T_{Carbon_{z}}')