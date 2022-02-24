n = 5;
[X, Y] = meshgrid(linspace(0, 1, n));

% pebi fails along boundary if circumenter of traingle is outside the
% convex hull of sites, so we include only inner points
isIn = false(n, n);
isIn(2:end-1, 2:end-1) = true;
sites = [X(:), Y(:)];
sites(isIn(:), :) = sites(isIn(:), :) + 0.1 * randn((n-2)^2, 2);

% Create actual grids
delaunay_triangulation = triangleGrid(sites);
pebi_grid = pebi(delaunay_triangulation);

% Plot the grids
figure('position',[100 100 700 320]);
subplot(1,2,1)
plotGrid(delaunay_triangulation, 'facecolor', 'none');
hold on, plot(sites(:,1), sites(:,2), '.','markersize', 25), hold off
axis equal off

subplot(1,2,2)
plotGrid(pebi_grid, 'facecolor','none');
hold on, plot(sites(:,1), sites(:,2), '.','markersize', 25), hold off
axis equal off;