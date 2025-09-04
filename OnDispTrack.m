function OnDispTrack( res,fignum,c )
figure(fignum)

plotcolor='bgrcmy';
id=unique(res(:,4));
% st=330;
for i=1:length(id);
    idx=find(res(:,4)==id(i));
    pos = res(idx,1:2);
    if c==1
        plot( pos(:,1), pos(:,2), sprintf('%c-', plotcolor(mod(i-1,length(plotcolor))+1)) );

        plot( pos(1,1), pos(1,2), sprintf('%cs', plotcolor(mod(i-1,length(plotcolor))+1)) );
    else
    plot( pos(:,1), pos(:,2), c);
    end
    hold on
%     plot( pos(1,1), pos(1,2), 'ks');
    
    clear pos;
end;
hold off