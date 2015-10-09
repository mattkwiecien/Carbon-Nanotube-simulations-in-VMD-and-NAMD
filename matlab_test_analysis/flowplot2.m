[m1,~,~] = tempFind('Oct1_Run1_F0.03pN',5,50,600,-1,0,8);
[m11,~,~] = tempFind('Oct1_Run2_F0.03pN',5,50,600,-1,0,8);
[m2,~,~] = tempFind('Oct1_Run1_F0.05pN',5,50,600,-1,0,8);
[m22,~,~] = tempFind('Oct1_Run2_F0.05pN',5,50,600,-1,0,8);
[m3,~,~] = tempFind('Oct1_Run1_F0.10pN',5,50,600,-1,0,8);
[m33,~,~] = tempFind('Oct1_Run2_F0.10pN',5,50,600,-1,0,8);
[m4,~,~] = tempFind('Oct1_Run1_F0.20pN',5,50,600,-1,0,8);
[m44,~,~] = tempFind('Oct1_Run2_F0.20pN',5,50,600,-1,0,8);

ma = horzcat(m1,m11);
mb = horzcat(m2,m22);
mc = horzcat(m3,m33);
md = horzcat(m4,m44);

mean1 = mean(ma,1);
mean2 = mean(mb,1);
mean3 = mean(mc,1);
mean4 = mean(md,1);

m1 = mean(mean1,2);
m2 = mean(mean2,2);
m3 = mean(mean3,2);
m4 = mean(mean4,2);




figure
hold on
set(gca,'xscale','log')
set(gca,'yscale','log')
box on
s = [std(mean1), std(mean2), std(mean3), std(mean4)];
forces = [0.03,0.05,0.10,0.20];

plot(forces,[m1, m2, m3, m4])

