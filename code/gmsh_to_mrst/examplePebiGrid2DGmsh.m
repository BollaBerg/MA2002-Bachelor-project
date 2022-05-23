%% Example of pebiGrid2DGmsh usage
% Create a simple 2D mesh using Gmsh, called from MATLAB
clear all;
% Setup required variables
resGridSize = 0.2;
domain = [1, 1];
faceConstraints.a.x = [0.25 0.4 0.75];
faceConstraints.a.y = [0.25 0.5 0.75];
faceConstraints.b.x = [0.8 0.9];
faceConstraints.b.y = [0.1 0.2];
faceConstraints.theseCanHaveAnyNames.x = [0.2 0.9];
faceConstraints.theseCanHaveAnyNames.y = [0.9 0.1];
faceConstraints.alsoWorksWithSinglePoints.x = 0.1;
faceConstraints.alsoWorksWithSinglePoints.y = 0.1;

cellConstraints.a.x = 0.1;
cellConstraints.a.y = 0.1;
cellConstraints.b.x = [0.5 0.6 0.7 0.9];
cellConstraints.b.y = [0.8 0.7 0.8 0.6];

% pebiGrid2DGmsh returns a single variable, G
G = pebiGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);

% Plot result
hold on;
plotGrid(G, 'faceColor', 'none');

% Plot lines
plot(faceConstraints.a.x, faceConstraints.a.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
plot(faceConstraints.b.x, faceConstraints.b.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
plot(faceConstraints.theseCanHaveAnyNames.x, faceConstraints.theseCanHaveAnyNames.y, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
plot(cellConstraints.a.x, cellConstraints.a.y, 'LineWidth', 1, 'Color', 'blue', 'LineStyle','--', Marker='o');
plot(cellConstraints.b.x, cellConstraints.b.y, 'LineWidth', 1, 'Color', 'blue', 'LineStyle','--');

% Save plot
f = gcf;
exportgraphics(f,'examplePebiGrid2DGmsh.png')