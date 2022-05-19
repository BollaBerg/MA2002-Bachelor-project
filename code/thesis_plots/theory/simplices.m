x = [0 0.5 1 0.5 ];
y = [0 0.5 0 0.25];
z = [0 0   0 1   ];


% Plot
figure

plot(x(1), y(1), 'k.', MarkerSize=50);
axis("off")
saveas(gcf, 'simplices0.png')

plot(x(1:2), y(1:2), 'k-', LineWidth=2)
axis("off")
saveas(gcf, 'simplices1.png')

triangle = [x(1:3); y(1:3)]';
T = delaunayTriangulation(triangle);
triplot(T, 'k-', LineWidth=2)
axis("off")
saveas(gcf, 'simplices2.png')

tetrahedron = [x; y; z]';
T = delaunayTriangulation(tetrahedron);
tetramesh(T, FaceAlpha=0.3, LineStyle='-', LineWidth=2);
view(30, 20);
axis("off")
saveas(gcf, 'simplices3.png')