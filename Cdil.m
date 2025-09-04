function D=Cdil(A)
s=size(A);
if length(s)==2
    B=zeros(s(1)+2,s(2)+2);
    B(2:end-1,2:end-1)=A;
    D=zeros(size(A));
    [dx,dy]=meshgrid((-1:1:1),(-1:1:1));
    dx=dx(:);dy=dy(:);
    for i=1:length(dx)
        D=max(B(2+dy(i):end-1+dy(i),2+dx(i):end-1+dx(i)),D);
    end
else
    B=zeros(s(1)+2,s(2)+2,s(3)+2);
    B(2:end-1,2:end-1,2:end-1)=A;
    D=zeros(size(A));
    [dx,dy,dz]=meshgrid((-1:1:1),(-1:1:1),(-1:1:1));
    dx=dx(:);dy=dy(:);dz=dz(:);
    for i=1:length(dx)
        D=max(B(2+dy(i):end-1+dy(i),2+dx(i):end-1+dx(i),2+dz(i):end-1+dz(i)),D);
    end
end
    