
% load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_3_30_2017');
% ind = MU_Data.SID == 'JC';
% subjData = MU_Data(ind,:);

function print_Subject_NumberOfMUsDecomposed(selection,subjData)
    
    nArrays = 2;
    
    decompData = [];
    
    % For each trial
    trials     = unique(subjData.TrialName);  
    for n=1:length(trials)
        trialData = get_TrialData(subjData,trials(n));
        
        for a=1:nArrays
            arrayData = get_ArrayData(trialData,a);
            
            tmp = arrayData(1,[1:12,18,19]);
            
            if size(arrayData,1)==1 && isnan(arrayData.MU)
                tmp.nMU = 0;
            else
                tmp.nMU = size(arrayData,1); 
            end
            
            decompData = [decompData;tmp];
        end
    end
    
     % Plot. 
     % Insert breaks
    
    figure; hold on;
    arrayLoc = unique(decompData.ArrayLocation);
    for n=1:length(arrayLoc)
        ind = decompData.ArrayLocation == arrayLoc(n);
        plot(decompData.TargetForce_N(ind),decompData.nMU(ind),'o','linewidth',2);
        
    end
    ind = decompData.TargetForce == '100%MVC';
    ind = find(ind);
    MVC = decompData.TargetForce_N(ind(1));
    ylim([0 60])
    yL = get(gca,'ylim');
    xL = get(gca,'xlim');
    xlim([0 xL(2)]);
    plot([MVC, MVC],yL,'k','linewidth',4);
    hL = legend([char(arrayLoc(1)) ' Array'],[char(arrayLoc(2)) ' Array'],'MVC');
    set(hL,'position',[0.1450    0.7492    0.2661    0.1690])
    legend boxoff
    set(gca,'fontsize',12)
    SID = char(subjData.SID(1));
    xlabel('Steady Force (N)'); ylabel('Number of MUs');
    title(['Subject: ' SID],'fontsize',16);
    
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    selection.InsertBreak;
end

function trialData = get_TrialData(subjData,trialName)
    ind       = subjData.TrialName == trialName;      
    trialData = subjData(ind,:);
end

function arrayData = get_ArrayData(trialData,array)
    ind       = trialData.ArrayNumber == categorical(array);      
    arrayData = trialData(ind,:);
end



% figure; 
% arrayLoc = unique(decompData.ArrayLocation);
% for n=1:length(arrayLoc)
%     ind = decompData.ArrayLocation == arrayLoc(n);
%     subplot(2,1,1); hold on;
%     plot(decompData.TargetForce_MVC(ind),decompData.nMU(ind),'o');
%     xlabel('Force (%MVC)'); ylabel('Number of MUs');
%     subplot(2,1,2); hold on;
%     plot(decompData.TargetForce_N(ind),decompData.nMU(ind),'o');
%     xlabel('Force (N)'); ylabel('Number of MUs');
% end
