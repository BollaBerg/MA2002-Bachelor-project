P = [
    0.5 0.4;
    0.2 0.2;
    0.2 0.7;
    0.3 0.5;
    0.5 0.4;
    0.5 0.8;
    0.7 0.5;
    0.8 0.2;
];

% "Cheat" a little, to fill the center cell
[v, c] = voronoin(P);
% Fill our center cell
fill(v(c{1}, 1), v(c{1}, 2), 'r', FaceAlpha=0.3);

hold on;
for i = 2:length(P)
    % Plot the line between P(1) and P(i)
    plot([P(1,1), P(i,1)], [P(1,2), P(i,2)], LineStyle="--", Color='k');

    % Calculate the perpendicular bisector plane
    line_slope = (P(i, 2) - P(1, 2)) / (P(i, 1) - P(1, 1));
    midpoint = [
            mean([P(1, 1), P(i, 1)]), ...
            mean([P(1, 2), P(i, 2)])
        ];
    if line_slope == 0
        xline(midpoint(1), Color='k', LineWidth=1);
    else
        slope = -1 / line_slope;
        start_x = -1;
        start_y = slope * (start_x - midpoint(1)) + midpoint(2);
        end_x = 2;
        end_y = slope * (end_x - midpoint(1)) + midpoint(2);
    end
    % ...and plot it
    plot([start_x, end_x], [start_y, end_y], color='k', LineWidth=1);
end

% Plot all points - with our center point in red
plot(P(2:end, 1), P(2:end, 2), LineStyle="none", Color='b', Marker='.', MarkerSize=20);
plot(P(1, 1), P(1, 2), LineStyle="none", Color='r', Marker='.', MarkerSize=20);

axis("off");
xlim([-0.1 1.1])
ylim([-0.1 1.1])
saveas(gcf, 'PEBI_definition.png')
