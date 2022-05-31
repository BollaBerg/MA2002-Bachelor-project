% NON-WORKING DEMO OF DISTMESH / OPTIMAL DELAUNAY
% Some setup
numFixedPoints = 10;
h = @(x, y) 0.8; %(x-0.5).^2 + (y-0.5).^2;
stepSize = 0.05;

% Create initial point set
points = rand(30, 2);
manualPoints = [0.1 0.1; 0.9 0.9; 0.1 0.9; 0.9 0.1];
points = [points; manualPoints];

DT = delaunayTriangulation(points);

hold on;
triplot(DT);
plot(points(numFixedPoints+1:end, 1), points(numFixedPoints+1:end, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(points(1:numFixedPoints, 1), points(1:numFixedPoints, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_before.png');

for round = 1:100
    force = zeros(length(points), 2);
    new_DT = delaunayTriangulation(points);
    for i = 1:length(new_DT.ConnectivityList)
        p1 = new_DT.Points(new_DT.ConnectivityList(i, 1), :);
        p2 = new_DT.Points(new_DT.ConnectivityList(i, 2), :);
        p3 = new_DT.Points(new_DT.ConnectivityList(i, 3), :);
    
        [d, angle] = relBetween(p1, p2);
        d1 = max(0, h(p1(1), p1(2)) - d);
        d2 = max(0, h(p2(1), p2(2)) - d);
        force(new_DT.ConnectivityList(i, 1), 1) = force(new_DT.ConnectivityList(i, 1), 1) + d1 * cos(angle);
        force(new_DT.ConnectivityList(i, 1), 2) = force(new_DT.ConnectivityList(i, 1), 2) + d1 * sin(angle);
        force(new_DT.ConnectivityList(i, 2), 1) = force(new_DT.ConnectivityList(i, 2), 1) + d2 * cos(pi + angle);
        force(new_DT.ConnectivityList(i, 2), 2) = force(new_DT.ConnectivityList(i, 2), 2) + d2 * sin(pi + angle);
        [d, angle] = relBetween(p2, p3);
        d2 = max(0, h(p2(1), p2(2)) - d);
        d3 = max(0, h(p3(1), p3(2)) - d);
        force(new_DT.ConnectivityList(i, 2), 1) = force(new_DT.ConnectivityList(i, 2), 1) + d2 * cos(angle);
        force(new_DT.ConnectivityList(i, 2), 2) = force(new_DT.ConnectivityList(i, 2), 2) + d2 * sin(angle);
        force(new_DT.ConnectivityList(i, 3), 1) = force(new_DT.ConnectivityList(i, 3), 1) + d3 * cos(pi + angle);
        force(new_DT.ConnectivityList(i, 3), 2) = force(new_DT.ConnectivityList(i, 3), 2) + d3 * sin(pi + angle);
        [d, angle] = relBetween(p1, p3);
        d1 = max(0, h(p1(1), p1(2)) - d);
        d3 = max(0, h(p3(1), p3(2)) - d);
        force(new_DT.ConnectivityList(i, 1), 1) = force(new_DT.ConnectivityList(i, 1), 1) + d1 * cos(angle);
        force(new_DT.ConnectivityList(i, 1), 2) = force(new_DT.ConnectivityList(i, 1), 2) + d1 * sin(angle);
        force(new_DT.ConnectivityList(i, 3), 1) = force(new_DT.ConnectivityList(i, 3), 1) + d3 * cos(pi + angle);
        force(new_DT.ConnectivityList(i, 3), 2) = force(new_DT.ConnectivityList(i, 3), 2) + d3 * sin(pi + angle);
    end

    for i = numFixedPoints+1:length(points)
        newPoint = points(i, :) + stepSize * force(i, :);
        newPoint = max(newPoint, [0 0]);
        newPoint = min(newPoint, [1 1]);
        points(i, :) = newPoint;
    end
end
clf; hold on;
oDT = delaunayTriangulation(points);
triplot(oDT);
plot(points(numFixedPoints+1:end, 1), points(numFixedPoints+1:end, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(points(1:numFixedPoints, 1), points(1:numFixedPoints, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_after.png');

function [d, angle] = relBetween(p2, p1)
    d = sqrt((p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
    angle = atan((p2(2) - p1(2)) ./ (p2(1) - p1(1)));
end