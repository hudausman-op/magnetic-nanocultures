
% Define a threshold for significant change
threshold = 5;%0.003;

% Initialize variables to store the simplified trajectory
simplifiedTrajectory = res(1, :); % Initialize with the first data point

for i = 2:size(res, 1)
    % Calculate the change between the current point and the previous one
    change = abs(res(i, 1) - simplifiedTrajectory(end, 1));
    
    % If the change is greater than the threshold, add the point to the simplified trajectory
    if change > threshold
        simplifiedTrajectory = [simplifiedTrajectory; res(i, :)];
    end
end

% simplifiedTrajectory now contains the trajectory with redundant and constant points removed.
