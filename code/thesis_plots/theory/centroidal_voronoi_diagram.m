inner = 1;
outer = 2;
domain = [
    outer*cosd(18) outer*sind(18);
    inner*cosd(54) inner*sind(54);
    outer*cosd(90) outer*sind(90);
    inner*cosd(126) inner*sind(126);
    outer*cosd(162) outer*sind(162);
    inner*cosd(198) inner*sind(198);
    outer*cosd(234) outer*sind(234);
    inner*cosd(270) inner*sind(270);
    outer*cosd(306) outer*sind(306);
    inner*cosd(342) inner*sind(342);
];

initialSites = rand(30, 2) - 0.5;


[G0, sites0] = CPG2D(initialSites, domain, 'maxIt', 3);
[G, sites] = CPG2D(initialSites, domain, 'maxIt', 100);

% Plot
hold on;
plotGrid(G0, 'faceColor', 'none');
plot(sites0(:, 1), sites0(:, 2), ".", MarkerSize=15, Color="k")
axis("off")
saveas(gcf, "centroidal_voronoi_diagram_0.png");

% Plot
clf; hold on
plotGrid(G, 'faceColor', 'none');
plot(sites(:, 1), sites(:, 2), ".", MarkerSize=15, Color="k")
axis("off")
saveas(gcf, "centroidal_voronoi_diagram.png");
