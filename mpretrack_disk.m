function [M2,MT] = mpretrack_disk(basepath,outputname,inv, min_R,Cdil_size, frames)

pathin = basepath;

d=0;
MT=[];
M2=[];
for i=1:length(frames)
    image = imread(sprintf(pathin,frames(i)));


    if inv == 1
        image = 255-image;
    end

    %[list,list_raw, conf]=efeaturenew_2D_Ring(image,Cdil_size,min_R); %use this with hollow capsules ("RING"-like)
    %[list,list_raw, conf]=efeaturenew_2D(image,Cdil_size,min_R); %use this
    %for capsules containing bacteria, therefore they are dark inside. So
    %more like 2D circles
    [list,list_raw, conf]=efeaturenewv2_2D(image,Cdil_size,min_R);
    M = [list list_raw(:,3) conf(:,3)];
    M_raw = [list_raw list_raw(:,3) conf(:,3)];

    a = length(M(:,1));

    MT(d+1:a+d, 1:7)=[M(1:a,1:5) zeros(a,2)+frames(i)];
    M2(d+1:a+d,1:7)=[M_raw(1:a,1:5) zeros(a,2)+frames(i)];
    d=d+a;
    disp(frames(i));
end
save(outputname,'MT','M2');
