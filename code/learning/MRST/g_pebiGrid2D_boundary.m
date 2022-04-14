% EXAMPLE 7 (PAGE 13) OF Berge, Klemetsdal et.al.

h = 0.1;
domain = [1, 1];

% Make a boundary somewhat like a U (for UPR)
boundary = [
    0,   0.3;
    0.3, 0;
    0.7, 0;
    1,   0.3;
    1,   1;
    0.7, 1;
    0.7, 0.5;
    0.5, 0.4;
    0.3, 0.5;
    0.3, 1;
    0,   1;
];

[pebi_grid, sites] = pebiGrid2D(h, domain, 'polyBdr', boundary);

triangulation = triangleGrid(sites);

% Plot both
figure('Position', [150, 200, 1000, 500]);

subplot(1,2,1), hold on
plotGrid(pebi_grid, 'facecolor', 'none');
plot(sites(:,1), sites(:,2), '.', 'MarkerSize', 24);
axis tight off

subplot(1,2,2), hold on
plotGrid(triangulation, 'facecolor', 'none');
plot(sites(:,1), sites(:,2), '.', 'MarkerSize', 24);
axis tight off