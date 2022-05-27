n = 5;

[X, Y] = meshgrid(linspace(0.15, 0.7, n), linspace(0.25, 0.95, n));

% pebi fails along boundary if circumenter of traingle is outside the
% convex hull of sites, so we include only inner points
isIn = false(n, n);
isIn(2:end-1, 2:end-1) = true;
sites = [X(:), Y(:)];
sites(isIn(:), :) = sites(isIn(:), :) + 0.1 * randn((n-2)^2, 2);

% Add needed points for our constraints
faceSites = [
    0.2 0.6;
    0.25 0.65;
    0.3 0.7;
    0.35 0.75;
    0.4 0.8;
    0.45 0.85;
    0.5 0.9;
    0.5 0.85;
    0.5 0.8;
    0.5 0.75;
    0.5 0.7;
    0.5 0.65;
    0.5 0.6;
    0.55 0.7;
    0.6 0.8;
    0.65 0.9;
];
cellSites = [
    0.30 0.49;
    0.32 0.51;
    0.32 0.45;
    0.34 0.47;
    0.34 0.41;
    0.36 0.43;
    0.36 0.37;
    0.38 0.39;
    0.38 0.31;
    0.40 0.33;
    0.40 0.28;
    0.42 0.31;
    0.42 0.39;
    0.44 0.37;
    0.44 0.43;
    0.46 0.41;
    0.46 0.47;
    0.48 0.45;
    0.48 0.51;
    0.50 0.49;
];
cellLine = [
    0.31 0.5;
    0.4 0.3;
    0.49 0.5;
];

sites = [sites; faceSites; cellSites];

DT = triangleGrid(sites);
PEBI = pebi(DT);

axis off; hold on;
plotGrid(DT, 'faceColor', 'none');
plot(faceSites(:, 1), faceSites(:, 2), color="magenta", LineStyle="--",LineWidth=2);
plot(cellLine(:, 1), cellLine(:, 2), color="blue", LineStyle="--",LineWidth=2);
exportgraphics(gcf,"plots/gmsh_conversion_triangulation.png");
clf;

axis off; hold on;
plotGrid(PEBI, 'faceColor', 'none');
plot(faceSites(:, 1), faceSites(:, 2), color="magenta", LineStyle="--",LineWidth=2);
plot(cellLine(:, 1), cellLine(:, 2), color="blue", LineStyle="--",LineWidth=2);
exportgraphics(gcf,"plots/gmsh_conversion_PEBI.png");

