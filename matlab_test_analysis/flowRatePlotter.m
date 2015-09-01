% Simple script that I use to find the mean velocities from each of the
% veldcd simulations.  Use a lot of try catches, but lets me perform
% analysis on the data before all the simulations may be finished.
file_prefix = 'FixedC2';
simLength = 25; %ps
nTot = 3813;
S = -1;
nRings = 200;


% forces array generated from a superior python np.logspace method.
forces = [0.01, 0.01873817, 0.03511192, 0.06579332,...
    0.12328467, 0.23101297, 0.43287613, 0.81113083,...
    1.51991108, 2.84803587, 5.33669923, 10.];
     
L = length(forces);
% T = 300k
T300Vel = zeros(1,L);
T300Std = zeros(1,L);

% Sometimes the simulation fails for reasons beyond my control, so I fill
% that section of the array with NaN.
for i = 1:L
    force = forces(i);
    fname = sprintf(strcat(file_prefix,'_T_300K_F_%.2fpN.veldcd'),force);
    try
        [T300Vel(i), T300Std(i)] = tempFind(fname,nTot,300,simLength,nRings,-1,0);
    catch
        T300Vel(i) = NaN;
        T300Std(i) = NaN;
    end
end

% T = 75k
T75Vel = zeros(1,L);
T75Std = zeros(1,L);

for i = 1:L
    force = forces(i);
    fname = sprintf(strcat(file_prefix,'_T_75K_F_%.2fpN.veldcd'),force);
    try
        [T75Vel(i), T75Std(i)] = tempFind(fname,nTot,75,simLength,nRings,-1,0);
    catch
        T75Vel(i) = NaN;
        T75Std(i) = NaN;
    end
end

% T = 20K
T20Vel = zeros(1,L);
T20Std = zeros(1,L);

for i = 1:L
    force = forces(i);
    fname = sprintf(strcat(file_prefix,'_T_20K_F_%.2fpN.veldcd'),force);
    try
        [T20Vel(i), T20Std(i)] = tempFind(fname,nTot,20,simLength,nRings,-1,0);
    catch
        T20Vel(i) = NaN;
        T20Std(i) = NaN;
    end
end

% T = 5k
T5Vel = zeros(1,L);
T5Std = zeros(1,L);

for i = 1:L
    force = forces(i);
    fname = sprintf(strcat(file_prefix,'_T_5K_F_%.2fpN.veldcd'),force);
    try
        [T5Vel(i), T5Std(i)] = tempFind(fname,nTot,5,simLength,nRings,-1,0);
    catch
        T5Vel(i) = NaN;
        T5Std(i) = NaN;
    end
end

whos

% Scaling here to whatever scaling is present in the namd configuration
% file
%forces = 0.1.*forces;

figure 
hold on
set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'fontsize',18)
set(gca,'linewidth',2)
xlabel('force (pN)')
ylabel('velocity (A/ns)')

errorbar(forces(1:end-1),T300Vel(1:end-1).*1000,T300Std(1:end-1).*1000,'--pr','linewidth',1)
errorbar(forces(1:end-1),T75Vel(1:end-1).*1000,T75Std(1:end-1).*1000,'--sm','linewidth',1)
errorbar(forces(1:end-1),T20Vel(1:end-1).*1000,T20Std(1:end-1).*1000,'--og','linewidth',1)
errorbar(forces(1:end-1),T5Vel(1:end-1).*1000,T5Std(1:end-1).*1000,'--^b','linewidth',1)
% title('25ps Simulation of (4,4) CNT, S = -1, all carbons rigid (fixed), forces scaled down by 0.1')

% plot(forces,T300Vel.*1000,'--pr','linewidth',1)
% plot(forces,T75Vel.*1000,'--sm','linewidth',1)
% plot(forces,T20Vel.*1000,'--og','linewidth',1)
% plot(forces,T5Vel.*1000,'--^b','linewidth',1)


legend('T = 300K', 'T = 75K', 'T = 20K', 'T = 5K')





