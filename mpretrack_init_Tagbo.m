function [M2,MT] = mpretrack_init_Tagbo(basepath,inv, featsize, barint, barrg, barcc, IdivRg, frame, masscut, Imin,maskparam, field)
 
% Used to find the parameters (minimum intensity, maximum Rg, maximum eccentricity, feature
% fize, masscut, Imin). These parameters should then be passed to mpretrack.
%
% Note: feature2D requires the Image processing toolbox due to a call to
% imdilate in the localmax subfunction. Use feature2D_nodilate for an
% alternative which works almost as well.
%
% INPUTS :
% basepath - The base path for the experiment. "fov#_times.mat" files
%           should be there, and individual images should be in
%           "fov#\fov#_####.tif"
% inv - dark or bright field. dark field=1, bright field=0
% featsize - The size of the feature you want to find.
% barint - The minimum intensity you want to accept.
% barrg - The maximum Rg squared you want to accept.
% barcc - The maximum eccentricity you want to accept.
% IdivRg - minimum ratio of Intensity/pixel to be accepted (integrated
%           intensity / Rg squared of feature)
% fovn - ID# for the series of images (typically, one field of view)
% frame - ID# for the image in the series
% Imin - (optional) the minimum intensity for a pixel to be considered as a potential
%           feature.
% masscut - (optional) the masscut parameter for feature2D to remove false positives
%           before rifining the position to speed up the code.
% field - (optional) set to 0 or 1 if image is actually odd or even field of an interlaced 
%           image. All the masks will then be constructed with a 2:1 aspect ratio. Otherwise 
%           set to 2 for progressive scan cameras. Defaults to 2.
%
% commented out:
% inv - A logical for inverting the image (1 inverts, 0 doesn't) to look
%           for dark features instead of bright ones.
%
% Also, the program looks for the files "fov#_times.mat" for the "time"
% variable and the images files "fov#\fov#_####.tif" from the basepath.
%
% OUTPUTS 
% 
% M2 - All the features found from calling feature2D
% MT - All the features from feature2D which were accepted given the
% criteria from the inputs
%
% The following appear on the command line as output:
%
% - Number of features found (prior to eliminating anything).
% - A matrix with the positions in columns 1-2 and the parameters int,rg
% and cc in columns 3-5. (accepted features first, then rejected features)
% - Min I, Max Rg, Max Cc these values help you sum up quickly what is in
% the matrix that appears. 
% - A plot showing the image and dots for rejected features and circles for
% accepted features
%
% REVISION HISTORY
% written by Paul Fournier and Vincent Pelletier (Maria Kilfoil's group),
% latest revision 10/18/07
% 10/26/07 Vincent -- commented out the Inv keyword, added a ratio of
% Iint to Rg parameter
% 12/21/07 Maria - added optional field parameter

lambda=2;
if nargin < 12, field = 2; end

pathin  = basepath;

d=0;
MT=[];
Mrej=[];


  img=imread(sprintf(pathin,frame));
%img2=imread(pathin,frame) pathin=name of the file including the address
%img=rgb2gray(img);
img=im2gray(img);
img2=img;
    if inv == 1
        img = 255-img;
    end

    sz=size(img);
    xc=maskparam(1); yc=maskparam(2); rc=maskparam(3);
    [X,Y]=meshgrid((1:sz(1)),(1:sz(1)));
    idx=find(((X-xc).^2+(Y-yc).^2).^.5>rc);
    img(idx)=0;
    
    
    M = feature2D(img,lambda,featsize,masscut,Imin,field);

    a = length(M(:,1));
    
    M2=M;
    if length(M)>1
     for i=1:a
         if ((M(i,5)>barcc))      
            Mrej=[Mrej; M(i,:)];
             M(i,1:5)=0;
%          end

         elseif ((M(i,4)>barrg))
            Mrej=[Mrej; M(i,:)];
             M(i,1:5)=0;
%          end

         elseif ((M(i,3)<barint))
            Mrej=[Mrej; M(i,:)];
             M(i,1:5)=0;
         elseif((M(i,3)/M(i,4)<IdivRg))
            Mrej=[Mrej; M(i,:)];
             M(i,1:5)=0;
         end    
     end
    


    M=M(M(:,1)~=0,:);

    a = length(M(:,1));

    MT(d+1:a+d, 1:5)=M(1:a,1:5);
%
%     figure;
    hold off
    imshow(img2);
    
    hold on
    plot(MT(:,1),MT(:,2),'bs');
    plot(M2(:,1),M2(:,2),'ro');
%}
%{
    
    format short g
    disp(M)
    disp(['Kept : ' num2str(size(M,1))])
    disp(Mrej)
    disp(['Minimum Intensity : ' num2str(min(M(:,3)))])
    disp(['Maximum Rg : ' num2str(max(M(:,4)))])
    disp(['Maximum Eccentricity : ' num2str(max(M(:,5)))])
    clear img;
    clear R;
    clear pic;
    clear X;
    clear t;
    clear i;
    clear j;
%}
    else
        MT=[];
        M2=[];
    end



   
