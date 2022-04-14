% EXAMPLE 8 (PAGE 14) OF Berge, Klemetsdal et.al.

% Make a boundary somewhat like a U (for UPR)
boundary = [
    0,   0.3;
    0.3, 0;
    0.7, 0;
    1,   0.3;
    1,   1;
    0.7, 1;
    0.7, 0.7;
    0.3, 0.7;
    0.3, 1;
    0,   1;
];

initial_sites = 0.3 + 0.4 * rand(40, 2);

iterations = [0 1 5 10 20 100];
figure('Position', [150, 200, 1000, 500]);

for i = 1 : numel(iterations)
    % Optimize sites
    [G, sites] = CPG2D(initial_sites, boundary, 'maxIt', iterations(i));

    % Plot
    subplot(2, 3, i), hold on
    plotGrid(G, 'facecolor', 'none');
    plot(sites(:, 1), sites(:, 2), '.', 'MarkerSize', 24);
    title("Iterations:" + iterations(i));
    axis tight off
end