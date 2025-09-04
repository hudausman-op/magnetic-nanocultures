function fancytrack_Mehdi(parfilename,trackfilename, maxdisp, goodenough, memory)
%particlefile = is the one that we generated
%trackfile = what we will save--our trajectory file
%maxdisp = maximum displacement--how far bacteria will displace in pixels?
%maximum distance that we are allowing our bacteria to move
%goodenough = if we want to keep everything this value = 1
%but if we are saying that tracjectory last 10 frames so the value =10
%memory = when the particle goes missing so we can search for the two
%frames later and see if the particle comes up--this value is non-zero if
%you want your code to NOT terminate and using its memory find the same
%particle and complete the trajectory
% Runs trackmem on the output from mpretrack. 
%
% INPUTS
%
% basepath - the basepath of the experiments. Reads the MT matrix from
%       "Feature_finding\MT_##_Feat_Size_" featsize ".mat", as output by
%       mpretrack
% FOVnum - specifies which series of images to process
% featsize - specifies the feature size for accessing the right MT file
% maxdisp - (optional) specifies the maximum displacement (in pixels) a feature may 
%       make between successive frames
% goodenough - (optional) the minimum length requirement for a trajectory to be retained 
% memory - (optional) specifies how many consecutive frames a feature is allowed to skip. 
%
% OUTPUTS
%
% creates subfolders "Bead_tracking\res_files\" in which it saves
% "res_fov##.mat" files, with a "res" matrix which is the output from
% trackmem
%
% res matrix format:
% 1 row per bead per frame, sorted by bead ID then by frame number.
% columns are:
% 1:2 - X and Y positions (in pixels)
% 3   - Integrated intensity
% 4   - Rg squared of feature
% 5   - eccentricity
% 6   - frame #
% 7   - time of frame
% 8   - Bead ID
%
% REVISION HISTORY
% written by Paul Fournier and Vincent Pelletier (Maria Kilfoil's group),
% last revision 10/18/07

if nargin < 5, memory=1; end
if nargin < 4, goodenough=100; end
if nargin < 3, maxdisp=2; end
load(parfilename) 
% idx=find(MT(:,7)<30);
% MT=MT(idx,:);
res=trackmem( MT, maxdisp, 2, goodenough, memory );
save( trackfilename, 'res');


