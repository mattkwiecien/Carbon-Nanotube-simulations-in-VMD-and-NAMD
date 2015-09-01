function [mean_vel, std_vel, temps,stds] = tempFind(fin,nTot,temp,L,nRings,S,mode)
% Parameters of Simulation
fname = strcat('/Users/nanotubes/Simulations/cnt200_4x4/PBC/',num2str(temp),'/',num2str(L*1000),'/',fin);

% Length of simulations
atomlist = 1:nTot;
xyzlist = readdcd(fname,atomlist);

% Extracting x y z velocities from the velocity matrix recovered from the
% .veldcd file of simulation
vx = xyzlist(:,1:3:end);
vy = xyzlist(:,2:3:end); 
vz = xyzlist(:,3:3:end);

% Velocities need to be multiplied by a factor to convert units to
% angstroms/picosecond, done below
vx = vx.*(20.45482706); %1 A/ps 
vy = vy.*(20.45482706); %1 A/ps 
vz = vz.*(20.45482706); %1 A/ps 

nWater = nRings+S;
nCarbon = nTot - (nWater*3);

% Two modes here: 0 is what is used for simply getting the mean and
% standard deviation of the water molecules.  1 is used for bug checking
% the simulation and ensuring that the kinetic energy and temperature is
% correct.

switch mode
    case 0
    % Two different arrays here: one is taking the magnitude of the  
    % velocity of the hydrogens and the oxygens and taking that total 
    % velocity to be the velocity of the water.  However, rigidBonds is
    % on in the simulation, so the hydrogen isn't really moving in the
    % z-direction different than the water, so it just takes the
    % velocity of the oxygen to be the velocity of the water. 

    % Using vWater2 for the reasons above.

    %vWater = zeros(nWater,simLength);
    vWater2 = zeros(nWater,L); 
    for i = 1:L
        %vWater(:,i) = sqrt( vx(i,nCarbon+2:3:nTot).^2 + vy(i,nCarbon+2:3:nTot).^2 + vz(i,nCarbon+2:3:nTot).^2 );
        % Velocity of all of the waters at 1 timestep of simulation
        vWater2(:,i) = vz(i,nCarbon+2:3:nTot);
    end

    % (:,5:end) is put in here to wait until the simulation
    % equilibrates to the simulation temperature.  This was just found
    % by looking at different simulations, and could definitely be
    % improved.

    %First mean is the average velocity at each time step, second mean is
    %the average velocity over the entire simulation.
    mean_vel = (mean(mean(vWater2,1)));
    std_vel = std(mean(vWater2,1));

    % Optional plotting if interested in seeing comparison between the
    % total magnitude of the velocity and the regular velocity.
%         figure
%         hold on
%         set(gca, 'fontsize', 14)
%         xlabel('Time (ps)')
%         ylabel('Velocity (A/ps)')
%         plot(1:length, mean(vWater2,1), '--*b','linewidth',2)
%         plot(1:length, mean(vx(:,nCarbon+1:3:nTot),2),'--r', 1:length, mean(vy(:,nCarbon+1:3:nTot),2),'--r', 1:length, mean(vz(:,nCarbon+1:3:nTot),2),'--k')
%         legend('|v| water', 'vx water', 'vy water', 'vz water')

        temps = 0; stds = 0;
    case 1
    
    % Masses of different atoms
    %mH = 1.674e-27;        
    %mHydrogen = mH.*ones(1,nWater);
    mO = 2.6567626e-26; % kg
    mC = 1.99442e-26; %kg 
    % Boltzmann constant
    k = 1.38065e-23; %boltzmann J/K

    % Using the fact that KE = 1/2 mv^2 to find KE of each atom.
    for i = 1:L

       KEO_x = (0.5*mO).*(vx(i,nCarbon+2:3:nTot).^2);
       KEO_y = (0.5*mO).*(vy(i,nCarbon+2:3:nTot).^2);
       KEO_z = (0.5*mO).*(vz(i,nCarbon+2:3:nTot).^2); % [KE] = kg m^2 s^-2

       C_x = (0.5*mC).*(vx(i,1:nCarbon+1).^2);
       C_y = (0.5*mC).*(vy(i,1:nCarbon+1).^2);
       C_z = (0.5*mC).*(vz(i,1:nCarbon+1).^2);
       
    end

    % From the fact that KE = 3/2 k T we have
    %  T = 2 KE / k for each degree of freedom.
    Tx = (2/k).*KEO_x;
    Ty = (2/k).*KEO_y;
    Tz = (2/k).*KEO_z;
    
    Cx = (2/k).*C_x;
    Cy = (2/k).*C_y;
    Cz = (2/k).*C_z;
    
    Txmean = mean(Tx);
    Tymean = mean(Ty);
    Tzmean = mean(Tz);
    
    Cxmean = mean(Cx);
    Cymean = mean(Cy);
    Czmean = mean(Cz);
    
    stdx = std(Tx);
    stdy = std(Ty);
    stdz = std(Tz);
    
    stdxc = std(Cx);
    stdyc = std(Cy);
    stdzc = std(Cz);
    
    temps = [Txmean,Tymean,Tzmean,Cxmean,Cymean,Czmean];
    stds = [stdx,stdy,stdz,stdxc,stdyc,stdzc];
    
    % temporary to allow code to run
    mean_vel = 0;
    std_vel = 0;

%     figure
%     hold on
%     set(gca,'fontsize',14)
%     set(gca,'linewidth',2)
%     xlabel('Time (ps)')
%     ylabel('Temperature (K)')
%     title('T_{therm} = 300K, F = 5.34pN')
%     plot(1:199,Tx,'--*r', 1:199,Ty,'--*k', 1:199,Tz,'--*b')
%     legend('T_{x}','T_{y}', 'T_{z}')

end


end



