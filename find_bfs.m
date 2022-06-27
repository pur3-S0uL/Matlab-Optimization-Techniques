%% Input Parameters
Z = [2 3 4 7];
A = [2 3 -1 4;1 -2 6 -7];
b = [8;-3];

%%%% No. of Constraints and Variables
m = size(A,1);  % No. of constraints [No. of Rows]
n = size(A,2);  % No. of variables   [No. of Columns]

%% Compute n_C_m BFS
nv = nchoosek(n,m);     % Total Number of Basic solutions
t = nchoosek(1:n,m);    % Pair of Basic solution

if n>=m
    sol = [];
    for i=1:nv
        y = zeros(n,1);
        x = A(:,t(i,:))\b;  % x = inv(B).*b
    
        %%%% Checking Feasibility Condition
        if all(x>=0 & x~=inf & x~=-inf)
            
            y(t(i,:))=x;
            sol = [sol y];
        end
    end
else
    error('No. of Equations > No. of variables');
end

%% Calculate Objective Function
Zz = Z*sol;

%% Finding Optimal Value
[Z_max ,Z_indx] = max(Zz);
BFS = sol(:,Z_indx);    %%%% Optimal BFS Value

opt_val = [BFS' Z_max];
Optimal_BFS = array2table(opt_val);
Optimal_BFS.Properties.VariableNames(1:size(Optimal_BFS,2)) = {'x1','x2','x3','x4','Value_of_Z'}