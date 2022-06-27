%% Input Paramters

no_var = 3;
Z = [-1 3 -2];
A = [3 -1 2;-2 4 0;-4 3 8];
b = [7;12;10];

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
Simp_table.Properties.VariableNames(1:size(Simp_table,2)) = {'x1','x2','x3','s1','s2','s3','Sol'}

%% SIMPLEX

RUN = true;
while RUN
    ZC = Zj_Cj(1:end-1);
    if any(Zj_Cj<0)
        fprintf('  The current BFS is not optimal\n');
        
        %% Finding Entering Variable
        [ent_col,pvt_col] = min(ZC);
        
        sol = Aa(:,end);
        col = Aa(:,pvt_col);
        
        if all(col<=0)
            error('Unbounded');
        else
            
            %% Finding Leaving Variable
            for i=1:size(col,1)
                if col(i)>0
                    ratio(i) = sol(i)/col(i);
                else
                    ratio(i) = inf;
                end
            end
            [minR,pvt_row] = min(ratio);
        end
        BV(pvt_row) = pvt_col;

        %% Pivot Key
        pvt_key = Aa(pvt_row,pvt_col);

        %% Updating Table
        % Zj_Cj = Zj_Cj - Zj_Cj(pvt_col).*Aa(pvt_row,:);
        Aa(pvt_row,:) = Aa(pvt_row,:)./pvt_key;

        for i=1:size(Aa,1)
            if i~=pvt_row
                Aa(i,:)= Aa(i,:) - Aa(i,pvt_col).*Aa(pvt_row,:);
            end
        end

        %% Printing New Simplex Table
        Aa1 = [Zj_Cj;Aa];
        Simp_table = array2table(Aa1);
        Simp_table.Properties.VariableNames(1:size(Simp_table,2)) = {'x1','x2','x3','s1','s2','s3','Sol'}
        
    else
        RUN = false;
        fprintf('Optimal');
    end
end

%% Final Optimal Solution

f_bfs = zeros(1,size(Aa,2));
f_bfs(BV) = Aa(:,end);
f_bfs(end) = sum(f_bfs.*Cost);
O_bfs = array2table(f_bfs);
O_bfs.Properties.VariableNames(1:size(O_bfs,2)) = {'x1','x2','x3','s1','s2','s3','Sol'}