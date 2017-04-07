
% load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_3_30_2017');
% ind = MU_Data.SID == 'JC';
% subjData = MU_Data(ind,:);

function print_Subject_NumberOfMUsDecomposed(selection,subjData)
    
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
      
    trialData{1} = @(arrayData_tbl,options)get_NumberOfMUsDecomposed(arrayData_tbl,options);
    data         = get_Data_FromTrial(subjData,trialData,options);

    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(data, options)
    SID = data.SID(1);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_PctMVC();
    create_Figure_FromTable(data, options);
    SID = data.SID(1);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
end

function trialData = get_TrialData(subjData,trialName)
    ind       = subjData.SensorArrayFile == categorical(trialName);      
    trialData = subjData(ind,:);
end

function arrayData = get_ArrayData(trialData,array)
    ind       = trialData.ArrayNumber == categorical(array);      
    arrayData = trialData(ind,:);
end


function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'ArrayNumber'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'nMU'};
    PlotOptions.YLabel          = 'Number of Motor Units';
    PlotOptions.YLim            = [0 60];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_PctMVC()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'ArrayNumber'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_MVC'};
    PlotOptions.XLabel          = 'TargetForce (%MVC)';
    PlotOptions.XLim            = [0 100];
    PlotOptions.YVar            = {'nMU'};
    PlotOptions.YLabel          = 'Number of Motor Units';
    PlotOptions.YLim            = [0 60];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end







% 
% 
% function print_Subject_NumberOfMUsDecomposed(selection,subjData)
%     
%     nArrays = 2;
%     
%     decompData = [];
%     
%     % For each trial
%     trials = unique(subjData.SensorArrayFile);  
%     
%     for n=1:length(trials)
%         trialData = get_TrialData(subjData,trials(n));
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
%     
%      % Plot. 
%      % Insert breaks
%     
%     figure; hold on;
%     arrayLoc = unique(decompData.ArrayLocation);
%     for n=1:length(arrayLoc)
%         ind = decompData.ArrayLocation == arrayLoc(n);
%         plot(decompData.TargetForce_N(ind),decompData.nMU(ind),'o','linewidth',2);
%         
%     end
%     ind = decompData.TargetForce == '100%MVC';
%     ind = find(ind);
%     MVC = decompData.TargetForce_N(ind(1));
%     ylim([0 60])
%     yL = get(gca,'ylim');
%     xL = get(gca,'xlim');
%     xlim([0 xL(2)]);
%     plot([MVC, MVC],yL,'k','linewidth',4);
%     hL = legend([char(arrayLoc(1)) ' Array'],[char(arrayLoc(2)) ' Array'],'MVC');
%     set(hL,'position',[0.1450    0.7492    0.2661    0.1690])
%     legend boxoff
%     set(gca,'fontsize',12)
%     SID = char(subjData.SID(1));
%     xlabel('Steady Force (N)'); ylabel('Number of MUs');
%     title(['Subject: ' SID],'fontsize',16);
%     
%     print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
%     close(gcf);
%     selection.InsertBreak;
% end