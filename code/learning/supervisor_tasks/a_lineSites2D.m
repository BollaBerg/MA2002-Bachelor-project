% Attempt to create your own grid over the unit square [0,1]x[0,1], adding
% a straight line from [0.25, 0.25] to [0.75, 0.75] by using lineSites2D
cell_constraints = {[
    0.25, 0.25;
    0.75, 0.75;
]};
grid_size = 0.1;

% Compute constrained sites and distances between them
[constrained_sites, distances] = lineSites2D(cell_constraints, grid_size);

% To get a complete grid, we also have to distribute background sites
% These should not be closer to the cell constraints than the cell width,
% so we use removeConflictPoints to remove sites too close
% These background sites are equidistant
[X, Y] = meshgrid(linspace(0, 1, 1/grid_size));
background_sites = [X(:), Y(:)];
background_sites = removeConflictPoints(background_sites, constrained_sites, distances);

% Collect all sites
sites = [constrained_sites; background_sites];

% Create boundary and the clipped PEBI
boundary = [0, 0; 1, 0; 1, 1; 0, 1;];
G = clippedPebi2D(sites, boundary);

% Plot result
hold on;
plotGrid(G, 'faceColor', 'none');
plotLinePath(cell_constraints, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
title("Conforming Voronoi Grid");

% Print the underlying triangulation of the PEBI grid
% G.nodes.coords holds all corners of the grid
G.nodes.coords