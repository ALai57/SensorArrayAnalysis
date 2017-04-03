 

function print_All_NumberOfMUsDecomposed(selection, allData)

    options.nArrays = 2;
    options.NewVariableNames = {'nMU'};
    options.TableVariables   = {'SID',...
                               'ArmType',...
                               'ArmSide',...
                               'Experiment',...
                               'TargetForce',...
                               'ID',...
                               'TrialName',...
                               'SensorArrayFile',...
                               'SingleDifferentialFile',...
                               'ArrayNumber',...
                               'ArrayLocation',...
                               'DecompChannels',...
                               'TargetForce_MVC',...
                               'TargetForce_N'};
    
    
    trialData{1} = @(arrayData,options)get_NumberOfMUsDecomposed(arrayData,options);
    decompData   = get_Data_FromTrial(allData,trialData,options);

    figure; hold on;
    arrayLoc = unique(decompData.ArrayLocation);
    for n=1:length(arrayLoc)
        ind = decompData.ArrayLocation == arrayLoc(n);
        plot(decompData.TargetForce_MVC(ind),decompData.nMU(ind),'o','linewidth',2);  
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
    SID = char(allData.SID(1));
    xlabel('Steady Force (%MVC)'); ylabel('Number of MUs');
    title(['All subjects'],'fontsize',16);
    
    print_FigureToWord(selection,['All Subjects' char(13)],'WithMeta')
    close(gcf);
    selection.InsertBreak;
end


%     trials = unique(allData.SensorArrayFile);  
%     
%     for n=1:length(trials)
%         trialData = get_TrialData(allData,trials(n));
%         
%         for a=1:nArrays
%             arrayData = get_ArrayData(trialData,a);
%             
%             tmp = arrayData(1,[1:12,18,19]);
%             
%             if size(arrayData,1)==1 && isnan(arrayData.MU)
%                 tmp.nMU = 0;
%             else
%                 tmp.nMU = size(arrayData,1); 
%             end
%             
%             decompData = [decompData;tmp];
%         end
%     end
    
     % Plot. 
     % Insert breaks
    