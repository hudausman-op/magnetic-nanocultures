velocvedd==figure(310)
hold off
for i=1:length(velocityinfo)
    scatter(velocityinfo(i).res(:,1),velocityinfo(i).res(:,3),velocityinfo(i).res(:,5))
    hold on
end