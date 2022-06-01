points = [
    0.5 0.1;
    0.8 0.6;
    0.4 0.9;
    0.18 0.7;
];
labels = {'C'; 'D'; 'B'; 'A'};

axis square off; hold on;
xlim([0 1]);
ylim([0 1]);

% Plot initial triangulation
plot(points(:, 1), points(:, 2), LineStyle="none", Marker=".", MarkerSize=15, Color="black");
labelpoints(points(1, 1), points(1, 2), labels{1}, 'S', 0.2, 'FontSize', 20);
labelpoints(points(2, 1), points(2, 2), labels{2}, 'E', 0.2, 'FontSize', 20);
labelpoints(points(3, 1), points(3, 2), labels{3}, 'N', 0.2, 'FontSize', 20);
labelpoints(points(4, 1), points(4, 2), labels{4}, 'W', 0.2, 'FontSize', 20);

% Manually create lines of false plot
initial = [
    1 3 4;
    1 2 3;
];
T = triangulation(initial, points);
[centers, radiis] = circumcenter(T);

tri1 = triplot(initial, points(:, 1), points(:, 2), color="black");
c1 = circle(centers(1, 1), centers(1, 2), radiis(1));
c2 = circle(centers(2, 1), centers(2, 2), radiis(2));

exportgraphics(gcf,'plots/delaunay_flipping_initial.png');

% Remove circles and initial triangulation
set(tri1, "Visible", "off");
set(c1, "Color", [0 0 0 0.01]);
set(c2, "Color", [0 0 0 0.01]);

% Create Delaunay triangulation
DT = delaunay(points);
triplot(DT, points(:, 1), points(:, 2), color="black");

% Plot new circumcircles
[Dcenters, Dradiis] = circumcenter(triangulation(DT, points));
c1 = circle(Dcenters(1, 1), Dcenters(1, 2), Dradiis(1));
c2 = circle(Dcenters(2, 1), Dcenters(2, 2), Dradiis(2));

% Save plot
exportgraphics(gcf,'plots/delaunay_flipping_delaunay.png')


% Define a method for plotting circles
% Copied from
% https://se.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center#answer_108013
function h = circle(x,y,r)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'Color', [.5 .5 .5]);
end