P = [
    0.1 0.1;
    0.9 0.1;
    0.1 0.9;
    0.9 0.9;
    0.6 0.5;
    0.4 0.5;
];

connectivity = [
    2 6;
];

delaunay_triangle = delaunayTriangulation(P);
constrained_delaunay = delaunayTriangulation(P, connectivity);

% Plot
figure

clf;
hold on;
triplot(delaunay_triangle, 'k');
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);
set(gca,'XColor', 'none','YColor','none');
saveas(gcf, 'delaunay_triangulation1.png')

set(gca,'xdir','reverse');
saveas(gcf, 'delaunay_triangulation2.png');

clf;
hold on;
triplot(constrained_delaunay, 'k');
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);
set(gca,'XColor', 'none','YColor','none');
saveas(gcf, 'delaunay_triangulation3.png');


set(gca,'xdir','reverse');
saveas(gcf, 'delaunay_triangulation4.png');

