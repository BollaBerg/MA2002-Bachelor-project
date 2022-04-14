% EXAMPLE 3 (PAGE 10) OF Berge, Klemetsdal et.al.
% Create a PEBI grid bounded by a complex polygonal in 3D

pts = rand(10, 3);

% Define boundary
% Unit cube (from example)
bnd = [0 0 1 1 0 0 1 1; ...
       0 1 1 0 0 1 1 0; ...
       0 0 0 0 1 1 1 1]';

% Some other weird figure
pts2 = pts + 1;
bnd2 = [0 -0.1 1 1 0 0 1.5 1; ...
       0 1.2 1.5 0 0 1 1 0; ...
       0 0 1 0 1 1.5 1 1]';
bnd2 = bnd2 + 1;

% Pyramid
pts3 = pts + 2.5;
bnd3 = [0 1 1 0 0.5; ...
       0 0 1 1 0.5; ...
       0 0 0 0 1]';
bnd3 = bnd3 + 2.5;

% Create clipped PEBI grid
G1 = mirroredPebi3D(pts, bnd);
G2 = mirroredPebi3D(pts2, bnd2);
G3 = mirroredPebi3D(pts3, bnd3);

% Plot figure
figure();
plotGrid(G1);
plotGrid(G2);
plotGrid(G3);
set(gca, 'zdir', 'normal')
view(30, 20), axis equal off tight