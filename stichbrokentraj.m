function res = stichbrokentraj(res)
% STICHBROKENTRAJ  Greedy stitching of broken tracks by time, space, and size.
% Usage:
%   res = stichbrokentraj(res);
%
% res columns assumed: [x y list list_raw conf frame time id]
% - x = res(:,1), y = res(:,2)
% - radius (px) per row is assumed in res(:,3)  (change below if different)
% - frame = res(:,6), time = res(:,7), id = res(:,8)

%% ---------- Parameters (tune to your data) ----------
px_to_um            = 3;    % pixel -> micron (for spatial gap threshold)
max_time_gap_frames = 2;    % allowed frame gap between segments to stitch
max_space_gap_um    = 30;   % allowed spatial jump between segments (µm)
size_tol_px         = 10;    % allowed radius difference (pixels)

%% ---------- Columns from res ----------
x  = res(:,1);
y  = res(:,2);
r  = res(:,3);        % <-- CHANGE HERE if your per-row radius lives elsewhere
f  = res(:,6);
id = res(:,8);

%% ---------- Per-ID summaries ----------
ids = unique(id);
nT  = numel(ids);

startF = zeros(nT,1);  endF = zeros(nT,1);
startX = zeros(nT,1);  endX = zeros(nT,1);
startY = zeros(nT,1);  endY = zeros(nT,1);
medR   = zeros(nT,1);

for k = 1:nT
    ii = find(id==ids(k));
    [f_k, ord] = sort(f(ii));   % sort rows within this ID by frame
    ii = ii(ord);
    startF(k) = f_k(1);         endF(k) = f_k(end);
    startX(k) = x(ii(1));       endX(k) = x(ii(end));
    startY(k) = y(ii(1));       endY(k) = y(ii(end));
    medR(k)   = median(r(ii));
end

%% ---------- Greedy stitching: chain A -> B -> C while matches exist ----------
active = true(nT,1);   % IDs still available to be stitched/kept

for a = 1:nT
    if ~active(a), continue; end

    did_merge = true;
    while did_merge
        did_merge = false;

        % Candidates that start after A and within the time gap
        cand = find(active & startF > endF(a) & (startF - endF(a)) <= max_time_gap_frames);
        if isempty(cand), break; end

        % Size filter (similar-sized capsules)
        cand = cand(abs(medR(cand) - medR(a)) <= size_tol_px);
        if isempty(cand), break; end

        % Spatial distance from end(A) to start(B) in microns
        d_um = hypot( (startX(cand) - endX(a))*px_to_um, ...
                      (startY(cand) - endY(a))*px_to_um );
        cand = cand(d_um <= max_space_gap_um);
        if isempty(cand), break; end

        % Pick nearest in space (index fixed to cand)
        [~, jrel] = min(d_um);
        b = cand(jrel);

        % ---- Merge: map all rows of id B to id A ----
        res(id==ids(b), 8) = ids(a);

        % Update A's endpoint so we can continue chaining (A <- A+B)
        endF(a) = endF(b);
        endX(a) = endX(b);
        endY(a) = endY(b);
        medR(a) = median([medR(a), medR(b)]);

        % Deactivate B
        active(b) = false;

        % Try to chain again (A -> next)
        did_merge = true;
    end
end

%% ---------- Reindex IDs neatly ----------
[~,~,new_ids] = unique(res(:,8));
res(:,8) = new_ids;

%% ---------- Quick sanity plot (lines + time-colored points) ----------
% (Comment this section out if you don't want auto-plotting)
% Zero-start time per stitched ID
[res, ord] = sortrows(res, [8 6]); %#ok<ASGLU>  % sort by id, then frame
x = res(:,1); y = res(:,2); t = res(:,7); id = res(:,8);

[g, idv] = findgroups(id);
t0 = splitapply(@(tt) tt(1), t, g);
t_sub = t - t0(g);

figure('Color','w'); hold on;
for k = 1:numel(idv)
    ii = (id==idv(k));
    if nnz(ii) >= 2
        plot(x(ii)*px_to_um, y(ii)*px_to_um, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.6);
    end
    scatter(x(ii)*px_to_um, y(ii)*px_to_um, 14, t_sub(ii)/24, 'filled');
end
axis equal tight;
xlabel('x (\mum)'); ylabel('y (\mum)');
cb = colorbar; cb.Label.String = 'Time (days)'; % use hours if you drop /24
title('Stitched trajectories');
hold off;

end
