

load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\SummaryStatistics\EMG_Ratio.mat')

xlab = {'MVC Force','MVC EMG SA-Med','MVC EMG SA-Lat','MVC EMG BICM','MVC EMG BICL','MVC EMG BRD','',...
        'Medial array SNR (RMS)','Lateral array SNR (RMS)','SD BIC M SNR (RMS)','SD BIC L SNR (RMS)','SD BRD SNR (RMS)','',...
        'Mean MU Amplitude','',...
        'Mean MU Duration','',...
        'Mean MU Firing Rate','',...
        'Mean MU Recruitment Threshold'};
    
[~,ind] = sort(EMG_Ratio(:,1));

% RATIO
EMG_Ratio(EMG_Ratio==0) = NaN;
EMG_Ratio_Sort          = EMG_Ratio(ind,:);
SID_Sort                = SID(ind);

figure;
custom_heatmap((EMG_Ratio_Sort-1)*100, xlab, SID_Sort, '%2.0f', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',-100,'MaxColorValue',100);

% significance - pvalues
EMG_pval(EMG_Ratio==0)  = NaN;
EMG_pval_Sort           = EMG_pval(ind,:);
clabel                  = arrayfun(@(x){sprintf('%0.2f',x)}, EMG_pval_Sort);
signif                  = EMG_pval_Sort;
signif(signif>0.05)     = 3;       
signif(isnan(EMG_Ratio_Sort))    = NaN;

figure;
custom_heatmap(signif, xlab, [], clabel, 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',45,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',0.15);

% Scatter matrix
figure; plotmatrix(EMG_Ratio_Sort)