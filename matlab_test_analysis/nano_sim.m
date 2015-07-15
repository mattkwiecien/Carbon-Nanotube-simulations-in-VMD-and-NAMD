% loading moving atoms
atomlist = 797;
xyzlist = readdcd('waterSim.dcd',atomlist);

%extracting x y z positions of atom1
ax = xyzlist(:,1);
ay = xyzlist(:,2);
az = xyzlist(:,3);

% Parameters 
t = 1e-9;
N = length(ax);
dt = t/N;

v = zeros(3,N-1);

for i=1:N-1
    v(1,i) = (ax(i) - ax(i+1)) /dt;
    v(2,i) = (ay(i) - ay(i+1)) /dt;
    v(3,i) = (az(i) - az(i+1)) /dt;
end
