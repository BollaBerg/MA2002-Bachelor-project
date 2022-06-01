X = linspace(0, 1, 10);
Y = linspace(0, 1, 10);
plotgrid(X, Y);

axis image off;
xlim([0 1]);
ylim([0 1]);
saveas(gcf, 'plots/transfinite_1.png')

clf;
X = linspace(0, 1, 10);
Y = (exp(linspace(0, 3, 10)) - 1);
Y = Y / max(Y);
plotgrid(X, Y);

axis image off;
xlim([0 1]);
ylim([0 1]);
saveas(gcf, 'plots/transfinite_2.png')

clf;
X = (exp(linspace(0, 3, 10)) - 1);
X = X / max(X);
Y = exp(linspace(0, 3, 10)) - 1;
Y = Y / max(Y);
plotgrid(X, Y);

axis image off;
xlim([0 1]);
ylim([0 1]);
saveas(gcf, 'plots/transfinite_3.png')


function plotgrid(X,Y)
    hold on;
    for i = 1:length(X)
        xline(X(i), Color="black", LineWidth=2);
    end
    for i = 1:length(Y)
        yline(Y(i), Color="black", LineWidth=2);
    end
end