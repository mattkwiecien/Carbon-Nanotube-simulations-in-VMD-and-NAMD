function [ bonds, angles, dihedrals ] = parsePSF(fileName)

% Open the file for reading.

fid = fopen(fileName);

% Get the first line.

nextLine = fgetl(fid);

% Loop through the lines until we get to the line indicating the start of
% the bonds section.

while isempty(strfind(nextLine, '!NBOND:'))

    nextLine = fgetl(fid);
    
end

% The bonds vector will hold a list of all the bonds in the file.

bonds = [];

% Get the next line and loop through the lines until we get to a blank line
% or the start of the angles section. (I think we always should hit the
% blank line first.)

nextLine = fgetl(fid);

while isempty(strfind(nextLine, '!NTHETA:')) && ~isempty(nextLine)
    
    % Read in the next set of bonds and then get the next line.
    
    bonds = [ bonds  cell2mat(textscan(nextLine, '%d'))' ]; %#ok<AGROW>
    nextLine = fgetl(fid);
  
end

% Each bond is identified by a pair of atoms. Turn our row vector into an
% array with two columns and one row for each bond pair. Then sort it.

bonds = reshape(bonds, [ 2, length(bonds)/2 ])';
bonds = sortrows(bonds, [ 1 2 ]);

% Skip what should be a blank line.
fgetl(fid);

% Repeat all of the above for the angles section.

angles = [];
nextLine = fgetl(fid);

while isempty(strfind(nextLine, '!NPHI:')) && ~isempty(nextLine)
    
    angles = [ angles  cell2mat(textscan(nextLine, '%d'))' ]; %#ok<AGROW>
    
    nextLine = fgetl(fid);
  
end

% Angles are indicated by triplets of three atoms, so turn the row vector
% of atoms into an array with three columns and one row per triplet. Then
% sort it.

angles = reshape(angles, [ 3, length(angles)/3 ])';
angles = sortrows(angles, [ 1 2 3 ]);

% According to
% 
% http://www.ks.uiuc.edu/Training/Tutorials/namd/namd-tutorial-win-html/node24.html
% 
% we can reverse the order of the triplets without changing the potential.
% So a triplet of 'a b c' should be considered the same as 'c b a'. Reorder
% the triplets so that the first atom in the triplet always has a smaller
% index than the last atom of the triplet. There might be a faster or more
% Matlab-native way to do this, but I'll just brute-force the sorting.

for i = 1:size(angles, 1)
   
    if angles(i, 1) > angles(i, 3)
        
        temp = angles(i, 3);
        angles(i, 3) = angles(i, 1);
        angles(i, 1) = temp;
        
    end
    
end

% Again, skip a line that should be blank.

fgetl(fid);

% Repeat everything one more time, for the dihedrals.

dihedrals = [];
nextLine = fgetl(fid);

while isempty(strfind(nextLine, '!NIMPHI:')) && ~isempty(nextLine)
    
    dihedrals = [ dihedrals  cell2mat(textscan(nextLine, '%d'))' ]; %#ok<AGROW>
    
    nextLine = fgetl(fid);
  
end

% Dihedrals are indicated by quadruples of for atoms, so turn the row
% vector of atoms into an array with four columns and one row per
% quadruple. Then sort it.

dihedrals = reshape(dihedrals, [ 4, length(dihedrals)/4 ])';
dihedrals = sortrows(dihedrals, [ 1 2 3 4 ]);

% According to
% 
% http://www.ks.uiuc.edu/Training/Tutorials/namd/namd-tutorial-win-html/node24.html
% 
% we can reverse the order of the quadruples without changing the
% potential. So a quadruple of 'a b c d' should be considered the same as
% 'd c b a'. Reorder the quadruples so that the first atom in the quadruple
% always has a smaller index than the last atom of the quadruple. There
% might be a faster or more Matlab-native way to do this, but I'll just
% brute-force the sorting.

for i = 1:size(dihedrals, 1)
   
    if dihedrals(i, 1) > dihedrals(i, 4)
        
        temp = dihedrals(i, 4);
        dihedrals(i, 4) = dihedrals(i, 1);
        dihedrals(i, 1) = temp;
        temp = dihedrals(i, 3);
        dihedrals(i, 3) = dihedrals(i, 2);
        dihedrals(i, 2) = temp;
       
    end
    
end

fclose(fid);

end
