Cost = [2 7 4;3 3 1;5 5 4;1 6 2];

A = [5 8 7 14]; % avail
B = [7 9 18]; %demand

if sum(A)==sum(B)
    fprintf('Balanced Good to go :)\n');
else
    if sum(A)<sum(B)
        Cost(end+1,:) = zeros(1,size(A,2)); % Add dummy row
        A(end+1) = sum(B) - sum(A);
    elseif sum(A)>sum(B) % Add dummy col
        Cost(:,end+1) = zeros(1,size(A,1));
        B(end+1) = sum(A)-sum(B);
    end
    fprintf('\nBalanced :} good to go\n');
end





Cost_c = Cost;
x = zeros(size(Cost)); %Allocation
[m,n] = size(Cost);

for i=1:size(Cost,1)
    for j=1:size(Cost,2)
        hh = min(Cost);
        [row,col] = find(hh==Cost);
        
        xx = min(A(row),B(col));
        [ val,ind] = max(xx);
        ii = row(ind);
        jj = col(ind);
        y11 = min(A(ii),B(jj));
        x(ii,jj) = y11;
        A(ii) = A(ii) - y11;
        B(jj) = B(jj) - y11;
        Cost(ii,jj) = Inf;
    end
end


Initial_Cost = sum(sum(Cost_c.*x));
fprintf('BFS Cost = %d\n',Initial_Cost);