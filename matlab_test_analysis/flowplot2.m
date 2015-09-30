[m1,s1] = tempFind('T5_F0.01pN.veldcd',5,50,600,-1,0,8000);
[m2,s2] = tempFind('T5_F0.06pN.veldcd',5,50,600,-1,0,8000);
[m3,s3] = tempFind('T5_F0.32pN.veldcd',5,50,600,-1,0,8000);
[m4,s4] = tempFind('T5_F1.78pN.veldcd',5,50,600,-1,0,8000);
[m5,s5] = tempFind('T5_F10.00pN.veldcd',5,50,600,-1,0,8000);

figure
hold on
set(gca,'xscale','log')
set(gca,'yscale','log')
box on
m = [m1, m2, m3, m4, m5]
s = [s1, s2, s3, s4, s5];
forces = [0.01,0.06,0.32,1.78,10.00];

plot(forces,m)

