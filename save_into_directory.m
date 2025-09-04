% Define the directory where you want to save the .fig file
saveDirectory = '//Users/hudausman/Desktop/MGMS/ParticleTracking/EcoliVdoz/oct062023/processed_imgs';

% Create a new figure with fixed dimensions (5 inches by 4 inches)
fig = figure('Position', [50, 50, 550, 400]);

% Create axes within the figure
ax = axes;

% Add your line plot to the axes
plot(ax, (1200-xc)*3, vx_m*3, 'o', 'MarkerSize', 20, 'Linewidth', 2, 'MarkerEdgeColor', 'b');

% Save the figure as a .fig file in the specified directory
saveas(fig, fullfile(saveDirectory, 'test.fig'));

% Export the figure as an EPS file if needed
exportgraphics(fig, fullfile(saveDirectory, 'test.eps'), 'BackgroundColor', 'none', 'ContentType', 'vector');
