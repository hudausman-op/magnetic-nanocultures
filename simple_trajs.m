% Define a threshold for significant change
threshold = 0.5; % Adjust this threshold as needed

% Compute the differences between consecutive elements in res(:,1)
differences = abs(diff(res(:, 1)));

% Initialize variables to store the simplified trajectory
simplifiedTrajectory = res(1, :); % Initialize with the first data point

% Find the indices of data points with changes greater than the threshold
significantIndices = find(differences > threshold);

% Add significant data points to the simplified trajectory
simplifiedTrajectory = [simplifiedTrajectory; res(significantIndices + 1, :)];

% simplifiedTrajectory now contains the trajectory with redundant and constant points removed.
