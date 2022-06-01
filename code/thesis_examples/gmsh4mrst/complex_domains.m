% Set the default grid size
resGridSize = 0.1;

% Set the domain to a star-shape
outer = 1;
inner = 0.5;
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

% Create a single fault and well
faceConstraints = {[-0.5 -0.7; 0.3 0.3]};
cellConstraints = {[-0.3 0.3; 0.5 -0.7]};

% Create the PEBI grid
G = pebiGrid2DGmsh( ...
    resGridSize, ...
    domain, ...
    'faceConstraints', faceConstraints, ...
    'cellConstraints', cellConstraints ...
);

% Plot result
axis off; hold on;
plotGrid(G, 'faceColor', 'none');
plot(faceConstraints{1}(:, 1), faceConstraints{1}(:, 2), LineStyle="--", Color="blue");
plot(cellConstraints{1}(:, 1), cellConstraints{1}(:, 2), LineStyle="--", Color="magenta");

% Save plot
exportgraphics(gcf,'plots/complex_domains.png')
