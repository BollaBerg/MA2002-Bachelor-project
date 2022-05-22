constraint_line = [
    0.1 0.1;
    0.5 0.9;
    0.9 0.1;
];

radius = sqrt(0.05^2 + 0.05^2);

gmsh_capsule = [
    0.05 0.15;
    0.5 0.9 + radius;
    0.95 0.15;
    0.85 0.05;
    0.5 0.9 - radius;
    0.15 0.05;
    0.05 0.15;
];


% Plot stuff
figure; hold on;
plot(constraint_line(:, 1), constraint_line(:, 2), Color="k");
plot(gmsh_capsule(:, 1), gmsh_capsule(:, 2), color="b", Marker=".", MarkerSize=15);
circle(constraint_line(1, 1), constraint_line(1, 2), radius);
circle(constraint_line(2, 1), constraint_line(2, 2), radius);
circle(constraint_line(3, 1), constraint_line(3, 2), radius);

xlim([0 1]);
ylim([0 1]);
axis("off");
saveas(gcf, "cell_constraints_multi.png");



% Define a method for plotting circles
% Copied from
% https://se.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center#answer_108013
function h = circle(x,y,r)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'Color', [0 0 0 0.3]);
end