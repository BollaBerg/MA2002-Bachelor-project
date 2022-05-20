P = [
    0.2 0.2;
    0.2 0.7;
    0.3 0.5;
    0.5 0.4;
    0.5 0.8;
    0.7 0.5;
    0.8 0.2;
];

delaunay_triangle = delaunayTriangulation(P);
delaunay_centers = circumcenter(delaunay_triangle);

% Plot
figure

% Focus on Voronoi
clf;
hold on;
h = voronoi(P(:, 1), P(:, 2));
triplot(delaunay_triangle, 'k--')
plot(delaunay_centers(:, 1), delaunay_centers(:, 2), LineStyle="none", Marker=".", MarkerSize=20, Color="r");

% Points
set(h(1), 'Color', 'b', 'MarkerSize', 20);
% Edges
set(h(2), 'Color', 'k', 'LineWidth', 1);

axis("off");
xlim([-0.1 1.1])
ylim([-0.1 1.1])
saveas(gcf, 'voronoi_duality_voronoi.png')



% Focus on Delaunay
clf;
hold on;
h = voronoi(P(:, 1), P(:, 2));
triplot(delaunay_triangle, 'k', 'LineWidth', 1)
plot(delaunay_centers(:, 1), delaunay_centers(:, 2), LineStyle="none", Marker=".", MarkerSize=20, Color="r");

% Points
set(h(1), 'Color', 'b', 'MarkerSize', 20);
% Edges
set(h(2), 'Color', 'k', 'LineStyle', '--');

axis("off");
xlim([-0.1 1.1])
ylim([-0.1 1.1])
saveas(gcf, 'voronoi_duality_delaunay.png')