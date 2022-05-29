% Setup required variables
resGridSize = 0.1;
domain = [1 1];
faceConstraints = {
    [0.1 0.1; 0.4 0.3; 0.2 0.5; 0.1 0.8; 0.4 0.9];
};
cellConstraints = {
    [0.9 0.9; 0.6 0.7; .8 0.5; 0.9 0.2; 0.6 0.1];
};

% pebi
G = pebiGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);
% Plot result
axis off;
plotGrid(G, 'faceColor', 'none');
% Save plot
exportgraphics(gcf,'plots/demo_pebiGrid2DGmsh.png')

clf;

% Delaunay
G = delaunayGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints, ...
    'cellConstraintPerpendicularFactor', 1 ...
);
% Plot result
axis off;
plotGrid(G, 'faceColor', 'none');
% Save plot
exportgraphics(gcf,'plots/demo_delaunayGrid2DGmsh.png')

clf;

% Base
G = pebiGrid2DGmshBase( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints, ...
    'convertToPEBI', false, ...
    'faceConstraintPerpendicularCells', int8(3), ...
    'faceConstraintPerpendicularFactor', 1, ...
    'cellConstraintPerpendicularFactor', 1, ...
    'cellConstraintPerpendicularCells', int8(2) ...
);
% Plot result
axis off;
plotGrid(G, 'faceColor', 'none');
% Save plot
exportgraphics(gcf,'plots/demo_pebiGrid2DGmshBase.png')

clf;

% Base - PEBI
G = pebiGrid2DGmshBase( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints, ...
    'cellConstraintPerpendicularFactor', 1 ...
);
% Plot result
axis off;
plotGrid(G, 'faceColor', 'none');
% Save plot
exportgraphics(gcf,'plots/demo_pebiGrid2DGmshBase_PEBI.png')