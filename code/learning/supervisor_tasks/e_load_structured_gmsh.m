% Load structured grid
G = gmshToMRST('c_gmsh_structured.m');

% Plot result
hold on;
plotGrid(G, 'faceColor', 'none');
plotLinePath(cell_constraints, 'lineWidth', 2, 'color', 'magenta', 'markersize', 3);
title("Conforming Voronoi Grid");