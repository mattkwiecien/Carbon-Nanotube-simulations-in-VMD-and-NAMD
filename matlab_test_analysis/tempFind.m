function [mean_vel, std_vel] = tempFind(fname,mode)
% Parameters of Simulation
% Total number of atoms
nTot = 3813;
% Length of simulations
length = 25;
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

nCarbon = 3216;
nWater = 199;

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
        
        vWater = zeros(nWater,length);
        vWater2 = zeros(nWater,length); 
        for i = 1:length
            vWater(:,i) = sqrt( vx(i,nCarbon+1:3:nTot).^2 + vy(i,nCarbon+1:3:nTot).^2 + vz(i,nCarbon+1:3:nTot).^2 );
            vWater2(:,i) = vz(i,nCarbon+1:3:nTot);
        end
        
        % (:,5:end) is put in here to wait until the simulation
        % equilibrates to the simulation temperature.  This was just found
        % by looking at different simulations, and could definitely be
        % improved.
        
        mean_vel = mean(mean(vWater2,1));
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
        
    case 1
        
        % Masses of different atoms
        mC = 1.994e-26;
        mH = 1.674e-27;
        mO = 2.657e-26;
        mCarbon = mC.*ones(1,nCarbon);
        mOxygen = mO.*ones(1,nWater);
        mHydrogen = mH.*ones(1,nWater);
        % Boltzmann constant
        k = 1.38065e-23; %boltzmann J/K
        % Creating these different arrays to loop through each timestep of
        % the simulation and find the kinetic energy at that point
        KEcarbon = zeros(nCarbon,length);
        KEoxy = zeros(nWater,length);
        KEhydro1 = zeros(nWater,length);
        KEhydro2 = zeros(nWater,length);
        
        % Using the fact that KE = 1/2 mv^2 to find KE of each atom.
        for i = 1:length
           KEcarbon(:,i) = 0.5 .* ( mCarbon .* sqrt( vx(i,1:nCarbon).^2 + vy(i,1:nCarbon).^2 + vz(i,1:nCarbon).^2).^2 );
           KEoxy(:,i) = 0.5.*( mOxygen .* sqrt(vx(i,nCarbon+1:3:nTot).^2 + vy(i,nCarbon+1:3:nTot).^2 + vz(i,nCarbon+1:3:nTot).^2).^2 );
           KEhydro1(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,nCarbon+2:3:nTot).^2 + vy(nCarbon+2:3:nTot).^2 + vz(nCarbon+2:3:nTot).^2).^2 );
           KEhydro2(:,i) = 0.5.*( mHydrogen .* sqrt(vx(i,nCarbon+3:3:nTot).^2 + vy(i,nCarbon+3:3:nTot).^2 + vz(i,nCarbon+3:3:nTot).^2).^2 );
        end
    
        KEaveOxy = mean(KEoxy);
        KEaveH1 = mean(KEhydro1);
        KEaveH2 = mean(KEhydro2);
        KEaveCarbon = mean(KEcarbon);
        % Assuming 3 degrees of freedom, we have temperature calculated as
        % below
        Tcarbon = (2/3)*(1/k)* KEaveCarbon;
        Toxy = (2/3)*(1/k)* KEaveOxy;
        Th1 = (2/3)*(1/k)* KEaveH1;
        Th2 = (2/3)*(1/k)* KEaveH2;
        
        figure
        hold on
        set(gca,'fontsize',14)
        xlabel('Time (ps)')
        ylabel('Temperature (K)')
        title('T=1 K, L=10 ps, S = -1, 300 rings')
        plot(1:length,Tcarbon,'--*r', 1:length,Toxy,'--*b', 1:length,Th1,'--*g', 1:length,Th2,'--*k')
        legend('Carbon','Oxygen', 'Hydrogen 1','Hydrogen 2')

end


end



