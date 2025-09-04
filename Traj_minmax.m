choose_num = 11; %Choosing how many trajectories to consider
%fps =24;

id = unique(res(:,8));
l = length(id);
x_range = zeros(l,2); %Range of trajs

for i = 1:l
    idx = res(:,8) == id(i);
    x_range(i,:) = [min(res(idx,1)), max(res(idx,1))];
end

dx = x_range(:,2) - x_range(:,1);
[~,id_long] = sort(dx,'descend');

%figure()
hold on

res_choose = [];
for i = 1:choose_num
    idx = res(:,8) == id(id_long(i));
    res_choose = [res_choose;res(idx,:)];
    plot(res(idx,1),res(idx,7),'o', 'MarkerSize',5,'Linewidth',1, 'DisplayName',num2str(id(id_long(i))))
    ylabel('Time (s)','FontSize',20,'FontWeight','bold','Color','k');
    xlabel('Distance Traveled (\mum)','FontSize',25,'FontWeight','bold','Color','k');
    %title('Velocity of 0.05% 20nm Magnetic Microcapsules','FontSize',33,'FontWeight','bold','Color','k');
end

% res_choose = [];
% for i = 1:choose_num
%     idx = res(:,8) == id(id_long(i));
%     res_choose = [res_choose;res(idx,:)];
%     plot(res(idx,7)/fps, res(idx,1)*3,'o', 'MarkerSize',5,'Linewidth',2, 'DisplayName',num2str(id(id_long(i))))
%     xlabel('Time of Frame (s)','FontSize',30,'FontWeight','bold','Color','k');
%     ylabel('Nanoculture Position (\mum)','FontSize',33,'FontWeight','bold','Color','k');
%     %title('Velocity of 0.05% 20nm Magnetic Microcapsules','FontSize',33,'FontWeight','bold','Color','k');
% end
