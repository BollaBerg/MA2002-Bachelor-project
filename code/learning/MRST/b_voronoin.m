% EXAMPLE 2 (PAGE 10) OF Berge, Klemetsdal et.al.

% Create flags for non-boundary cells
keep = false(11, 11, 11);
keep(2:10, 2:10, 1:11) = true;

% Create sites to use for generating Voronoi grid
[X, Y, Z] = meshgrid(linspace(0, 1, 11));
% Scew the X-axis slightly, similar as it is done for the example
% Note: I've tried scewing the Z-axis, but that produces (extremely) weird
% plots - figure out why!
sites = [X(:)+0.4*Y(:).^2 Y(:)+0.1*X(:).^2 Z(:)];

% Use voronoin to create voronoi grid of sites
[V, C] = voronoin(sites);   % V = Vertices, C = map from each cell to its vertices
% Keep only non-boundary cells
C = C(keep(:));
% Create a 3D MRST grid
grid = voronoi2mrstGrid3D(V, C);

% Plot figure
figure
plotGrid(grid); view(120, 25)
axis equal tight off, camlight headlight
set(gca,'DataAsp',[1 .7 2.5])