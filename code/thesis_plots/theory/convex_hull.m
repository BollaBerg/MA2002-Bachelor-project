P = rand(10, 2);

hull = convhull(P);

% Plot
plot(P(:,1),P(:,2), '.r', 'MarkerSize', 15);
hold on
plot(P(hull,1),P(hull,2), 'k');
set(gca,'XColor', 'none','YColor','none');

saveas(gcf, 'convex_hull.png')