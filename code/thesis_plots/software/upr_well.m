cellConstraints = {
    [0.1 0.1; 0.9 0.9], ...
    [0 0.4; 1 0.6]
};

G = pebiGrid2D(0.1, [1 1], ...
    'cellConstraints', cellConstraints ...
);

axis image off; hold on;
plotGrid(G, 'faceColor', 'none');
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), LineStyle="--", Color="magenta");
plot(cellConstraints{2}(:, 1), cellConstraints{2}(:, 2), LineStyle="--", Color="magenta");
exportgraphics(gcf, 'plots/UPR_well.png');

clf;
axis image off; hold on;
G = pebiGrid2D(0.1, [1 1], ...
    'cellConstraints', cellConstraints, ...
    'protLayer', true, ...
    'protD', {@(p) ones(size(p,1),1)*resGridSize/2} ...
);
plotGrid(G, 'faceColor', 'none');
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), LineStyle="--", Color="magenta");
plot(cellConstraints{2}(:, 1), cellConstraints{2}(:, 2), LineStyle="--", Color="magenta");
exportgraphics(gcf, 'plots/UPR_well_protLayer.png');