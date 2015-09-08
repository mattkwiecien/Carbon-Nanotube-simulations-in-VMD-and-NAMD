function displacementSim(fin,nTot,temp,L,nRings,S,minimize)
% Parameters of Simulation
fname = strcat('/Users/nanotubes/Simulations/cnt200_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);
% Length of simulations
atomlist =  1:nTot;
xyzlist = readdcd(fname,atomlist);

% L=100;
% Extracting x y z velocities from the velocity matrix recovered from the
%              
% .veldcd file of simulation
x = xyzlist(:,1:3:end); %Angstroms
y = xyzlist(:,2:3:end); %Angstroms
z = xyzlist(:,3:3:end); %Angstroms


nWater = nRings+S;
nCarbon = nTot - (nWater*3);
Wells = zeros(1,nWater);

for j = 1:nWater
    lambda = (j-1)*2.480;
    Wells(j) = lambda;
end

f = figure;
for i = 1:L
    
    try
        clf(f);
    catch
        break
    end
    OxygenZ = z(i,nCarbon+1:3:nTot);
    u = OxygenZ - Wells; 
    %u = u/lambda;
    
    
    hold on
    box on
    set(gca,'fontsize',16)
    title(sprintf('(4,4) 200Ring CNT, 500ps, S = %d, minimize = %d',S,minimize))
    ylabel('U_{i}/\lambda')
    xlabel('i')
    xlim([1,nWater])
    ylim([-1,1])
    plot(1:nWater,u,'-b','linewidth',2)

    pause(0.05)


end
