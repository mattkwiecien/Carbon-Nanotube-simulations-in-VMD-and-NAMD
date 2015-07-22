function comparePSF(fileName1, fileName2)

% The output of parsePDF consists of three arrays.
% The first is a 2xN array of bond pairs.
% The second is a 3xN array of angle triplets.
% The third is a 4xN array of dihedral quadruples.

[ b1, a1, d1 ] = parsePSF(fileName1);

[ b2, a2, d2 ] = parsePSF(fileName2);

% The Matlab function 'setdiff' does all the magic here.

fprintf('bonds in %s and not in %s:\n\n', fileName1, fileName2)

disp(setdiff(b1, b2, 'rows'))

fprintf('bonds in %s and not in %s:\n\n', fileName2, fileName1)

disp(setdiff(b2, b1, 'rows'))

fprintf('angles in %s and not in %s:\n\n', fileName1, fileName2)

disp(setdiff(a1, a2, 'rows'))

fprintf('angles in %s and not in %s:\n\n', fileName2, fileName1)

disp(setdiff(a2, a1, 'rows'))

fprintf('dihedrals in %s and not in %s:\n\n', fileName1, fileName2)

disp(setdiff(d1, d2, 'rows'))

fprintf('dihedrals in %s and not in %s:\n\n', fileName2, fileName1)

disp(setdiff(d2, d1, 'rows'))

end