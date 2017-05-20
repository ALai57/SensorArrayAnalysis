
% Display - will use some weird color map to start with.
imagesc(a);
colorbar
% Create colormap that is green for negative, red for positive,
% and a chunk inthe middle that is black.
greenColorMap = [zeros(1, 132), linspace(0, 1, 124)];
redColorMap = [linspace(1, 0, 124), zeros(1, 132)];
colorMap = [redColorMap; greenColorMap; zeros(1, 256)]';
% Apply the colormap.
colormap(colorMap);



xlab = {'Force','EMG SA-Med','EMG SA-Lat','EMG BICM','EMG BICL','EMG BRD','',...
        'SA v Force (M&L)','','SD v Force (Medial)','','',...
        'SA SNR (RMS)','SA SNR vs. Force (RMS)','','','SD SNR (RMS)','SD SNR vs Force (RMS)','SD SNR (PtP)','SD SNR vs Force (PtP)','',...
        'Mean MU Amp','Amp vs Force','Amp vs. Thresh','Amp vs. FR','',...
        'Mean Duration','Duration v Force','Duration v Thresh','Duration v FR','',...
        'Mean FR','FR v Force','FR v Thresh','',...
        'Mean Thresh'};
[~,ind] = sort(a(:,1));
    
% RATIO
figure;
a(a==0) = NaN;
a_Sort  = a(ind,:);
SID_Sort = SID(ind);

custom_heatmap((a_Sort-1)*100, xlab, SID_Sort, '%2.0f', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',-200,'MaxColorValue',200);
annotation('textbox',[0 0.9 0.1 0.1],'string','Ratio - Aff/Contra')
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.42 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.57 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.68 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.76 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.85 0.9 0.1 0.1],'string','MU Recruitment')
    

% b1_p
figure;
b1_p(a==0)          = NaN;
b1_p_Sort           = b1_p(ind,:);
clabel              = arrayfun(@(x){sprintf('%0.2f',x)}, b1_p_Sort);
signif              = b1_p_Sort;
signif(signif>0.05) = 3;       
signif(a==0)        = NaN;

custom_heatmap(signif, xlab, [], clabel, 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',0.15);
annotation('textbox',[0 0.9 0.1 0.1],'string','Aff slope p-value')
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.42 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.57 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.68 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.76 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.85 0.9 0.1 0.1],'string','MU Recruitment')


% b2_p
figure;
b2_p(a==0)          = NaN;
b2_p_Sort           = b2_p(ind,:);
clabel              = arrayfun(@(x){sprintf('%0.2f',x)}, b2_p_Sort);
signif              = b2_p_Sort;
signif(signif>0.05) = 3;       
signif(a==0)        = NaN;

custom_heatmap(signif, xlab, [], clabel, 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',0.15);
annotation('textbox',[0 0.9 0.1 0.1],'string','UnAff slope p-value')
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.42 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.57 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.68 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.76 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.85 0.9 0.1 0.1],'string','MU Recruitment')


% VAF1
figure;
VAF1(a==0)          = NaN;
VAF1           = VAF1(ind,:);
clabel              = arrayfun(@(x){sprintf('%0.2f',x)}, VAF1);

custom_heatmap(VAF1, xlab, [], clabel, 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',1);
annotation('textbox',[0 0.9 0.1 0.1],'string','VAF - AFF regression')
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.42 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.57 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.68 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.76 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.85 0.9 0.1 0.1],'string','MU Recruitment')



% VAF2
figure;
VAF2(a==0)          = NaN;
VAF2           = VAF2(ind,:);
clabel              = arrayfun(@(x){sprintf('%0.2f',x)}, VAF2);

custom_heatmap(VAF2, xlab, [], clabel, 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',1);
annotation('textbox',[0 0.9 0.1 0.1],'string','VAF - UNAFF regression')
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.42 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.57 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.68 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.76 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.85 0.9 0.1 0.1],'string','MU Recruitment')





figure; plotmatrix(a_Sort)