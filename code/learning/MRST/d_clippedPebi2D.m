% EXAMPLE 4 (PAGE 11) OF Berge, Klemetsdal et.al.

% Start by defining the boundary as a polygon
% We create something that looks like a house, just for fun
boundary = [
    0, 0;
    1, 0;
    1, 1;
    0.5, 1.2;
    0, 1;
];
% NOTE: All sites must be within boundary

% Create random sites
sites = rand(30, 2);

% Generate Voronoi grid
G = clippedPebi2D(sites, boundary);

% Plot
figure();
plotGrid(G);