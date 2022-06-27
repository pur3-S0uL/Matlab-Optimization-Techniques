%% Input
%Cost = [2 7 4;3 3 1;5 5 4;1 6 2];
Cost = [2 10 4 5;6 12 8 11;3 9 5 7];
%A = [5 8 7 14];
A = [12 25 20];
%B = [7 9 18];
B = [25 10 15 5];
%% Check Balanced/UnBalanced
if sum(A)==sum(B)
    fprintf('Balanced Good to go :)\n');
else
    fprintf('UnBalanced\n Trying to Balance the problem ...\n');
    if sum(A)<sum(B)
        %% Adding Dummy Row
        Cost(end+1,:) = zeros(1,size(A,2));
        A(end+1) = sum(B) - sum(A);
    elseif sum(A)>sum(B)
        %% Adding Dummy Column
            Cost(:,end+1) = zeros(1,size(A,1));
            B(end+1) = sum(A)-sum(B);
    end
    fprintf('\nBalanced :} good to go\n');
end


%% Driver Code
Cost_c = Cost;
x = zeros(size(Cost)); %Allocation
[m,n] = size(Cost);

BFS = m+n-1;

%% Finding Minimum Cost Cell
for i=1:size(Cost,1)
    for j=1:size(Cost,2)
        hh = min(Cost(:)); %Cost(:) ==> Converts matrix into Column
        [row,col] = find(hh==Cost); % ==> find the Co-ordinates of Costs having minium Cost

        x11 = min(A(row),B(col));
        [ val,ind] = max(x11); % find Max Allocation
        ii = row(ind);
        jj = col(ind);
        y11 = min(A(ii),B(jj));
        x(ii,jj) = y11;
        A(ii) = A(ii) - y11;
        B(jj) = B(jj) - y11;
        Cost(ii,jj) = Inf;
    end
end

% fprintf('Initial BFS = \n');
% IB = array2table(x);
% disp(IB);

%% Check for Deg & Non-Deg
Total_BFS = length(nonzeros(x));
if Total_BFS == BFS
    fprintf('Non-Deg\n');
else
    fprintf('Deg\n');
end

%% Compute initial TP
Initial_Cost = sum(sum(Cost_c.*x));
fprintf('BFS Cost = %d\n',Initial_Cost);