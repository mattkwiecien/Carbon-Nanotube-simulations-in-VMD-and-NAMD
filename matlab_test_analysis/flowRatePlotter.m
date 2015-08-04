% T = 300k
T300Vel = zeros(1,5);
T300Std = zeros(1,5);

for i = 0:4
    fname = sprintf('T_300K_Force_%.1fpN.veldcd',0.8+i);
    [T300Vel(i+1), T300Std(i+1)] = tempFind(fname);
end
% 
% % T = 75k
% T75Vel = zeros(1,5);
% T75Std = zeros(1,5);
% 
% for i = 0:4
%     fname = sprintf('T_75K_Force_%.1fpN.veldcd',0.8+i);
%     [T75Vel(i+1), T75Std(i+1)] = tempFind(fname);
% end
% 
% % T = 20k
% T20Vel = zeros(1,5);
% T20Std = zeros(1,5);
% 
% for i = 0:4
%     fname = sprintf('T_20K_Force_%.1fpN.veldcd',0.8+i);
%     [T20Vel(i+1), T20Std(i+1)] = tempFind(fname);
% end
% 
% % T = 5k
% T5Vel = zeros(1,5);
% T5Std = zeros(1,5);
% 
% for i = 0:4
%     fname = sprintf('T_55K_Force_%.1fpN.veldcd',0.8+i);
%     [T5Vel(i+1), T5Std(i+1)] = tempFind(fname);
% end


force = [0.8,1.8,2.8,3.8,4.8];

errorbar(force,T300Vel,T300Std,'--*r')
hold on
set(gca,'yscale','log')
set(gca,'xscale','log')







