k=8;
j=[];
f=@(x)(x*(x-2));

j(1)=1;
j(2)=1;
    
for i=3:8
    j(i)=j(i-1)+j(i-2);
end

disp(j)
L=0;
R=1.5;


for i=1:4
    ratio(i)=j(k-i)/j(k-i+1);
    x2=L+ratio(i)*(R-L);
    x1=L+R-x2;
    f(x1)
    f(x2)
    disp(ratio(i));
    if f(x1)<f(x2)
        R=x2;
    else
        L=x1;
    end
end

x3=(L+R)/2;

f(x3)