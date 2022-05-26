resGridSize = 0.2;
domain = [1 1];

algorithms = [
    "meshadapt", "delaunay", "frontal", "bamg", "delquad"
];

for i = 1:length(algorithms)
    G = pebiGrid2DGmsh( ...
        resGridSize, ...
        domain, ...
        'meshAlgorithm', algorithms{i} ...
    );
    
    axis off;
    plotGrid(G, 'faceColor', 'none');
    exportgraphics(gcf,"plots/gmsh_meshing_algorithms_" + algorithms{i} + ".png");
    clf;
end

faceConstraints = {[0.2 0.2; 0.8 0.8]};
for i = 1:length(algorithms)
    G = pebiGrid2DGmsh( ...
        resGridSize, ...
        domain, ...
        'faceConstraints', faceConstraints, ...
        'meshAlgorithm', algorithms{i} ...
    );
    
    hold on;
    axis off;
    plotGrid(G, 'faceColor', 'none');
    plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), 'lineWidth', 2, 'color', 'magenta', 'LineStyle','-');
    exportgraphics(gcf,"plots/gmsh_meshing_algorithms_embedded_" + algorithms{i} + ".png");
    clf;
end