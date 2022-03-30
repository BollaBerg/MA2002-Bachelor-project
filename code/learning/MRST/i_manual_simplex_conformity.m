% EXAMPLE 9 (PAGE 15-17) OF Berge, Klemetsdal et.al.
% Manually adapting to line constraints
% Goal: Place 2D sites such that each cell of the 1D grid is a face in
% the 2D PEBI grid

% Define vertices of a 1D tessellation of a constraint curve
constraint_points = [0, 0.5; 0.2, 0.6; 0.4, 0.4; 0.6, 0.6];

% Plot constraints
plot(constraint_points(:,1), constraint_points(:,2),'-o', ...
    'LineWidth', 3, ...
    'MarkerSize', 1 ...
);
axis equal, axis([0 1 0 1])
hold on

% Calculate distance between vertices
distances = sqrt(sum(diff(constraint_points).^2, 2));

% Calculate circle radius
radius = 0.6 * max(distances);

% Plot circles
theta = linspace(0,2*pi)';
for j = 1:size(constraint_points, 1)
    X = bsxfun(@plus, constraint_points(j,:), radius*[cos(theta), sin(theta)]);
    plot(X(:,1), X(:,2),'k:', 'linewidth', 2)
end

%%% Calculate circle intersections
% Normal offset from line
offset = sqrt(radius^2 - (distances/2).^2);

% Tangent vector
tangent = bsxfun(@rdivide, diff(constraint_points), distances);

% Normal vector
normal = [-tangent(:, 2), tangent(:, 1)];

% Segment centers
centers = constraint_points(1: end-1, :) + bsxfun(@times, distances/2, tangent);

%%% Add sites at both intersections
% Sites left and right of the constraint
left_sites = centers + bsxfun(@times, offset, normal);
right_sites = centers - bsxfun(@times, offset, normal);

% Plot sites
plot(left_sites(:, 1), left_sites(:, 2), '.', 'markersize', 25);
plot(right_sites(:, 1), right_sites(:, 2), '.', 'markersize', 25);

% The tip only has two sites -> not enough for the point to be a face.
% We therefore add a tip site anywhere on the circle of the end vertix, as
% long as it is not within any other circles
tip_sites = constraint_points(end, :) + radius / sqrt(2);

% Plot tip site
plot(tip_sites(1), tip_sites(2), '.','markersize', 25)

% To fill in the rest of the grid with sites, we first distribute
% background sites, then remove any sites within a circle
[X, Y] = meshgrid(0:.1:1, 0:.1:1);      % start:step:stop
background_sites = removeConflictPoints([X(:), Y(:)], constraint_points, radius);

% Plot background sites
plot(background_sites(:, 1), background_sites(:, 2), '.', 'markersize', 6);

% We can now collect the sites in one vector and create the grid
boundary = [0 0; 0 1; 1 1; 1 0];
G = clippedPebi2D([left_sites; right_sites; tip_sites; background_sites], boundary);

plotGrid(G, 'facecolor', 'none');