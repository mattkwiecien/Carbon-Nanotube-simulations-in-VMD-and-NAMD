% T = 300k
T300Vel = zeros(1,81);
T300Std = zeros(1,81);

for i = 0:80
    force = 10+i;
    fname = sprintf('Overnight_T_300K_Force_%dpN.veldcd',force);
    try
        [T300Vel(i+1), T300Std(i+1)] = tempFind(fname);
    catch
        T300Vel(i+1) = NaN;
        T300Std(i+1) = NaN;
    end
end

% T = 75k
T75Vel = zeros(1,81);
T75Std = zeros(1,81);

for i = 0:80
    force = 10+i;
    fname = sprintf('Overnight_T_75K_Force_%dpN.veldcd',force);
    try
        [T75Vel(i+1), T75Std(i+1)] = tempFind(fname);
    catch
        T75Vel(i+1) = NaN;
        T75Std(i+1) = NaN;
    end
end

T20Vel = zeros(1,81);
T20Std = zeros(1,81);

for i = 0:80
    force = 10+i;
    fname = sprintf('Overnight_T_20K_Force_%dpN.veldcd',force);
    try
        [T20Vel(i+1), T20Std(i+1)] = tempFind(fname);
    catch
        T20Vel(i+1) = NaN;
        T20Std(i+1) = NaN;
    end
end


% % T = 5k
T5Vel = zeros(1,81);
T5Std = zeros(1,81);

for i = 0:80
    force = 10+i;
    fname = sprintf('Overnight_T_5K_Force_%dpN.veldcd',force);
    try
        [T5Vel(i+1), T5Std(i+1)] = tempFind(fname);
    catch
        T5Vel(i+1) = NaN;
        T5Std(i+1) = NaN;
    end
end


force = 10:90;

errorbar(force,T300Vel,T300Std,'--*r','linewidth',1)
hold on
errorbar(force,T75Vel,T75Std,'--*m','linewidth',1)
errorbar(force,T20Vel,T20Std,'--*g','linewidth',1)
errorbar(force,T5Vel,T5Std,'--*b','linewidth',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
set(gca,'fontsize',18)
xlabel('force (pN)')
ylabel('velocity (A/ps)')
legend('T = 300K', 'T = 75K', 'T = 20K', 'T = 5K')





