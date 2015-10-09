function flowRate

% fname = "meetOct1_Run{0:s}_F{1:s}pN"
forces = [0.03, 0.05, 0.1, 0.2, 0.4, 0.8];

[f1a] = tempFind('Oct1_Run1_F0.03pN',5,50,600,-1,0,8);
[f1b] = tempFind('Oct1_Run2_F0.03pN',5,50,600,-1,0,8);
[f1c] = tempFind('meetOct1_Run1_F0.03pN',5,50,600,-1,0,8);
[f1d] = tempFind('meetOct1_Run2_F0.03pN',5,50,600,-1,0,8);
[f1e] = tempFind('meetOct1_Run3_F0.03pN',5,50,600,-1,0,8);
[f1f] = tempFind('meetOct1_Run4_F0.03pN',5,50,600,-1,0,8);

[f2a] = tempFind('Oct1_Run1_F0.05pN',5,50,600,-1,0,8);
[f2b] = tempFind('Oct1_Run2_F0.05pN',5,50,600,-1,0,8);
[f2c] = tempFind('meetOct1_Run1_F0.05pN',5,50,600,-1,0,8);
[f2d] = tempFind('meetOct1_Run2_F0.05pN',5,50,600,-1,0,8);
[f2e] = tempFind('meetOct1_Run3_F0.05pN',5,50,600,-1,0,8);
[f2f] = tempFind('meetOct1_Run4_F0.05pN',5,50,600,-1,0,8);

[f3a] = tempFind('Oct1_Run1_F0.10pN',5,50,600,-1,0,8);
[f3b] = tempFind('Oct1_Run2_F0.10pN',5,50,600,-1,0,8);
[f3c] = tempFind('meetOct1_Run1_F0.10pN',5,50,600,-1,0,8);
[f3d] = tempFind('meetOct1_Run2_F0.10pN',5,50,600,-1,0,8);
[f3e] = tempFind('meetOct1_Run3_F0.10pN',5,50,600,-1,0,8);
[f3f] = tempFind('meetOct1_Run4_F0.10pN',5,50,600,-1,0,8);

[f4a] = tempFind('Oct1_Run1_F0.20pN',5,50,600,-1,0,8);
[f4b] = tempFind('Oct1_Run2_F0.20pN',5,50,600,-1,0,8);
[f4c] = tempFind('meetOct1_Run1_F0.20pN',5,50,600,-1,0,8);
[f4d] = tempFind('meetOct1_Run2_F0.20pN',5,50,600,-1,0,8);
[f4e] = tempFind('meetOct1_Run3_F0.20pN',5,50,600,-1,0,8);
[f4f] = tempFind('meetOct1_Run4_F0.20pN',5,50,600,-1,0,8);

[f5a] = tempFind('meetOct1_Run1_F0.40pN',5,50,600,-1,0,8);
[f5b] = tempFind('meetOct1_Run2_F0.40pN',5,50,600,-1,0,8);
[f5c] = tempFind('meetOct1_Run3_F0.40pN',5,50,600,-1,0,8);
[f5d] = tempFind('meetOct1_Run4_F0.40pN',5,50,600,-1,0,8);

[f6a] = tempFind('meetOct1_Run1_F0.80pN',5,50,600,-1,0,8);
[f6b] = tempFind('meetOct1_Run2_F0.80pN',5,50,600,-1,0,8);
[f6c] = tempFind('meetOct1_Run3_F0.80pN',5,50,600,-1,0,8);
[f6d] = tempFind('meetOct1_Run4_F0.80pN',5,50,600,-1,0,8);

ps_ns = 1000;
f1 = horzcat(f1a,f1b,f1c,f1d,f1e,f1f).*ps_ns;
f2 = horzcat(f2a,f2b,f2c,f2d,f2e,f2f).*ps_ns;
f3 = horzcat(f3a,f3b,f3c,f3d,f3e,f3f).*ps_ns;
f4 = horzcat(f4a,f4b,f4c,f4d,f4e,f4f).*ps_ns;
f5 = horzcat(f5a,f5b,f5c,f5d).*ps_ns;
f6 = horzcat(f6a,f6b,f6c,f6d).*ps_ns;

flow_f1 = mean(mean(f1,1));
std_f1 = std(mean(f1,1));

flow_f2 = mean(mean(f2,1));
std_f2 = std(mean(f2,1));

flow_f3 = mean(mean(f3,1));
std_f3 = std(mean(f3,1));

flow_f4 = mean(mean(f4,1));
std_f4 = std(mean(f4,1));

flow_f5 = mean(mean(f5,1));
std_f5 = std(mean(f5,1));

flow_f6 = mean(mean(f6,1));
std_f6 = std(mean(f6,1));

figure
hold on
box on
set(gca,'fontsize',14)
set(gca,'xscale','log')
% set(gca,'yscale','log')

% errorbar(forces, [flow_f1, flow_f2, flow_f3, flow_f4, flow_f5, flow_f6],...
%     [std_f1, std_f2, std_f3, std_f4, std_f5, std_f6], '--*b', 'linewidth',2)
plot(forces, [flow_f1, flow_f2, flow_f3, flow_f4, flow_f5, flow_f6], '--*b', 'linewidth',2)
ylabel('Flowrate (A/ns)')
xlabel('Forcing (pN)')
title('Six (4,4) 600 ring S=-1, 50ps simulations at T = 5K')

end

