% EXAMPLE 6 (PAGE 13) OF Berge, Klemetsdal et.al.

h = 0.25;
domain = [1, 1];

[pebi_grid, sites] = pebiGrid2D(h, domain);

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