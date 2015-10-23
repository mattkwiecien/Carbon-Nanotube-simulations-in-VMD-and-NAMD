function displacementSim(fin,temp,L,nRings,S,M,N,force,c_status)
% Parameters of Simulation
fname = strcat('/Users/Guru/Desktop/',fin,'_run/',num2str(temp),'/',num2str(L*1000),...
    '/',fin,'.dcd');

ts1 = strcat(c_status,' (',num2str(N),'x',num2str(N),') Nanotube with S=',num2str(S));
ts2 = strcat('Force=',num2str(force),'pN over L=',num2str(L),' ps at',' T=',num2str(temp),'K');

% Figure parameters
width = 10;     % Width in inches
height = 6;    % Height in inches
alw = 0.5;    % AxesLineWidth
fsz = 11;      % Fontsize


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
lambda = (1.418*sqrt(3));
Wells = Wells - 0.5;


f = figure;
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hold on
box on
title({ts1,ts2})
set(gca,'fontsize',14)
ylabel('U_{i}/\lambda')
xlabel('i')
xlim([1,nWater])
ylim([-1,3])
pause
for i = 1:10:L
    
    try
        clf(f);
    catch
        break
    end
    
    OxygenZ = z(i,nCarbon+1:3:nTot);
    u = OxygenZ - Wells;
    u = u/lambda;
       
    timestr = strcat('Time=',num2str(i),'ps');    
    hold on
    box on
    title({ts1,ts2})
    set(gca,'fontsize',14)
    ylabel('U_{i}/\lambda')
    xlabel('i')
    xlim([1,nWater])
    ylim([-1,3])
    annotation('textbox',[.2 .5 .3 .3],'String',timestr,'FitBoxToText','on');
    plot(1:5:nWater,u(1:5:end),'-ob','linewidth',0.1)
    pause(0.001)
    
end
