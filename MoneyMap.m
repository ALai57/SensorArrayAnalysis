
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

a(a==0)=NaN;
[~,ind] = sort(a(:,1));
a_Sort = a(ind,:);

xlab = {'Force','EMG SA-Med','EMG SA-Lat','EMG BICM','EMG BICL','EMG BRD','','SA v Force','SD v Force','','','','','SD v Force','','Mean MU Amp','Amp vs Force','Amp vs. Thresh','Amp vs. FR','','','Mean Duration','Duration v Force','Duration v Thresh','Duration v FR','','Mean FR','FR v Force','FR v Thresh','','Thresh'};
custom_heatmap((a_Sort-1)*100, xlab, [], '%2.0f', 'Colormap', 'money', ...
        'Colorbar', false,'ShowAllTicks',1,'TickAngle',70,'UseFigureColormap',false,'NaNColor',[0 0 0],'MinColorValue',-200,'MaxColorValue',200);
annotation('textbox',[0.2 0.9 0.1 0.1],'string','MVC')
annotation('textbox',[0.3 0.9 0.1 0.1],'string','SEMG')
annotation('textbox',[0.4 0.9 0.1 0.1],'string','SNR')
annotation('textbox',[0.5 0.9 0.1 0.1],'string','MU Amp')
annotation('textbox',[0.63 0.9 0.1 0.1],'string','MU Dur')
annotation('textbox',[0.75 0.9 0.1 0.1],'string','MU FR')
annotation('textbox',[0.84 0.9 0.1 0.1],'string','MU Recruitment')
    


custom_heatmap((a-1)*100, [], [], '%2.0f', 'Colormap', 'money', ...
        'Colorbar', true);