variables = {'x1','x2','s2','s3','A1','A2','Sol'};
M = 1000;
Cost = [-2 -1 0 0 -M -M 0];
A = [3 1 0 0 1 0 3;4 3 -1 0 0 1 6;1 2 0 1 0 0 3];

s= eye(size(A))

% Finding Starting BFS
BV=[];
for j=1:size(A,2)
    for i=1:size(A,2)
        if A(:,i) == s(:,j) %if j_th column of 's' == i_th column of 'A'
            BV = [BV i];
        end
    end
end

% calculating Zj-Cj
Zj_Cj = Cost(BV)*A - Cost;

% Simplex Table
ZCj = [Zj_Cj;A];
SimplexTable = array2table(ZCj)
SimplexTable.Properties.VariableNames(1:size(ZCj,2)) = variables

% Finding Entering Variable

RUN = true;
while RUN
    zc = Zj_Cj(:,1:end-1);
    if any(zc < 0)
        [Ent_var,pvt_col] = min(zc); % return (min value),(min val index) in zc matrix
    
        % Finding Leaving Var
        sol = A(:,end);
        column = A(:,pvt_col);
    
        if all(column <=0)
            error('Unbounded');
        else
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i) = sol(i)/column(i);
                else
                    ratio(i) = inf;
                end
                [minR,pvt_row] = min(ratio);
            end
            BV(pvt_row) = pvt_col;
        
            B = A(:,BV);
            A = B\A;
            Zj_Cj = Cost(BV)*A - Cost;
        
            ZCj = [Zj_Cj;A];
            SimplexTable = array2table(ZCj)
            SimplexTable.Properties.VariableNames(1:size(ZCj,2)) = variables

        end
    
    else
        RUN = false;
        disp('Optimal')
    end
end

% Final Optimal Solution Print
f_bfs = zeros(1,size(A,2));
f_bfs(BV) = A(:,end);
f_bfs(end) = sum(f_bfs.*Cost);

O_bfs = array2table(f_bfs)
O_bfs.Properties.VariableNames(1:size(O_bfs,2)) = variables