fig = openfig('/Users/hudausman/Desktop/Desktop-HudasMacBook-Pro/MGMS/5nm bulk motion/Oct032023/5nm_bulk_motion_avergage_n=16.fig');  % Opens the figure invisibly and returns the figure handle
axesHandles = findall(fig, 'type', 'axes');  % Find axes

% Find all objects of type 'line' in the figure (scatter is stored this way in MATLAB)
lineObjs = findall(axesHandles, 'type', 'line');

% Loop through to find the scatter plot (usually blue and with markers)
for i = 1:length(lineObjs)
    x = get(lineObjs(i), 'XData');
    y = get(lineObjs(i), 'YData');
    color = get(lineObjs(i), 'Color');
    marker = get(lineObjs(i), 'Marker');

    % Optional: Check if it's blue and marker is 'o'
    if isequal(color, [0 0 1]) && strcmp(marker, 'o')
        scatterX = x;
        scatterY = y;
        break;
    end
end

% Optional: Save to CSV
T = table(scatterX(:), scatterY(:), 'VariableNames', {'Distance_um', 'Velocity_um_per_s'});
writetable(T, 'scatter_data.csv');
