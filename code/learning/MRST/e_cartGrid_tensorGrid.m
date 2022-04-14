% EXAMPLE 5 (PAGE 12) OF Berge, Klemetsdal et.al.

% UPR equivalent of cartGrid
[dx, dy] = deal(0.25);
[xmax, ymax] = deal(1);

cartG = compositePebiGrid2D([dx, dy], [xmax, ymax]);

% UPR equivalent of tensorGrid
[X, Y] = meshgrid(linspace(1, 2, 5));           % Shifted by one right and up
tensorG = pebi(triangleGrid([X(:), Y(:)]));

% Plot both
figure();
plotGrid(cartG);
plotGrid(tensorG);