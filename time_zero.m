

idx=unique(res(:,7));

for j=1:length(idx)
hold on
id=unique(res(:,8));
t_sub=res(:,7);
for i=1:length(id)
    idx=find(res(:,8)==id(i));
    t_sub(idx)=res(idx,7)-res(idx(1),7);
end
end




