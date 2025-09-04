%% --- Config ---
fps      = 24;   % frames/second
seq_dir  = '/Users/hudausman/Desktop/Desktop-HudasMacBook-Pro/MGMS/ParticleTracking/EcoliVdoz/image seq';
file_fmt = 'img%04d.tif';     % img0001.tif, img0002.tif, ...

% Panels: timestamps (s) to overlay
panels = { [0 5 10], [20 25 30], [60 65 70] };

% Styles
ring_th  = 1.6;      % kept for reference; not used with ghosts
arrow_w  = 1.6;      % arrow width

% Colors (C/M/Y like your example)
cm = [  0,174,239; 236,  0,140; 255,242,  0 ]/255;

%% --- Tracking columns from res: [x y r ... frame time id] ---
x  = res(:,1);
y  = res(:,2);
r  = res(:,3);      % radius in pixels
f  = res(:,6);      % frame index from tracker
id = res(:,8);

%% --- Discover images and build a robust mapper between res-frames and filenames ---
d = dir(fullfile(seq_dir, 'img*.tif'));
if isempty(d), error('No files matching img*.tif in %s', seq_dir); end

% numeric part from names (e.g., 1 for img0001.tif)
nums   = regexp({d.name}, '\d+', 'match', 'once'); nums = str2double(nums);
img_min = min(nums); img_max = max(nums);

% tracker may start at f_min (often 0 or 1). Anchor the mapping:
f_min = min(f);  % earliest frame index in res

% seconds -> image index (clamped to existing files)
sec2img         = @(sec) img_min + round(sec*fps);
sec2img_clamped = @(sec) max(img_min, min(sec2img(sec), img_max));

% File reader
read_frame = @(imgIdx) imread(fullfile(seq_dir, sprintf(file_fmt, imgIdx)));

%% --- Helper: ghosted (translucent) capsule overlay (no toolboxes) ---
theta = linspace(0, 2*pi, 200);
drawGhosts = @(xc,yc,R,color,faceA,edgeA,lw) arrayfun(@(i) ...
    patch( xc(i) + R(i)*cos(theta), ...
           yc(i) + R(i)*sin(theta), ...
           color, ...
           'FaceAlpha', faceA, ...   % translucency of the fill
           'EdgeColor', color, ...
           'EdgeAlpha', edgeA, ...   % translucency of the outline
           'LineWidth', lw ), 1:numel(xc));

%% --- Figure: 1x3 panel ---
figure('Color','w');
tlo = tiledlayout(1, numel(panels), 'TileSpacing','compact', 'Padding','compact');

for p = 1:numel(panels)
    ts = panels{p};                              % [t1 t2 t3] in seconds
    imgIdx = arrayfun(sec2img_clamped, ts);      % corresponding image indices

    % Background image: first timestamp’s image
    I = read_frame(imgIdx(1));
    nexttile; imshow(I, []);
    % Draw border around the image
    ax = gca;
    xl = xlim(ax); yl = ylim(ax);
    rectangle('Position',[xl(1) yl(1) diff(xl) diff(yl)], ...
        'EdgeColor','k', 'LineWidth',1, 'Clipping','off');
    hold on;


    % Legend handles/labels (one per timestamp color)
    legH = gobjects(0);
    legL = strings(0);

    % Draw ghosted capsules at each timestamp (match by tracker frame nearest to time)
    for k = 1:numel(ts)
        % target tracker frame for this time
        f_target = f_min + round(ts(k)*fps);

        % exact frame if present; otherwise nearest present frame
        ii = find(f == f_target);
        if isempty(ii)
            [~,nearest_idx] = min(abs(f - f_target));
            f_near = f(nearest_idx);
            ii = find(f == f_near);
        end

        if ~isempty(ii)
            % translucent filled disks with colored rims
            drawGhosts(x(ii), y(ii), r(ii), cm(k,:), ...
                       0.25, ... % FaceAlpha
                       0.9,  ... % EdgeAlpha
                       1.6);     % LineWidth

            % legend marker for this timestamp (simple colored circle)
            h = plot(nan,nan,'o', 'Color',cm(k,:), 'MarkerFaceColor','none', 'MarkerSize',8);
            legH(end+1) = h; %#ok<AGROW>
            legL(end+1) = sprintf('%d s', ts(k)); %#ok<AGROW>
        end
    end

    % Displacement arrows from first -> last time for shared IDs
    f1_target = f_min + round(ts(1)*fps);
    f2_target = f_min + round(ts(end)*fps);

    % nearest actual frames in res for these targets
    [~,i1n] = min(abs(f - f1_target)); f1_real = f(i1n);
    [~,i2n] = min(abs(f - f2_target)); f2_real = f(i2n);

    idx1 = find(f == f1_real);  idx2 = find(f == f2_real);
    ids1 = unique(id(idx1));    ids2 = unique(id(idx2));
    shared = intersect(ids1, ids2);

    for m = 1:numel(shared)
        ii1 = find(id==shared(m) & f==f1_real, 1, 'first');
        ii2 = find(id==shared(m) & f==f2_real, 1, 'first');
        if isempty(ii1) || isempty(ii2), continue; end
        quiver(x(ii1), y(ii1), x(ii2)-x(ii1), y(ii2)-y(ii1), 0, ...
               'Color','k', 'LineWidth',arrow_w, 'MaxHeadSize',0.8, 'AutoScale','off');
    end

    % Keep legend clean (don’t list each ghost patch), and make arrows sit on top
    set(findall(gca,'Type','patch'), 'HandleVisibility','off');
    uistack(findall(gca,'Type','quiver'), 'top');

    % Legend & title
    lg = legend(legH, legL, 'Location','northeast', 'Box','on');
    title(lg, 'Time (s)');                 % set legend title this way
    lg.ItemTokenSize = [10 10];

    title(sprintf('%d / %d / %d s', ts(1), ts(2), ts(3)), 'FontWeight','bold');
    hold off;
end

title(tlo, 'Nanoculture overlays at selected times with displacement vectors', 'FontWeight','bold');
