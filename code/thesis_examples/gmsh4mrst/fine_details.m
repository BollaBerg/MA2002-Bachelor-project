% Set the default grid size
resGridSize = 0.1;

% Set the domain to the unit square
% We use kilometers as units
domain = [1 1];

% Set the size of cells near our well
cellConstraintFactor = 0.1;
cellConstraintPerpendicularFactor = 0.0001;  % 10 cm

% Create a simple well passing through the domain
cellConstraints = {
    [0.5 0.99; 0.3 0.01] ...
};

% Create the PEBI grid
G = pebiGrid2DGmshBase( ...
    resGridSize, ...
    domain, ...
    'cellConstraints', cellConstraints, ...
    'cellConstraintFactor', cellConstraintFactor, ...
    'cellConstraintPerpendicularFactor', cellConstraintPerpendicularFactor ...
);


% Plot result
axis off; hold on;
plotGrid(G, 'faceColor', 'none');
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), LineStyle="--", Color="magenta");

% Save plot
exportgraphics(gcf,'plots/fine_details.png')
