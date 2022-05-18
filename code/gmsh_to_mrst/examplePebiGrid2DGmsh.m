%% Example of pebiGrid2DGmsh usage
% Create a simple 2D mesh using Gmsh, called from MATLAB

% Setup required variables
resGridSize = 0.25;
domain = [1, 1];
faceConstraints.a.x = [0.25 0.4 0.75];
faceConstraints.a.y = [0.25 0.5 0.75];
faceConstraints.b.x = [0.8 0.9];
faceConstraints.b.y = [0.1 0.2];
faceConstraints.theseCanHaveAnyNames.x = [0.2 0.9];
faceConstraints.theseCanHaveAnyNames.y = [0.9 0.1];

% pebiGrid2DGmsh returns a single variable, G
G = pebiGrid2DGmsh(resGridSize, domain, faceConstraints);

% Plot result
hold on;
plotGrid(G, 'faceColor', 'none');

% Plot lines
plot(faceConstraints.a.x, faceConstraints.a.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
plot(faceConstraints.b.x, faceConstraints.b.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
plot(faceConstraints.theseCanHaveAnyNames.x, faceConstraints.theseCanHaveAnyNames.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);

% Save plot
f = gcf;
exportgraphics(f,'examplePebiGrid2DGmsh.png')