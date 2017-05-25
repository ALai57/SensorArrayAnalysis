

% MVC Plots

xlab = {'MVC_Force','MVC_Medial_Array','MVC_Lateral_Array','MVC_BICM','MVC_BICL','MVC_BRD'};

colNames = Ratio.Properties.VariableNames;
for n=1:length(xlab)
   c_ind(n) = find(strcmp(colNames,xlab(n)));
end

[~,ind]  = sort(Ratio.MVC_Force);
SID_Sort = SID(ind);

R      = Ratio(:,c_ind);
D      = Difference(:,c_ind);
A      = AFF(:,c_ind);
U      = UNAFF(:,c_ind);

R_Sort = R{ind,:};
D_Sort = D{ind,:};
A_Sort = A{ind,:};
U_Sort = U{ind,:};


% RATIO
figure;
custom_heatmap((R_Sort-1)*100, xlab, SID_Sort, '%2.0f%%', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',-100,'MaxColorValue',100);
title('Ratios at MVC')
    
% AFF
figure;
O = nan(size(A_Sort));
O(:,2:end)=1000;
custom_heatmap(A_Sort.*O, xlab, SID_Sort, '%2.0fe-3', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[1 1 1],'MinColorValue',0,'MaxColorValue',100);
title('AFF at MVC')

% UNAFF
figure;
custom_heatmap(U_Sort.*O, xlab, SID_Sort, '%2.0fe-3', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[1 1 1],'MinColorValue',0,'MaxColorValue',100);
title('UNAFF at MVC')

% DIFFERENCE
figure;
custom_heatmap(D_Sort, xlab, SID_Sort, '%2.0f', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',-100,'MaxColorValue',100);
title('\Delta at MVC')

% MVC FORCES
F = [A_Sort(:,1), U_Sort(:,1), D_Sort(:,1), R_Sort(:,1)];

%STATS 
ind_t = [1:5];
mean((R_Sort(ind_t,[4,5])-1)*100)
std( (R_Sort(ind_t,[4,5])-1)*100)/sqrt(5)

t = R_Sort(ind_t,[4,5])-1;
mean(t(:)*100)
std( t(:)*100)/sqrt(10)


ind_t = [6:10];
mean((R_Sort(ind_t,[4,5])-1)*100)
std( (R_Sort(ind_t,[4,5])-1)*100)/sqrt(5)

t = R_Sort(ind_t,[4,5])-1;
mean(t(:)*100)
std( t(:)*100)/sqrt(10)


% Scatter matrix
figure; plotmatrix(R_Sort)