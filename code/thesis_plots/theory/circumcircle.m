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

[center_triangle, radii_triangle] = circumcenter(triangle);
[center_delaunay, radii_delaunay] = circumcenter(delaunay_triangle);

% Plot
figure

subplot(1, 2, 1); hold on
set(gca,'XColor', 'none','YColor','none');
triplot(triangle, 'Color', [0 0 0 1]);
for c = 1:length(center_triangle)
    circle(center_triangle(c, 1), center_triangle(c, 2), radii_triangle(c));
end
xlim([-0.5 1.5])
ylim([-0.3 1.3])
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);

subplot(1, 2, 2); hold on
triplot(delaunay_triangle, 'Color', [0 0 0 1]);
plot(P(:, 1), P(:, 2), '.r', 'MarkerSize', 15);
for c = 1:length(center_delaunay)
    circle(center_delaunay(c, 1), center_delaunay(c, 2), radii_delaunay(c));
end
xlim([-0.5 1.5])
ylim([-0.3 1.3])
set(gca,'XColor', 'none','YColor','none');

% Save
saveas(gcf, 'circumcircle.png')


% Define a method for plotting circles
% Copied from
% https://se.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center#answer_108013
function h = circle(x,y,r)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'Color', [0 0 0 0.3]);
end