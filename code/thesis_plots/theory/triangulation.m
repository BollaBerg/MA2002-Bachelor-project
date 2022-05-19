P = [
    0.1 0.1;
    0.9 0.1;
    0.1 0.9;
    0.9 0.9;
    0.6 0.5;
    0.4 0.5;
];
connectivity = [
    1 2 5;
    1 3 6;
    1 4 5;
    2 4 5;
    3 4 6;
];

triangle = triangulation(connectivity, P);
delaunay_triangle = delaunayTriangulation(P);

% Plot
figure

hold on;
triplot(triangle, 'k');
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);
set(gca,'XColor', 'none','YColor','none');
saveas(gcf, 'triangulation_random.png')

clf;
hold on;
triplot(delaunay_triangle, 'k');
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);
set(gca,'XColor', 'none','YColor','none');
saveas(gcf, 'triangulation_delaunay.png')
