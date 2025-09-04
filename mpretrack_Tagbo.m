function mpretrack_Tagbo(filefmt,outputname,Inv,featuresize,barrI,barrRg,barrCc,IdivRg,numframes,masscut,Imin,maskparam,lambda,field)

% This program should be used when you have determined the values of its
% parameters using mpretrack_init. The calling sequence is
% essentially the same. The features and found by calling feature2D (with
% parameters other than feature size hardcoded).
%
% Note: feature2D requires the Image processing toolbox due to a call to
% imdilate in the localmax subfunction. Use feature2D_nodilate for an
% alternative which works almost as well.
%
% INPUTS :
% basepath - The base path for the experiment. "fov#_times.mat" files
%           should be there, and individual images should be in
%           "fov#\fov#_####.tif"
% fovn - ID# for the series of images (typically, one field of view)
% featuresize - The size of the feature you want to find.
% barrI - The minimum intensity you want to accept.
% barrRg - The maximum Rg squared you want to accept.
% barrCc - The maximum eccentricity you want to accept.
% IdivRg - minimum ratio of Intensity/pixel to be accepted (integrated
%           intensity / Rg squared of feature)
% numframes - The number of images you have in your series
% Imin - (optional) the minimum intensity for a pixel to be considered as a potential
%           feature.
% masscut - (optional) the masscut parameter for feature2D to remove false positives
%           before rifining the position to speed up the code.

% Commented out:
% Inv - A logical for inverting the image (1 inverts, 0 doesn't) to look
%           for dark features instead of bright ones.
% maskparam=[xc,yc,rc]: this is assuming circular fov in with the center at [xc yc]
% with the radius of rc.



% OUTPUTS
%
% - Creates a subfolder called "Feature_Finding" where it outputs the
% accepted features' MT matrix (from feature2D) as "MT_##_Feat_Size_"
% featuresize ".mat"
% - copies last frame into same subfolder
%
% MT matrix format:
% 1 row per bead per frame, sorted by frame number then x position (roughly)
% columns:
% 1:2 - X and Y positions (in pixels)
% 3   - Integrated intensity
% 4   - Rg squared of feature
% 5   - eccentricity
% 6   - frame #
% 7   - time of frame
%
% REVISION HISTORY
% written by Paul Fournier and Vincent Pelletier (Maria Kilfoil's group),
% latest revision 10/18/07
% 10/26/07 Vincent -- commented out the Inv keyword, added a ratio of
% Iint to Rg parameter
% 12/21/07 Maria -- added optional field
% 06/10/2020 Mehdi: remove field add ciruclar mask

if nargin < 14, field = 2; end
if nargin < 13, lambda = 2; end

tic
d=0;

for x = 1:numframes

    img=imread(sprintf(filefmt,x));
    n=size(img);
    if length(n)>2
        img=rgb2gray(img);
    end
    if Inv == 1
        img=255-img;
    end
    
    sz=size(img);
    xc=maskparam(1); yc=maskparam(2); rc=maskparam(3);
%     xc=300;yc=300;rc=265;
    [X,Y]=meshgrid((1:sz(1)),(1:sz(1)));
    idx=find(((X-xc).^2+(Y-yc).^2).^.5>rc);
    img(idx)=0;

    M = feature2D(img,lambda,featuresize,masscut,Imin,field);

    if mod(x,50) == 0
        disp(['Frame ' num2str(x)])
        % partway save, useful if the computer tends to crash for some
        % reason
%         save([pathout 'MT_' num2str(fovn) '_Feat_Size_' num2str(featuresize) '_partial.mat'] ,'MT')
    end

    [~,b]=size(M);
    
if( b == 5 )    

        %Rejection process
    X=find(M(:,5)>barrCc);
    M(X,1:5)=0;
    X=find(M(:,4)>barrRg);
    M(X,1:5)=0;
    X=find(M(:,3)<barrI);
    M(X,1:5)=0;
    X=find(M(:,3)./M(:,4)<IdivRg);
    M(X,1:5)=0;

    M=M(M(:,1)~=0,:);

    a = length(M(:,1));

    MT(d+1:a+d, 1:5)=M(1:a,1:5);
    MT(d+1:a+d, 6)=x;
    MT(d+1:a+d, 7)=x;
    d = length(MT(:,1));
    disp([num2str(a) ' features kept.    frame=' num2str(x) ])
end
    clear img;
    clear R;
    clear M;
    clear pic;
    clear X;
    clear t;
    clear i;
    clear j;
    if rem(x,50)==0
        save(outputname,'MT')
    end
end

format long e;

save(outputname,'MT')

  

clear all;
format short;

disp(['The program ran for ' num2str(toc/60) ' minutes'])
