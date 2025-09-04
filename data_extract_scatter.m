fig = openfig('/Users/hudausman/Desktop/Desktop-HudasMacBook-Pro/MGMS/5nm bulk motion/Oct032023/5nm_bulk_motion_avergage_n=16.fig');  % Opens the figure invisibly and returns the figure handle
axesHandles = findall(fig, 'type', 'axes');  % Find axes

% Find all objects of type 'line' in the figure (scatter is stored this way in MATLAB)
lineObjs = findall(axesHandles, 'type', 'line');

% Loop through line objects to find the scatter data
maxLength = 0;
for i = 1:length(lineObjs)
    x = get(lineObjs(i), 'XData');
    y = get(lineObjs(i), 'YData');
    marker = get(lineObjs(i), 'Marker');
    linestyle = get(lineObjs(i), 'LineStyle');

    % We're looking for 'o' markers and no line
    if strcmp(marker, 'o') && strcmp(linestyle, 'none') && length(x) > maxLength
        scatterX = x;
        scatterY = y;
        maxLength = length(x);
    end
end

% Save to CSV
T = table(scatterX(:), scatterY(:), 'VariableNames', {'Distance_um', 'Velocity_um_per_s'});
writetable(T, 'scatter_data.csv');
