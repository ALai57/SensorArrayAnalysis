
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
    
    figure; hold on;
    arrayLoc = unique(decompData.ArrayLocation);
    for n=1:length(arrayLoc)
        ind = decompData.ArrayLocation == arrayLoc(n);
        plot(decompData.TargetForce_N(ind),decompData.nMU(ind),'o');
        xlabel('Force (N)'); ylabel('Number of MUs');
    end
    ind = decompData.TargetForce == '100%MVC';
    MVC = decompData.TargetForce_N(ind(1));
    ylim([0 60])
    yL = get(gca,'ylim');
    xL = get(gca,'xlim');
    xlim([0 xL(2)]);
    plot([MVC, MVC],yL,'k','linewidth',4);
    legend([char(arrayLoc(1)) ' Array'],[char(arrayLoc(2)) ' Array'],'MVC')
    title('Number of Decomposed MUs vs. Target Force')
    % Plot.
%     print_TableToWord(selection,tbl_Out);
    selection.TypeText(['Array = Sensor Array. SD = Single Differential. ' char(13)]); 
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
