

function print_Subject_SingleDifferential_SEMG_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Calculate Single Differential EMG signal
    calc_SD_EMG_Fcn = @(trial_Data,options)calculate_SingleDifferential_SEMG_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [SEMG, ~] = apply_To_Trials_In_DataTable(allData,...
                                             calc_SD_EMG_Fcn,...
                                             options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG       = rename_StructFields(SEMG,varNames);
    allData    = merge_Data(allData,SEMG,options);
    SEMG       = reduce_RedundantData(allData,varNames);
    SEMG_NoMVC = SEMG(~(SEMG.TargetForce=='100%MVC'),:);

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
    PlotOptions.YLabel          = 'RMS EMG (Single Differential)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


 function SEMG = rename_StructFields(SEMG,varNames)
    for n=1:length(varNames) 
        name = varNames{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
 end

function allData = merge_Data(allData,SEMG,options)
    % Merge data
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);

    
    varNames = options.Analysis(1).Trial.OutputVariable;
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
        allData = [allData,SEMG(:,3+[1:length(varNames)])];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-4:end) = varNames;
end

 
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