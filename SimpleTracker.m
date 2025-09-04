% Load image sequence
imageFolder = '/Users/hudausman/Desktop/Desktop-HudasMacBook-Pro/MGMS/sorting/silicabeads_sorting/image_seq'; % specify your folder containing the image sequence
imageFiles = dir(fullfile(imageFolder, '*.tif')); % assuming the images are in PNG format
numFrames = length(imageFiles);

% Initialize variables
particlePositions = cell(numFrames, 1);

% Loop through each frame
for k = 1:numFrames
    % Read image
    currentImage = imread(fullfile(imageFolder, imageFiles(k).name));
    
    % Preprocess image (e.g., thresholding, noise reduction)
    binaryImage = imbinarize(currentImage, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.5);
    binaryImage = bwareaopen(binaryImage, 50); % remove small objects
    
    % Detect particles
    stats = regionprops(binaryImage, 'Centroid');
    centroids = cat(1, stats.Centroid);
    
    % Store particle positions
    particlePositions{k} = centroids;
end

% Track particles using the SimpleTracker function
trajectories = SimpleTracker(particlePositions, 1); % 20 is the maximum displacement allowed between frames

% Calculate velocities
numTrajectories = length(trajectories);
velocities = cell(numTrajectories, 1);

for t = 1:numTrajectories
    trajectory = trajectories{t};
    if size(trajectory, 1) > 1
        % Calculate differences between consecutive positions
        diffs = diff(trajectory, 1);
        % Calculate velocity (distance between positions divided by time interval, assuming constant time step of 1 frame)
        velocities{t} = sqrt(diffs(:, 1).^2 + diffs(:, 2).^2);
    end
end

% Display results
disp('Trajectories and velocities calculated.');
