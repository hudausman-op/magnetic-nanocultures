% Define image folder and pattern
folderPath = '/Users/hudausman/Desktop/Desktop-HudasMacBook-Pro/MGMS/growthdynamics/';
filePattern = fullfile(folderPath, 'img%04d.tif');

% Setup
numFrames = 121;
images = cell(numFrames, 1);
masks = cell(numFrames, 1);

% Load and classify
for i = 1:numFrames
    filename = sprintf(filePattern, i);
    img = imread(filename);
    img = imadjust(img); % enhance contrast

    % Binary mask using Otsu
    level = graythresh(img);
    bw = imbinarize(img, level);
    
    images{i} = img;
    masks{i} = bw;
end

% Render and overlay on selected frames
timePoints = [1, 30, 60, 90, 121];

for t = timePoints
    grayImg = images{t};
    bwMask = masks{t};

    % Convert grayscale to RGB
    rgbImg = repmat(grayImg, [1, 1, 3]);

    % Overlay red where mask = 1
    overlay = rgbImg;
    overlay(:,:,1) = uint8(rgbImg(:,:,1) + 255 * uint8(bwMask));  % Red channel
    overlay(:,:,2) = uint8(rgbImg(:,:,2) .* uint8(~bwMask));      % Suppress green
    overlay(:,:,3) = uint8(rgbImg(:,:,3) .* uint8(~bwMask));      % Suppress blue

    % Display
    figure;
    imshow(overlay);
    title(['Overlay at Frame ', num2str(t)]);

    % Save
    savePath = fullfile(folderPath, sprintf('overlay_frame_%04d.png', t));
    imwrite(overlay, savePath);
end
