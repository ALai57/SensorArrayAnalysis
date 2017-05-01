
function print_Subject_SensorArray_SEMG_Statistics(selection,allData,options)
   
    allData = append_SensorArrayFullFile_2Array(allData,options.SensorArray.BaseDirectory);
    allData = append_SingleDifferentialFullFile_2Array(allData,options.SingleDifferential.BaseDirectory);
    
    % Calculate MU Mean firing rate
    [SEMG, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    for n=1:length(options.Analysis(1).Trial.OutputVariable) 
        name = options.Analysis(1).Trial.OutputVariable{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
    
    % Merge data
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);
    
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
    	allData = [allData,SEMG(:,[4,5])];
    end
    
    varNames = options.Analysis(1).Trial.OutputVariable;
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce_N'});
    SEMG.Properties.VariableNames(end-1:end) = varNames;
    SEMG.AllData = SEMG{:,end-1:end};
    
     %Plot
    SID = char(SEMG.SID(1));
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(SEMG,options)
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
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'AllData'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end