%This will load trajectories in resfile and caclulate MSD exponent and mean
%average speed of each trajectory
%you need to identify maxLg time that you want MSD to be calculated.
resfile = resfile;
maxLag = 5;%how long we want to measure MSD for, max num we can use is the longest traj we have 
fps = 0.31; % I got this from the video properties
load(resfile);
id = unique(res(:,8));


min_length=6;%gets rid of shorter trajectories 
res_temp=res;
for i=1:length(id)
    idx = find(res_temp(:,8) == id(i));
    if length(idx)<min_length
        res_temp(idx,:)=[];
    end
end
res=res_temp;
id=unique(res(:,8));

n = zeros(length(id),1);
v = n;
MSDE = zeros(maxLag,1);

for i = 1:length(id)
    idx = find(res(:,8) == id(i));
    
    [MSD,tau,DataP] = MSD_withgap(res(idx,7),res(idx,1:2),fps,maxLag);
        
    % Debugging output to check the size of MSD
    fprintf('MSD size for particle %d: %s\n', i, mat2str(size(MSD)));

    % Check if MSD has enough data points
    availableLag = min(size(MSD, 1), maxLag);
    if availableLag > 0 && size(MSD, 2) >= 3
        MSDE(1:availableLag) = MSDE(1:availableLag) + MSD(1:availableLag, 3);
    else
        warning('Skipping particle %d due to incompatible MSD size.', i);
    end

    MSDE = MSDE + MSD(:,3);
    MSDI(i).MSD = MSD(:,3);
    
    %polynomial fit
    p=polyfit(log(tau)',log(MSD(:,3)),1);
    n(i) = p(1);
    vx=diff(res(idx,1))./diff(res(idx,7));
    vy=diff(res(idx,2))./diff(res(idx,7));
    v(i)=mean(sqrt(vx.^2+vy.^2));
end

MSDE = MSDE./length(id);
idxp=find(n<1.2 & v<0.6);
idxa=find(~(n<1 & v<0.6));
MSDEP=0;
MSDEA=0;

for i=1:length(idxp)
    MSDEP = MSDEP+MSDI(idxp(i)).MSD;
end

MSDEP=MSDEP./length(idxp);

for i=1:length(idxa)
    MSDEA = MSDEA+MSDI(idxa(i)).MSD;
end

MSDEA=MSDEA./length(idxa);

% plots the MSD for swimmers and brownian motion

figure(1)
loglog(tau,MSDEA,'ro')
Const = polyfit(log(tau)', log(MSDEA), 1);
hold on
plot(tau, exp(polyval(Const, log(tau))),'r-');
hold on
loglog(tau, MSDEP,'bo')
Const2 = polyfit(log(tau)', log(MSDEP), 1);
hold on
plot(tau, exp(polyval(Const2, log(tau))),'b-');
legend('Swimmers','','Brownians','','Location','northwest')
xlabel('tau(s)')
ylabel('dr^2 (micrometers^2)')
xlim([0.007 .1])