% NOTE %%%%%%% SAVE PLOT AS MSDdistr_vid#.fig IN THE CORRECT VIDEO FOLDER%%%%%%

% convert velocity into correct units 
clc
pixconv = input('Enter the value in the title of the video that converts pixels to microns: ' );
x0 = (vx_m./pixconv).*fps;

% Remove NaN values from x0
x0_clean = x0(~isnan(x0));

velMean = mean(x0_clean);
velMedian = median(x0_clean);
s = std(x0_clean);
% velMean = mean(x0);
% velMedian = median(x0);
% s = std(x0);
% create a new figure (number does not matter just pick one you have not
% used yet in the previous code)
figure(675)
% picks the correct velocities based on the n value we determined in the
% code for RunMSDscripts 
idx_plot = find(n>1.2);
% saves the data for a histogram with 50 bins
[y,x]=hist(x0_clean(idx_plot),100);
% normalizes the y data so it is Probability instead of number 
y=y./length(x0_clean(idx_plot));
% plots the data 
plot(x,y,'o')
hold on
plot([1 1]*velMean, ylim, '-k')
hold on 
plot([1 1]*velMedian, ylim, '-r')
xlabel('Velocity (\mum/s)')
ylabel('P(V)')
title('MSD Velocity Distribution')
legend('Velocity Distribution',['Mean=' num2str(velMean)],['Median=' num2str(velMedian)]);
