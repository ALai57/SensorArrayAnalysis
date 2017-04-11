
function print_Subject_STA_Window_PtP_Amplitude(selection,subjData,options)
    
   
    % Get subject data 9 by x
    PtP_data  = [];
    PtP_CV    = [];
    for n=1:size(subjData,1)
        PtP_data = [PtP_data; subjData.PtP_Amplitude{n}];
        PtP_CV   = [PtP_CV  ; subjData.PtP_Amplitude_CV(n,:)];
    end
    
    clear n0 x0
    edges = [-1e-6:1e-6:3e-4]+1e-6;
    for c = 1:9
        [n0(c,:), x0(c,:)] = hist(PtP_data(:,c),edges);
    end    

    figure; subplot(2,1,1)
    hM = custom_heatmap(n0(:,2:end-1),edges(:,2:end-1)*1000,1:9);
    xlabel('MU amplitude (mV)');
    ylabel('Time Epoch')
    SID = char(subjData.SID(1));
    title({['Subject = ' SID '. All Motor units'], 'Distribution of Peak to Peak Amplitudes over time (from STA)'})
    
    subplot(2,1,2)
    PtP_CV(PtP_CV == -1) = [];
    [n0, x0] = hist(PtP_CV(:));
    bar(x0,n0/sum(n0),1);
    xlabel('Coefficient of Variation')
    ylabel('Proportion of units')
    title('Distribution of Peak to Peak variation over time (CV)')
    set(gcf,'position',[1053         395         560         619]);
    
    
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
    
end


%     figure; hold on;
%     for n=1:size(subjData,1)
%         try
%             plot(subjData.PtP_Amplitude{n}'-subjData.PtP_Amplitude{n}(:,1)','-o');
%         catch
%         end
%     end
%     

