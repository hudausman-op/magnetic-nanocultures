%This code will save the EPS files in respective directories.

% Define the directory where you want to save the .fig file
saveDirectory = '/path/to/your/directory/';

% Create a new figure
fig = figure;

% Create axes within the figure
ax = axes;

% Add your line plot to the axes
%This will be updated as the values of xc and vx_m will change based on res
% files
plot(ax, (1200-xc)*3, vx_m*3, 'o', 'MarkerSize', 20, 'Linewidth', 2, 'MarkerEdgeColor', 'b');

% Save the figure as a .fig file in the specified directory
saveas(fig, fullfile(saveDirectory, 'test.fig'));

% Export the figure as an EPS file if needed
exportgraphics(fig, fullfile(saveDirectory, 'test.eps'), 'BackgroundColor', 'none', 'ContentType', 'vector');
%make sure to go to the figure and select "none" for the background instead
%of "white"