% This will load trajectories in resfile and calculate MSD exponent and mean
% average speed of each trajectory
% you need to identify maxLag time that you want MSD to be calculated.
resfile = resfile;
maxLag = 5;
fps = 0.31; % I got this from the video properties
load(resfile);
id = unique(res(:,8));
n = zeros(length(id),1);
v = n;
MSDE = zeros(maxLag,1);

for i = 1:length(id)
    idx = find(res(:,8) == id(i));
    [MSD, tau, DataP] = MSD_withgaphu(res(idx,7), res(idx,1:2), fps, maxLag);

    % Debugging output to check the size of MSD
    fprintf('MSD size for particle %d: %s\n', i, mat2str(size(MSD)));

    % Check if MSD has enough data points and if tau is not empty
    if ~isempty(MSD) && ~isempty(tau)
        availableLag = min(size(MSD, 1), maxLag);
        if availableLag > 0 && size(MSD, 2) >= 3
            MSDE(1:availableLag) = MSDE(1:availableLag) + MSD(1:availableLag, 3);
        else
            warning('Skipping particle %d due to incompatible MSD size.', i);
            continue; % Skip to the next iteration of the loop
        end

        % Ensure MSD(:,3) has the correct size
        if size(MSD, 1) < maxLag
            MSD = [MSD; zeros(maxLag - size(MSD, 1), size(MSD, 2))];
        end
        MSDI(i).MSD = MSD(:,3);

        % Polynomial fit (only if there are enough data points)
        if availableLag >= 2 && length(tau) >= 2
            p = polyfit(log(tau(1:availableLag))', log(MSD(1:availableLag, 3)), 1);
            n(i) = p(1);
        else
            warning('Skipping polynomial fit for particle %d due to insufficient data points.', i);
            continue;
        end
        
        vx = diff(res(idx,1)) ./ diff(res(idx,7));
        vy = diff(res(idx,2)) ./ diff(res(idx,7));
        v(i) = mean(sqrt(vx.^2 + vy.^2));
    else
        warning('Skipping particle %d due to empty MSD or tau.', i);
    end
end

MSDE = MSDE ./ length(id);
idxp = find(n < 1.2 & v < 0.6);
idxa = find(~(n < 1 & v < 0.6));
MSDEP = zeros(maxLag, 1);
MSDEA = zeros(maxLag, 1);

for i = 1:length(idxp)
    % Ensure MSDI(idxp(i)).MSD has the correct size
    if length(MSDI(idxp(i)).MSD) < maxLag
        MSDI(idxp(i)).MSD = [MSDI(idxp(i)).MSD; zeros(maxLag - length(MSDI(idxp(i)).MSD), 1)];
    end
    MSDEP = MSDEP + MSDI(idxp(i)).MSD;
end

if length(idxp) > 0
    MSDEP = MSDEP ./ length(idxp);
end

for i = 1:length(idxa)
    % Ensure MSDI(idxa(i)).MSD has the correct size
    if length(MSDI(idxa(i)).MSD) < maxLag
        MSDI(idxa(i)).MSD = [MSDI(idxa(i)).MSD; zeros(maxLag - length(MSDI(idxa(i)).MSD), 1)];
    end
    MSDEA = MSDEA + MSDI(idxa(i)).MSD;
end

if length(idxa) > 0
    MSDEA = MSDEA ./ length(idxa);
end

% Ensure tau, MSDEA, and MSDEP are of the same length for plotting
minLength = min(length(tau), min(length(MSDEA), length(MSDEP)));

% Truncate to the minimum length
tau = tau(1:minLength);
MSDEA = MSDEA(1:minLength);
MSDEP = MSDEP(1:minLength);

% Plots the MSD for swimmers and Brownian motion
if ~isempty(tau) && length(tau) >= 2
    figure(1)
    plot(tau, MSDEA, 'ro')  % Linear x and y axes
    Const = polyfit(log(tau)', log(MSDEA), 1);
    hold on
    plot(tau, exp(polyval(Const, log(tau))), 'r-');
    hold on
    plot(tau, MSDEP, 'bo')  % Linear x and y axes
    Const2 = polyfit(log(tau)', log(MSDEP), 1);
    hold on
    plot(tau, exp(polyval(Const2, log(tau))), 'b--');
    legend('Swimmers','','Brownians','','Location','northwest')
    xlabel('tau(s)')
    ylabel('dr^2 (micrometers^2)')
    xlim([min(tau) max(tau)])
else
    warning('No valid tau found for plotting.');
end
