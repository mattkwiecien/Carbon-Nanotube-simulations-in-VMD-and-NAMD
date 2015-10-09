function displacementSim(fin,temp,L,nRings,S,M)
% Parameters of Simulation
fname = strcat('/Users/nanotubes/Simulations/cnt50_4x4/','PBC/',...
    fin,'_run/',num2str(temp),'/',num2str(L*1000),'/',fin,'.dcd');

% Specific factor for different (n,m) nanotubes
Nfactor = 16;
nCarbon = nRings*Nfactor;
nWater = nRings+S;
nTot = (nCarbon)+(nWater*3);
atomlist =  1:nTot;

% Extracting x y z velocities from the velocity matrix recovered from the              
% .dcd file of simulation
xyzlist = readdcd(fname,atomlist);
z = xyzlist(:,3:3:end); %Angstroms

Wells = zeros(1,nWater);

for j = 1:nWater
    lambda = (j-1)*(1.418 *sqrt(3));
    Wells(j) = lambda;
end
% % 
% % % W = horzcat(flip(-Wells(2:end)),-Wells);
% Wells = horzcat(Wells(1:end-1),flip(-Wells(1:end)));
% % Offsetting method, temporary
whos

lambda = (1.418*sqrt(3));

% for j = 1:nWater
%     if j<nWater/2 +1
%         Wells(j) = (j-1)*lambda;
%     else
%         Wells(j) = (-nWater*lambda)+((j-1)*lambda);
%     end
% end

Wells = Wells - 1.5;

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
    ylabel('U_{i}/\lambda')
    xlabel('i')
    xlim([1,nWater])
    ylim([-2,10])
    plot(1:nWater,u,'-b','linewidth',2)
    pause(0.1)

end
