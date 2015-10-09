function displacementSim(fin,temp,L,nRings,S,M)
% Parameters of Simulation
fname = strcat('/Users/mkwieci2/Simulations/cnt600_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
% Length of simulations
Nfactor = 16;

nWater = nRings+S;
nTot = (nRings*Nfactor)+(nWater*3);
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

% L=100;
% Extracting x y z velocities from the velocity matrix recovered from the
%              
% .dcd file of simulation
x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(:,3:3:end); %Angstroms


nCarbon = nRings*Nfactor;
Wells = zeros(1,nWater);

for j = 1:nWater
    lambda = (j-1)*(1.418*sqrt(3));
    Wells(j) = lambda;
end
Wells = Wells - 1.5;

lambda = (1.418*sqrt(3));

f = figure;
for i = 1:L+M
    
    try
        clf(f);
    catch
        break
    end
    OxygenZ = z(i,nCarbon+1:3:nTot);
    u = OxygenZ - Wells;
    u = u/lambda;
    
    
    hold on
    box on
    set(gca,'fontsize',16)
%     title(sprintf('(4,4) 200Ring CNT, %d ps, S = %d, minimize = %d',L,S,minimize))
    ylabel('U_{i}/\lambda')
    xlabel('i')
    xlim([1,nWater])
    ylim([-1,10])
    plot(1:nWater,u,'-b','linewidth',2)
%     title('(4,4) 200 Ring CNT, S = -1, heated carbons')
%   pause
    pause(0.1)

end
