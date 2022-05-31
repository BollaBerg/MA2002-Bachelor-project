min_distance = 0.3;
min_size = 0.2;
max_distance = 0.7;
max_size = 0.8;

hold on;

% Flat line
plot([-1, min_distance], [min_size, min_size], Color="black", LineWidth=2);
% Linear increase
plot([min_distance, max_distance], [min_size, max_size], color="black", LineWidth=2);
% Flat top
plot([max_distance, 2], [max_size, max_size], Color="black", LineWidth=2);

% yline(min_size, LineWidth=0.5, LineStyle="--");
% yline(max_size, LineWidth=0.5, LineStyle="--");
xline(min_distance, LineWidth=0.5, LineStyle="--");
xline(max_distance, LineWidth=0.5, LineStyle="--");

xticks([min_distance, max_distance]);
xticklabels(["Min", "Max"]);
xlabel("Distance (input)");
yticks([min_size, max_size]);
yticklabels(["Min", "Max"]);
ylabel("Size (output)");

axis image;
xlim([0 1]);
ylim([0 1]);

% Save plot
exportgraphics(gcf,'plots/thresholdCurve.png')