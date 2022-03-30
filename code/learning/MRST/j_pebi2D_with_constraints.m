% EXAMPLE 10 (PAGE 17) OF Berge, Klemetsdal et.al.

% Define lines making up our constraints
lines = {
    [0.2 0.2; 0.4 0.8; 0.6 0.8; 0.8 0.2], ...
    [0.2 0.5; 0.8 0.5], ...
    [0.6 0.2; 0.8 0.8], ...
};

cell_dimensions = [0.05 0.05];
G1 = compositePebiGrid2D(cell_dimensions, [1, 1], 'faceConstraints', lines);
G2 = pebiGrid2D(cell_dimensions(1), [1, 1], 'faceConstraints', lines);

figure('Position', [150, 200, 1000, 500]);

subplot(1, 2, 1); hold on
plotGrid(G1, 'faceColor', 'none');
plotLinePath(lines,':o', 'LineWidth', 2, 'MarkerSize',3);
title("compositePebiGrid2D");

subplot(1, 2, 2);
plotGrid(G2, 'faceColor', 'none');
plotLinePath(lines,':o', 'LineWidth', 2, 'MarkerSize',3);
title("pebiGrid2D");