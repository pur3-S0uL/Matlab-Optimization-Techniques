%% Input Paramters

no_var = 2;
Z = [3 5];
A = [-1 -3;-1 -1];
b = [-3;-2];

%% Constructing Simplex Table

s = eye(size(A,1));
Aa = [A s b];

%%%% Cost of each variable
Cost = zeros(1,size(Aa,2));
Cost(1:no_var) = Z;

%%%% Basic Variables
BV = no_var+1:size(Aa,2)-1;

%%%% Computing Zj-Cj
Zj_Cj = Cost(BV)*Aa -Cost;

%% Printing First Simplex Table

Aa1 = [Zj_Cj;Aa];
Simp_table = array2table(Aa1);
Simp_table.Properties.VariableNames(1:size(Simp_table,2)) = {'x1','x2','s1','s2','Sol'}

%% SIMPLEX

RUN = true;
while RUN
    Xb = Aa(:,end);
    if any(Xb<0)
        fprintf('  The current BFS is not Feasible\n');
        
        %% Finding Entering Variable
        [leav_row,pvt_row] = min(Aa(:,end));
        
        sol = Zj_Cj(1:end);
        row = Aa(pvt_row,:);
        
        if all(row>=0)
            error('Unbounded');
        else
            
            %% Finding Entering Variable
            for i=1:size(row,1)
                if row(i)<0
                    ratio(i) = abs(sol(i))/abs(row(i));
                else
                    ratio(i) = inf;
                end
            end
            [minR,pvt_col] = min(ratio);
        end
        BV(pvt_col) = pvt_row;

        %% Pivot Key
        pvt_key = Aa(pvt_row,pvt_col);

        %% Updating Table
%         Zj_Cj = Zj_Cj - Zj_Cj(pvt_col).*Aa(pvt_row,:);
        Aa(pvt_row,:) = Aa(pvt_row,:)./pvt_key;

        for i=1:size(Aa,1)
            if i~=pvt_row
                Aa(i,:)= Aa(i,:) - Aa(i,pvt_col).*Aa(pvt_row,:);
            end
        end

        %% Printing New Simplex Table
        Aa1 = [Zj_Cj;Aa];
        Simp_table = array2table(Aa1);
        Simp_table.Properties.VariableNames(1:size(Simp_table,2)) = {'x1','x2','s1','s2','Sol'}
        
    else
        RUN = false;
        fprintf('Feasible');
    end
end

%% Final Optimal Solution

f_bfs = zeros(1,size(Aa,2));
f_bfs(BV) = Aa(:,end);
f_bfs(end) = sum(f_bfs.*Cost);
O_bfs = array2table(f_bfs);
O_bfs.Properties.VariableNames(1:size(O_bfs,2)) = {'x1','x2','s1','s2','Sol'}