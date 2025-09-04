% Load your data from the 'res' file (replace with your actual data loading code)
% load('res.mat');
x = res(:, 1); % x-coordinates
y = res(:, 2); % y-coordinates

% Number of particles
numParticles = 20;

% Create a figure
figure;
hold on;

% Set marker properties for the first point
firstMarkerSize = 10;
firstMarkerColor = 'r';

% Define a colormap with 11 distinct colors
colors = hsv(numParticles);

% Create an animation for each particle
for p = 1:numParticles
    % Extract x and y coordinates for the current particle
    xParticle = x(p:numParticles:end);
    yParticle = y(p:numParticles:end);

    % Plot the trajectory for the current particle with a unique color
    plot(xParticle, yParticle, 'Color', colors(p, :), 'LineWidth', 2);

    % Mark the first point of each trajectory with a square marker
    plot(xParticle(1), yParticle(1), 's', 'MarkerSize', firstMarkerSize, 'MarkerFaceColor', firstMarkerColor);

    % Add labels or titles if needed
    title('Particle Trajectories Animation');
    xlabel('X-Coordinate');
    ylabel('Y-Coordinate');

    % Adjust axis limits if necessary
    axis([min(x) max(x) min(y) max(y)]);
    
    % Pause to control animation speed
    pause(10);  % You can adjust the duration as needed
    
    % Clear the previous plot to create the appearance of animation
    clf;
    hold on;
end
