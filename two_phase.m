%% Input Phase
variables = {'x1','x2','x3','s1','s2','A1','A2','Sol'};
OrgVar = {'x1','x2','x3','s1','s2','Sol'};

%%%% Original Cost
OrgC = [-7.5 3 0 0 0 -1 -1 0];
Info = [3 -1 -1 -1 0 1 0 3;1 -1 1 0 -1 0 1 2];
b = [3;2];

%%%% Initial Basic Variables
BV = [6 7];

%% Phase 1

%%%% Cost of Phase 1
Cost = [0 0 0 0 0 -1 -1 0];
A = Info;
StartBV = find(Cost<0);     %%%% Define Artifical Variables

%%%% Compute Zj-Cj
Zj_Cj = Cost(BV)*A -Cost;

%%%% Initial Table
Initial_table = array2table([Zj_Cj;A]);
Initial_table.Properties.VariableNames(1:size(A,2)) = variables
    

RUN = true;
while RUN
    
    ZCj = Zj_Cj(:,end-1);
    if any(ZCj<0)
        
        %%% Entering Variable
        [ent_var,ent_col] = min(ZCj);
        
        %%% Leaving Variable
        sol = Info(:,end);
        pvt_col = Info(:,ent_col);
        
        if all(pvt_col<0)
            error('Unbounded');
        else
            %%%% Finding Ratio
            for i=1:size(Info,1)
                if pvt_col(i) > 0
                    ratio(i) = sol(i)/pvt_col(i);
                else
                    ratio(i) = inf;
                end
            end
            [min_Ratio,pvt_row] = min(ratio);
        end
        BV(pvt_row) = pvt_col;
        pvt_key = Info(pvt_row,pvt_col);
        
        Info(pvt_row,:) = Info(pvt_row,:)./pvt_key;
        
        %%% Updating Info Matrix
        for i=1:size(Info,1)
            if i~=pvt_row
                Info(i,:) = Info(i,:) - Info(i,pvt_col).*Info(pvt_row,:);
            end
        end
        
        %%%% Updating Zj_Cj
        Zj_Cj = Zj_Cj - Zj_Cj(pvt_col).*Info(pvt_row,:);
    else
        fprintf('Optimal');
        RUN = false;
    end
end

%% Phase 2

A(:,StartBV) = [];
OrgC(:,StartBV) = [];

RUN = true;
Zj_Cj = Cost(BV)*A -OrgC;
while RUN
    
    ZCj = Zj_Cj(:,end-1);
    if any(ZCj<0)
        
        %%% Entering Variable
        [ent_var,ent_col] = min(ZCj);
        
        %%% Leaving Variable
        sol = Info(:,end);
        pvt_col = Info(:,ent_col);
        
        if all(pvt_col<0)
            error('Unbounded');
        else
            %%%% Finding Ratio
            for i=1:size(Info,1)
                if pvt_col(i) > 0
                    ratio(i) = sol(i)/pvt_col(i);
                else
                    ratio(i) = inf;
                end
            end
            [min_Ratio,pvt_row] = min(ratio);
        end
        BV(pvt_row) = pvt_col;
        pvt_key = Info(pvt_row,pvt_col);
        
        Info(pvt_row,:) = Info(pvt_row,:)./pvt_key;
        
        %%% Updating Info Matrix
        for i=1:size(Info,1)
            if i~=pvt_row
                Info(i,:) = Info(i,:) - Info(i,pvt_col).*Info(pvt_row,:);
            end
        end
        
        %%%% Updating Zj_Cj
        Zj_Cj = Zj_Cj - Zj_Cj(pvt_col).*Info(pvt_row,:);
    else
        fprintf('Optimal');
        RUN = false;
    end
end
    
    
    
    
    
    
    
    
    
    
    
% Zj_Cj = Cost(BV)*A -Cost;
% 
% ZCj = [Zj_Cj;A];
% Initial_Table = array2table(ZCj);
% Initial_Table.Properties.VariableNames(1:size(ZCj,2)) = variables
% 
% disp('====PHASE 1====');
% zc = Zj_Cj(:,end-1);
% RUN = false;
% while RUN
%     if any(zc < 0)
%         [Ent_var,pvt_col] = min(zc);
%         sol = A(:,end);
%         column = A(:,pvt_col);
%     
%         if all(column <=0)
%             error('Unbounded');
%         else
%             for i=1:size(column,1)
%                 if column(i)>0
%                     ratio(i) = sol(i)/column(i);
%                 else
%                     ratio(i) = inf;
%                 end
%                 [minR,pvt_row] = min(ratio);
%             end
%             BV(pvt_row) = pvt_col;
%             pvt_key = A(pvt_row,pvt_col);
%             
%             A(pvt_row,:) = A(pvt_row,:)./pvt_key;
%             for i=1:size(A,1)
%                 if i~=pvt_row
%                     A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
%                 end
%             end
%             Zj_Cj=Zj_Cj(i,:)-Zj_Cj(1,pvt_col).*A(pvt_row,:);
% 
%             B = A(:,BV);
%             A = B\A;
%             Zj_Cj = Cost(BV)*A - Cost;
%         
%             ZCj = [Zj_Cj;A];
%             SimplexTable = array2table(ZCj)
%             SimplexTable.Properties.VariableNames(1:size(ZCj,2)) = variables
%         end
%     else
%         RUN = false;
%         disp('Optimal')
%     end
% end
% 
% disp('\n====PHASE 2====\n');