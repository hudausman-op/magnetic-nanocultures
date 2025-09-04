%Input:
%   image: 2d tif file 
%   Cdil_zise: Number of dilation cycles to separates the binary regions of different droplets
%   minr: Minimum accepted dropble radius. In case you choose small value
%   for raidus, the fitting proccess in the code will take long time

function [list,list_raw, conf]=efeaturenew_2D_Ring(image,Cdil_size,minr) 

%The function call assigns the outputs list, list_raw, and conf 
% using the input arguments image, 15, and 20.

% function efeaturenew,image,minr=minr,padsize=padsize,threshold=threshold
%list=[x y r] fitted
%list=[x y r] raw

% For 20nm NCs
% minA=900; 
% max_e=0.3;
% min_ex=0.6;

% ---
% Filtering/Thresholding
% ---

cdim = size(image);
minA=1200;%minArea
%maxA=100;%maxArea
max_e=0.5; %Eccentricity
min_ex=0.5; %Extent
Tr = double(graythresh(uint8(image)))*255;
%Tr =170;
%%
bwo=image<Tr;
bwf=imfill(bwo,'holes');
bwe=bwf & ~bwo;
%bwe=bwf & ~bwo;
bwfill = imfill(bwe, 'holes'); %addition oct-14-2023 HU for ecoli Cyan 

bwfilt=bwpropfilt(bwe,'Eccentricity',[0 max_e]);
bwfilt=bwpropfilt(bwfilt,'Area',[minA inf]);
bw=bwpropfilt(bwfilt,'Extent',[min_ex 1]);
%%
% bw=imfill(bw,'holes');
pad=double(bwdist(~bw));


% ---
% Initialize List
% ---
xyzr = []; %fitted radius 
xyr_c= []; %confidence

% ---
% find candidate features
% ---

for i=1:Cdil_size
    if i==1
        D=Cdil(pad);
    else
        D=Cdil(D);
    end
end

idx=find(D-pad==0 & pad>minr);
mx=pad(idx);
[mx,id]=sort(mx);
idx=idx(id);
[xl,yl]=ind2sub(size(D),idx);
dedge=min([xl cdim(1)-xl yl cdim(2)-yl],[],2);
idx=find(~(dedge<minr & dedge<mx/3) & mx>minr);
xl=xl(idx);yl=yl(idx);mx=mx(idx);
list=[xl yl mx];

overlap = zeros(length(list(:,1))-1,1);overlap_d=overlap;

for i=1:length(list(:,1))-1
    D=((list(i,1)-list(i+1:end,1)).^2+(list(i,2)-list(i+1:end,2)).^2).^.5;
    Ds=list(i,3)+list(i+1:end,3);
    [maxO,id]=min(D-Ds);
    overlap(i)=maxO;
    overlap_d(i)=id+i;
end

idx = find(overlap<=-1/2*list(1:end-1,3));
list(idx,:)=[];

[Xm,Ym]=meshgrid((1:1:cdim(2)),(1:1:cdim(1)));
xyr=[];
xyr_c=[];

for i=1:length(list(:,1))
    R=((Xm-list(i,2)).^2+(Ym-list(i,1)).^2).^.5;
    %limiting the portion of droplets for fitting
    idx=find(R<3*list(i,3)/4 & Xm>list(i,3)*1/5 & (cdim(1)-Xm)>list(i,3)*1/5 & Ym>list(i,3)*1/5 & (cdim(2)-Ym)>list(i,3)*1/5);
    %
    if length(idx)>10
        [xf,yf,rf,conf]=f_center(Xm(idx),Ym(idx),pad(idx));
        
    else
        xf=0;yf=0;rf=0;
        conf=[0 0 0];
    end
    
    xyr=[xyr;[yf,xf,rf]];
    xyr_c=[xyr_c;conf];
   
end

list_raw = list;
list = xyr;
conf = xyr_c;

idx = find(conf(:,1) == 0);
%idx = find(conf(:,1) == 0);
list(idx,:) = list_raw(idx,:);

[~,id] = sort(list(:,3));
list = list(id,:);list_raw=list_raw(id,:);conf=conf(id,:);
list(:,1:2) = list(:,[2,1]);
list_raw(:,1:2) = list_raw(:,[2,1]);

overlap=zeros(length(list(:,1))-1,1);overlap_d=overlap;
for i=1:length(list(:,1))-1
    D=((list(i,1)-list(i+1:end,1)).^2+(list(i,2)-list(i+1:end,2)).^2).^.5;
    Ds=list(i,3)+list(i+1:end,3);
    [maxO,id]=min(D-Ds);
    overlap(i)=maxO;
    overlap_d(i)=id+i;
end
idx=find(overlap<=-1/2*list(1:end-1,3));
list(idx,:)=[];
list_raw(idx,:)=[];
conf(idx,:)=[];





