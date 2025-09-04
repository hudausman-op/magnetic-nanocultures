function LimitFoI(infmt,outfmt,frames,topl,botR)
%topl=[xl yl]: top corner of FoI
%botR=[xr yr]: bottom corner of FoI

for i=1:length(frames);
    a=imread(sprintf(infmt,frames(i)));
    imwrite(a(topl(2):botR(2),topl(1):botR(1)),sprintf(outfmt,frames(i)),'tif','compression','none');
end