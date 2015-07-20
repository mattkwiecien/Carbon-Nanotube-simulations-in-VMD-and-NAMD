% loading moving atoms
atomlist = 797;
xyzlist = readdcd('velsSim.dcd',atomlist);

%extracting x y z positions of atom1
ax = xyzlist(:,1);
ay = xyzlist(:,2); % A
az = xyzlist(:,3);

% Parameters 
t = 10e-12;
N = length(ax)
dt = t/N

v = zeros(3,N-1);

for i=1:N-1
    v(1,i) = (ax(i) - ax(i+1)) /dt;
    v(2,i) = (ay(i) - ay(i+1)) /dt; % A / ps
    v(3,i) = (az(i) - az(i+1)) /dt;
end

m = 3e-26; %mass of water molecule in kg
k = 1.38065e-23; %boltzmann J/K



KE = (0.5*m).*( sqrt(v(1,:).^2 + v(2,:).^2 + v(3,:).^2 ) );%convert A/ns to m/s

KEave = mean(KE);

T = (2/3)*(1/k)*( KEave )
