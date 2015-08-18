% Simple script that I use to find the mean velocities from each of the
% veldcd simulations.  Use a lot of try catches, but lets me perform
% analysis on the data before all the simulations may be finished.

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
    fname = sprintf('LowForcing_T_300K_F_%.2fpN.veldcd',force);
    try
        [T300Vel(i), T300Std(i)] = tempFind(fname,0);
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
    fname = sprintf('LowForcing_T_75K_F_%.2fpN.veldcd',force);
    try
        [T75Vel(i), T75Std(i)] = tempFind(fname,0);
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
    fname = sprintf('LowForcing_T_20K_F_%.2fpN.veldcd',force);
    try
        [T20Vel(i), T20Std(i)] = tempFind(fname,0);
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
    fname = sprintf('LowForcing_T_5K_F_%.2fpN.veldcd',force);
    try
        [T5Vel(i), T5Std(i)] = tempFind(fname,0);
    catch
        T5Vel(i) = NaN;
        T5Std(i) = NaN;
    end
end

whos

% Scaling here to whatever scaling is present in the namd configuration
% file
% forces = 0.1.*forces;

figure 
hold on
set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'fontsize',18)
xlabel('force (pN)')
ylabel('velocity (A/ps)')

errorbar(forces,T300Vel,T300Std,'--pr','linewidth',1)
errorbar(forces,T75Vel,T75Std,'--sm','linewidth',1)
errorbar(forces,T20Vel,T20Std,'--og','linewidth',1)
errorbar(forces,T5Vel,T5Std,'--^b','linewidth',1)

legend('T = 300K', 'T = 75K', 'T = 20K', 'T = 5K')





