% Setup required variables
resGridSize = 0.1;
domain = [1 1];
faceConstraints = {
    [0.1 0.1; 0.9 0.9], ...
    [0.5 0.1; 0.5 0.9], ...
    [0.9 0.1; 0.1 0.9], ...
%     [0.1 0.5; 0.9 0.5], ...
};
cellConstraints = {
    [0.4 1; 0.7 0.8; 0.9 0.2]
};

% pebi
G = pebiGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);
% Plot result
axis off; hold on;
plotGrid(G, 'faceColor', 'none');
for i = 1:length(faceConstraints)
    plot(faceConstraints{i}(:, 1), faceConstraints{i}(:, 2), LineStyle="--", Color="blue");
end
for i = 1:length(cellConstraints)
    plot(cellConstraints{i}(:, 1), cellConstraints{i}(:, 2), LineStyle="--", Color="magenta");
end
% Save plot
% exportgraphics(gcf,'plots/demo_pebiGrid2DGmsh.png')
