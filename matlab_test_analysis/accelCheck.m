F = 1e-12; %pN
m = 3e-26; %kg
accel = (F/m)*1e-8; %A/ns^2
t_sim = 0.25; %ns


xf1 = '/Users/mkwieci2/Simulations/cnt30_60x60/PBC/xf1_run/5/25000/xf1.dcd';
xyzlist1 = readdcd(xf1,1:7287);
z1 = xyzlist1(:,3:3:end); %Angstroms
z_i1 = z1(9,7201:3:7287); %Angstroms
zf_exp1 = z1(33,7201:3:7287); %Angstroms

% xf2 = '/Users/mkwieci2/Simulations/cnt30_30x30/PBC/xf2_run/5/25000/xf2.dcd';
% xyzlist2 = readdcd(xf2,1:3687);
% z2 = xyzlist2(:,3:3:end);
% z_i2 = z2(9,3601:3:3687);
% zf_exp2 = z2(33,3601:3:3687);
% 
% xf3 = '/Users/mkwieci2/Simulations/cnt30_15x15/PBC/xf3_run/5/50000/xf3.dcd';
% xyzlist3 = readdcd(xf3,1:3147);
% z3 = xyzlist3(:,3:3:end);
% z_i3 = z3(9,3001:3:3087);
% zf_exp3 = z3(33,3001:3:3087);

zf_theory = z_i1 + (accel * ((0.025)^2)/2); %Angstroms


xaxis = 1:29;
figure
set(gca,'fontsize',14)
hold on
box on
% plot(xaxis,zf_exp1,'r^',xaxis,zf_exp2,'b^',xaxis,zf_exp3,'g^',xaxis,zf_theory,'ko')
plot(xaxis,zf_exp1,'r^',xaxis,zf_theory,'ko')
legend('(60,60)','(30,30)','(15,15)','Final position assuming constant acceleration')
title('Calculated final z-distance and simulated final z-distance after 25ps')
ylabel('Final z-positions (Angstroms)')
xlabel('Oxygen number')