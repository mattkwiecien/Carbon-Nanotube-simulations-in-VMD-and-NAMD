forces = [ 0.01,  0.01584893,  0.02511886,  0.03981072,  0.06309573, 0.1,  0.15848932,  0.25118864,  0.39810717,  0.63095734,1.,  1.58489319,  2.51188643,  3.98107171,  6.30957344];

% T = 300k
T300Vel = zeros(1,15);
T300Std = zeros(1,15);

for i = 1:15
    force = forces(i);
    fname = sprintf('forceAdjust2_T_300K_F_%.2fpN.veldcd',force);
    try
        [T300Vel(i), T300Std(i)] = tempFind(fname);
    catch
        T300Vel(i) = NaN;
        T300Std(i) = NaN;
    end
end
% 
% T = 75k
T75Vel = zeros(1,15);
T75Std = zeros(1,15);

for i = 1:15
    force = forces(i);
    fname = sprintf('forceAdjust2_T_75K_F_%.2fpN.veldcd',force);
    try
        [T75Vel(i), T75Std(i)] = tempFind(fname);
    catch
        T75Vel(i) = NaN;
        T75Std(i) = NaN;
    end
end
% 
% T20Vel = zeros(1,15);
% T20Std = zeros(1,15);
% 
% for i = 1:15
%     force = forces(i);
%     fname = sprintf('forceAdjust_T_20K_F_%.2fpN.veldcd',force);
%     try
%         [T20Vel(i), T20Std(i)] = tempFind(fname);
%     catch
%         T20Vel(i) = NaN;
%         T20Std(i) = NaN;
%     end
% end
% 
% % % T = 5k
% T5Vel = zeros(1,15);
% T5Std = zeros(1,15);
% 
% for i = 1:15
%     force = forces(i);
%     fname = sprintf('forceAdjust_T_5K_F_%.2fpN.veldcd',force);
%     try
%         [T5Vel(i), T5Std(i)] = tempFind(fname);
%     catch
%         T5Vel(i) = NaN;
%         T5Std(i) = NaN;
%     end
% end
whos
figure 
forces = forces.*0.1;
errorbar(forces,T300Vel,T300Std,'--*r','linewidth',1)
hold on
errorbar(forces,T75Vel,T75Std,'--*m','linewidth',1)
% errorbar(forces,T20Vel,T20Std,'--*g','linewidth',1)
% errorbar(forces,T5Vel,T5Std,'--*b','linewidth',1)
set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'fontsize',18)
xlabel('force (pN)')
ylabel('velocity (A/ps)')
legend('T = 300K', 'T = 75K')%, 'T = 20K', 'T = 5K')





