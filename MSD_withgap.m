% DO NOT RUN THIS CODE
% fast MSD calculation for a series with  missing points in the trajectory
% (Slower than version MSD_nogap)
% time point associated with positions
% X: 2d or 3d position vector
% Fps: frame rate
% maxlag: maximum lag time (in frame)
%

%output:
%MSD: in 2d: [Dx^2 Dy^2 Dr^2] in 3d: [Dx^2 Dy^2 Dz^2 Dr^2]
%tau: lag time in seconds
%DataP: number of data point used to measure the MSD in each every lag-time

function [MSD,tau,DataP]=MSD_withgap(t,x,fps,maxLag)
tm=max(t)-min(t);
kk=0;
Sz=size(x);
nr=Sz(1); nc=Sz(2);
t=reshape(t,length(t),1);
if nc>nr
    x=x';
end
nc=size(x);
nc=nc(2);
tm=min(maxLag,tm);
for i=1:tm
    tempx=0;
    tempy=0;
    tempz=0;
    tempr=0;
    k=0;
    for j=1:length(t)-i
        id=find(t==(t(j)+i));
        if ~isempty(id)
            k=k+1;
            if nc==1
                tempx=tempx+(x(id)-x(j)).^2;
            elseif nc==2
                tempx=tempx+(x(id,1)-x(j,1)).^2;
                tempy=tempy+(x(id,2)-x(j,2)).^2;
                tempr=tempr+(x(id,1)-x(j,1)).^2+(x(id,2)-x(j,2)).^2;
            else
                tempx=tempx+(x(id,1)-x(j,1)).^2;
                tempy=tempy+(x(id,2)-x(j,2)).^2;
                tempz=tempz+(x(id,3)-x(j,3)).^2;
                tempr=tempr+(x(id,1)-x(j,1)).^2+(x(id,2)-x(j,2)).^2+(x(id,3)-x(j,3)).^2;
            end
        end

    end
    if k>0
        kk=kk+1;
        tau(kk)=kk;
        DataP(kk)=k;
        if nc==1
            MSD(kk)=tempx/k;
        elseif nc==2
            MSD(kk,:)=[tempx/k tempy/k tempr/k];
        else
            MSD(kk,:)=[tempx/k tempy/k tempz/k tempr/k];
        end
    end
end

tau=tau/fps;
