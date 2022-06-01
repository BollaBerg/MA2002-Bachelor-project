% Some setup
numFixedPoints = 25;
numLinePoints = 30;
hmax = 0.5;
hmin = 0.1;
eps = 0.5;

% distmesh2d stuff
fd=@(p) drectangle(p,0,1,0,1);
fh=@(p) ones(size(p,1),1)/0.5;
fhFancy=@(p, varargin) 0.03+0.3*min(abs(dcircle(p,0.5,0.5,0.25)), abs(dcircle(p,0.5,0.5,0.5)));
fhUPR=@(p) min(hmax, hmin * exp(dpoly(p, [0.6 1; 0 0.8]) / eps));

h0=0.05;
bbox=[0 0; 1 1];
pfix=[rand(numFixedPoints, 2); [linspace(0.1,0.9,numLinePoints); linspace(0.1,0.9,numLinePoints)]'];

% CREATE STARTING POINTS (from distmesh2d)
geps=.001*h0;
% 1. Create initial distribution in bounding box (equilateral triangles)
[x,y]=meshgrid(bbox(1,1):h0:bbox(2,1),bbox(1,2):h0*sqrt(3)/2:bbox(2,2));
x(2:2:end,:)=x(2:2:end,:)+h0/2;                      % Shift even rows
p=[x(:),y(:)];                                       % List of node coordinates

% 2. Remove points outside the region, apply the rejection method
p=p(fd(p)<geps,:);                 % Keep only d<0 points
r0=1./fh(p).^2;                    % Probability to keep point
p=p(rand(size(p,1),1)<r0,:); %./max(r0),:);          % Rejection method
if ~isempty(pfix), p=setdiff(p,pfix,'rows'); end     % Remove duplicated nodes
pfix=unique(pfix,'rows','stable'); nfix=size(pfix,1);% Added stable sort
p=[pfix; p];                                         % Prepend fix points
% END OF CODE FROM distmesh2d

DT = delaunayTriangulation(p);

axis image off; hold on;
xlim([0 1]);
ylim([0 1]);
triplot(DT, 'color', 'black');
plot(p(numFixedPoints+1:end, 1), p(numFixedPoints+1:end, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(pfix(:, 1), pfix(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_before.png');


oPoints = distmesh2d(fd, fh, h0, bbox, pfix, false);

clf;
axis image off; hold on;
xlim([0 1]);
ylim([0 1]);

oDT = delaunayTriangulation(oPoints);
triplot(oDT, 'color', 'black');
plot(oPoints(:, 1), oPoints(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(pfix(:, 1), pfix(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_after.png');



fPoints = distmesh2d(fd, fhFancy, h0, bbox, pfix, false);

clf;
axis image off; hold on;
xlim([0 1]);
ylim([0 1]);

fDT = delaunayTriangulation(fPoints);
triplot(fDT, 'color', 'black');
plot(fPoints(:, 1), fPoints(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(pfix(:, 1), pfix(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_fancy.png');



uPoints = distmesh2d(fd, fhUPR, h0, bbox, pfix, false);

clf;
axis image off; hold on;
xlim([0 1]);
ylim([0 1]);

uDT = delaunayTriangulation(uPoints);
triplot(uDT, 'color', 'black');
plot(uPoints(:, 1), uPoints(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="black");
plot(pfix(:, 1), pfix(:, 2), LineStyle="none", Marker=".", MarkerSize=15, color="red");

% Save plot
exportgraphics(gcf,'plots/demo_distmesh_upr.png');