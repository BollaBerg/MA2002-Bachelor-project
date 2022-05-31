resGridSize = 0.2;
domain = [0 0; 1 0; 1 1; 0 1];

faceConstraints = {[0.1 0.1; 0.5 0.9]};
cellConstraints = {[0.5 0.1; 0.9 0.9]};

G = pebiGrid2DGmshBase(resGridSize, domain, 'convertToPEBI', false);

axis off; hold on;
plotG = clippedPebi2D(G.nodes.coords, domain);
plotGrid(plotG, 'faceColor', 'none');
exportgraphics(gcf,'plots/constraints_MATLAB_1.png');

plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), color="blue", lineStyle="--", LineWidth=2);
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), color="magenta", lineStyle="--", LineWidth=2);
exportgraphics(gcf,'plots/constraints_MATLAB_2.png');

F = surfaceSites2D(faceConstraints, resGridSize/3);
[wellSites,cGs,protPts,pGs] = lineSites2D(cellConstraints, resGridSize/2);

% Remove conflict points
Pts = surfaceSufCond2D(G.nodes.coords,F);
Pts = removeConflictPoints(Pts, wellSites, cGs);
Pts = [Pts; wellSites; F.f.pts];

clf;
axis off; hold on;
G = clippedPebi2D(Pts, domain);
plotGrid(G, 'faceColor', 'none');
plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), color="blue", lineStyle="--", LineWidth=1);
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), color="magenta", lineStyle="--", LineWidth=1);
exportgraphics(gcf,'plots/constraints_MATLAB_3.png');
