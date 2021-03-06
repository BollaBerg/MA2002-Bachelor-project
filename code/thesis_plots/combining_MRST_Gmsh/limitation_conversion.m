resGridSize = 0.2;
domain = [1 1];

faceConstraints = {[0.2 0.6; 0.5 0.9; 0.7 0.6; 0.8 0.6]};
cellConstraints = {[0.2 0.4; 0.5 0.1; 0.6 0.5; 0.65 0.1; 0.8 0.4]};

G = pebiGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);

axis off; hold on;
plotGrid(G, 'faceColor', 'none');
plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), color="magenta", LineStyle="--",LineWidth=2);
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), color="blue", LineStyle="--",LineWidth=2);
exportgraphics(gcf,"plots/limitation_conversion_triangulation.png");
clf;

G = clippedPebi2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);

axis off; hold on;
plotGrid(G, 'faceColor', 'none');
plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), color="magenta", LineStyle="--",LineWidth=2);
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), color="blue", LineStyle="--",LineWidth=2);
exportgraphics(gcf,"plots/limitation_conversion_PEBI.png");

