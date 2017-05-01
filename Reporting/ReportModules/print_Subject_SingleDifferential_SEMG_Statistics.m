
function print_Subject_SingleDifferential_SEMG_Statistics(selection,allData,options)
   
    allData  = append_SingleDifferentialFullFile_2Array(allData,options.SingleDifferential.BaseDirectory);
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Calculate MU Mean firing rate
    [SEMG, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    for n=1:length(varNames) 
        name = varNames{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
    
    % Merge data
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);
    
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
    	allData = [allData,SEMG(:,3+[1:length(varNames)])];
    end
    
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce_N'});
    SEMG.Properties.VariableNames(end-4:end) = varNames;
      
     %Plot
    SID = char(SEMG.SID(1));
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable_MultiInputSubplot(SEMG, options)
    print_FigureToWord(selection,['Subject :' SID],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
   
end



function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BICM', 'BICL','TRI','BRD','BRA'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


% 
%     SID = char(SEMG.SID(1));
%     options.Plot = get_Plot_Options_AbsoluteUnits();
%     options.Plot.YVar = {'BICM'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BICM'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BICL'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BICL'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'TRI'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' TRI'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BRD'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BRD'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BRA'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BRA'],'WithMeta')
%     close(gcf);