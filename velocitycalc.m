Channel_len=1200; %distance of the magnet from the left side of the image %0.3275px/um;959x529px
px_size=1;% pixel to um conversion 3.05;
fps = 24;%24; %frames per second % used 1 for ecoli cyan vdo 10-21-23
pr_vy = 10000; %maximum velocity/displacement of capsules in y-direction in each frame we are letting it count
id = unique(res(:,8)); %particle ID

deltat = 1;  %spacing btw the frames

clear velocityinfo

k=1; %Initializes a variable k with a value of 1.
% This variable will be used as an index to
% store data in the velocityinfo structure

for i = 1:length(id) %This starts a for loop that iterates over the elements of the array id.
    % The loop variable i takes on values from 1 to the length of the id array.

    id_x = find(res(:,8) == id(i)); %This line finds the indices in the 8th column (res(:,8)) of the matrix res where the value matches the current element id(i) from the id array. It stores these indices in the id_x array.

    if length(id_x)>1
        length(id_x)
        x = res(id_x,1)*px_size;  % 1 Pixels= 2.67 um
        y = res(id_x,2)*px_size;   %pixels to um
        t = res(id_x,7)/fps; %In seconds
        r = res(id_x,3)*px_size; %radius of droplets
        %     dx = x(deltat:end)-x(1:end-(deltat-1));
        %     dy = y(deltat:end)-y(1:end-(deltat-1));
        %     dt = t(deltat:end)-t(1:end-(deltat-1));
        dx = diff(x);
        dy = diff(y);
        dt = diff(t);
        Vx = dx./dt;
        Vy = dy./dt;


        %velocityinfo(i).res = [x(1:end-(deltat-1)),y(1:end-(deltat-1)),Vx,Vy];
        velocityinfo(k).res = [x(1:end-(deltat)),y(1:end-(deltat)),Vx,Vy,r(1:end-deltat)];%
        k=k+1;
    end
end

V=[];
for i=1:length(velocityinfo)
    V=[V;velocityinfo(i).res];
end

xc=(5:5:1200)*px_size;
vx_m=zeros(size(xc))*px_size;
bin_size = 5*px_size; %pixels before and after to get the average
l_bin = zeros(size(xc));
vx_err = zeros(size(xc)); %error in the measurement

tr_std = 1;

for i=1:length(xc)
    idx=find(abs(V(:,1)-xc(i))<bin_size);
    vx_temp = V(idx,3);
    vy_temp = V(idx,4);

    vm_temp = median(vx_temp);
    vm_std = std(vx_temp);

    jdx = abs(vx_temp - vm_temp) < vm_std*tr_std & abs(vy_temp) < pr_vy;
    l_bin(i) = sum(jdx);

    vx_m(i)=mean(vx_temp(jdx));
    vx_err(i)=std(vx_temp(jdx))/sqrt(l_bin(i));
    %vx_m(i)=mean(V(idx,3));
end
xc=Channel_len-xc;

yc=(5:5:600)*px_size;
vx_my=zeros(size(yc))*px_size;
bin_size=1*px_size; %pixels
for i=1:length(yc)
    idx=find(abs(V(:,2)-yc(i))<bin_size);
    vx_my(i)=mean(V(idx,3));
end

Bin = 10*px_size;
[X,Y]=meshgrid((1:5:3700),(1:5:2500));
Vm=zeros(size(X));
for i=1:length(X(:))
    idx=find(abs(V(:,1)-X(i))<Bin & abs(V(:,2)-Y(i))<Bin);
    Vm(i)=mean(V(idx,3));
    length(idx)
end
X=Channel_len-X;

%finding velocity of capsules of same size
rc=45.6:1:49*px_size; %radius of the capsules
v_r=zeros(size(rc))*px_size;
for i=1:length(rc)
    idx=find(abs(V(:,5)-rc(i))<5);
    v_r(i)=mean(V(idx,3));
end


Bin=30;
bin_r = 5; %5 is default
[Xr,Yr]=meshgrid((1:10:1000),(1:10:100));
Vmr=zeros(size(Xr));
for i=1:length(Xr(:))
    idx_r=find(abs(V(:,1)-Xr(i))<Bin & abs(V(:,5)-Yr(i))<bin_r);
    Vmr(i)=mean(V(idx_r,3));
end
Xr=Channel_len-Xr;
