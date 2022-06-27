%% Input Problem
Z = [3 5]; % Objective function
A = [1 2;1 1;0 1]; % Constrains
b = [2000;1500;600]; % RHS

%% Ploting Graph
x1 = 0:1:max(b); % X-axis 0..1..2..3..4..5....max(b)

x21 = (b(1) - A(1,1).*x1)./A(1,2); % a1*X1 + a2*X2 = b1  
x22 = (b(2) - A(2,1).*x1)./A(2,2); % X2 = (b1 - a1*X1)/a2
x23 = (b(3) - A(3,1).*x1)./A(3,2);

x21 = max(0,x21); % Since my x1,x2 >=0 
x22 = max(0,x22); % any -ve value will be replace by zero
x23 = max(0,x23);

plot(x1,x21,'r',x1,x22,'g',x1,x23,'b');
xlabel('Value of X1');
ylabel('Value of X2');
legend('x1 + 2x2 = 2000','x1 + x2 = 1500','x2 = 600');

%% Finding Corner Points on Axis

cx1 = find(x1==0); % points where x1 == 0

c1 = find(x21==0); % points where x21 == 0
Line1 = [x1(:,[c1 cx1]); x21(:,[c1 cx1])]';  % [(x1,x2) ; (x1,x2)]

c2 = find(x22 ==0);
Line2 = [x1(:,[c2 cx1]); x22(:,[c2 cx1])]';

c3 = find(x23 ==0);
Line3 = [x1(:,[c3 cx1]); x23(:,[c3 cx1])]';

final = unique([Line1;Line2;Line3],'rows'); 
%  the unique function takes each row as a unique element and 
%  will return the rows in order from smallest to largest, 
%  removing duplicate rows

%% Finding Intersection Points
Hg = [0;0];
for i=1:size(A,1)
    hg1 = A(i,:);
    b1 = b(i);
    for j=i+1:size(A,1)
        hg2 = A(j,:);
        b2 = b(j);
        Aa = [hg1;hg2];
        Bb = [b1;b2];
        Xx = Aa\Bb;
        Hg = [Hg Xx];
    end
end
pts = Hg';

%% All Corner Points of BFS
allpts = [pts;final];
points = unique(allpts,'rows');

%% Finding FR points

%%%% Constraint 1
X1 = points(:,1);
X2 = points(:,2);
const1 = X1 + 2.*X2 -2000;  % <= 0 
h1 = find(const1>0);    % return index of all points which does not satisfy condition
points(h1,:) = [];           % remove all such Constraints

%%%% Constraint 2
X1 = points(:,1);
X2 = points(:,2);
const2 = X1 + X2 -1500;  % <= 0 
h2 = find(const2>0);    % return index of all points which does not satisfy condition
points(h2,:) = [];           % remove all such Constraints

%%%% Constraint 3
X1 = points(:,1);
X2 = points(:,2);
const3 = X2 -600;  % <= 0 
h3 = find(const3>0);    % return index of all points which does not satisfy condition
points(h3,:) = [];           % remove all such Constraints

PT = unique(points,'rows');

%% Compute Objective Function Value

for i=1:size(PT,1)
    Fx(i,:) = sum(PT(i,:).*Z);
end

final_ans = [PT Fx];

%% Find Optimal Value
[fx_val,indx] = max(Fx);
opt_val = final_ans(indx,:);

OPT_BFS = array2table(opt_val);
OPT_BFS.Properties.VariableNames(1:size(OPT_BFS,2)) = {'X1','X2','VALUE'}