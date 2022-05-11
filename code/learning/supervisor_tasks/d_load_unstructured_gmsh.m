% Load structured grid
G = gmshToMRST('b_gmsh_unstructured.m');

% Plot result
hold on;
plotGrid(G, 'faceColor', 'none');
plotLinePath(cell_constraints, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
title("Conforming Voronoi Grid");