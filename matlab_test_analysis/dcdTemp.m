%Tom Script

namdOutFile='/Users/mkwieci2/Simulations/cnt200_4x4/PBC/300/100000/LongRunAug20_T_300K_F_0.01pN.dcd';
[stat,tempData]=system(['awk "/^ENERGY:/ {printf \"%f\n\", \$13}" <' namdOutFile]);
TNAMD=str2num(tempData);

figure
plot(TNAMD)