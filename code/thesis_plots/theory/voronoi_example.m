P = {
    [
        0.2 0.2;
        0.2 0.7;
        0.3 0.5;
        0.5 0.4;
        0.5 0.8;
        0.7 0.5;
        0.8 0.2;
    ];
    [
        0.2 0.5;
        0.2 0.9;
        0.5 0.5;
        0.5 0.2;
        0.7 0.3;
        0.8 0.7;
    ];
    [
        0.2 0.3;
        0.2 0.4;
        0.3 0.1;
        0.4 0.7;
        0.5 0.4;
        0.5 0.6;
        0.7 0.4;
        0.8 0.5;
    ];
};

% Plot
figure

% Plot P
for i = 1:length(P)
    clf;
    hold on;
    h = voronoi(P{i}(:, 1), P{i}(:, 2));

    % Points
    set(h(1), 'Color', 'r', 'MarkerSize', 20);
    % Edges
    set(h(2), 'Color', 'k', 'LineWidth', 1);

    [v, c] = voronoin(P{i});
    plot(v(:, 1), v(:, 2), LineStyle="none", Marker=".", MarkerSize=20, Color='k');
    
    axis("off");
    xlim([-0.1 1.1])
    ylim([-0.1 1.1])
    saveas(gcf, "voronoi_example" + i + ".png")
end
