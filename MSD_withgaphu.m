function [MSD, tau, DataP] = MSD_withgaphu(t, x, fps, maxLag)
    % Fast MSD calculation for a series with missing points in the trajectory
    % time point associated with positions
    % x: 2D or 3D position vector
    % fps: frame rate
    % maxLag: maximum lag time (in frames)
    %
    % output:
    % MSD: in 2D: [Dx^2 Dy^2 Dr^2] in 3D: [Dx^2 Dy^2 Dz^2 Dr^2]
    % tau: lag time in seconds
    % DataP: number of data points used to measure the MSD in each lag-time
    
    tm = max(t) - min(t);
    kk = 0;
    Sz = size(x);
    nr = Sz(1); nc = Sz(2);
    t = reshape(t, length(t), 1);
    if nc > nr
        x = x';
    end
    nc = size(x, 2);
    tm = min(maxLag, tm);
    
    tau = [];
    DataP = [];
    MSD = [];
    
    for i = 1:tm
        tempx = 0;
        tempy = 0;
        tempz = 0;
        tempr = 0;
        k = 0;
        for j = 1:length(t) - i
            id = find(t == (t(j) + i));
            if ~isempty(id)
                k = k + 1;
                if nc == 1
                    tempx = tempx + (x(id) - x(j)).^2;
                elseif nc == 2
                    tempx = tempx + (x(id, 1) - x(j, 1)).^2;
                    tempy = tempy + (x(id, 2) - x(j, 2)).^2;
                    tempr = tempr + (x(id, 1) - x(j, 1)).^2 + (x(id, 2) - x(j, 2)).^2;
                else
                    tempx = tempx + (x(id, 1) - x(j, 1)).^2;
                    tempy = tempy + (x(id, 2) - x(j, 2)).^2;
                    tempz = tempz + (x(id, 3) - x(j, 3)).^2;
                    tempr = tempr + (x(id, 1) - x(j, 1)).^2 + (x(id, 2) - x(j, 2)).^2 + (x(id, 3) - x(j, 3)).^2;
                end
            end
        end
        if k > 0
            kk = kk + 1;
            tau(kk) = i;  % Here 'i' should be used, not 'kk'
            DataP(kk) = k;
            if nc == 1
                MSD(kk) = tempx / k;
            elseif nc == 2
                MSD(kk, :) = [tempx / k, tempy / k, tempr / k];
            else
                MSD(kk, :) = [tempx / k, tempy / k, tempz / k, tempr / k];
            end
        end
    end
    
    tau = tau / fps;  % Normalize tau by fps
end
