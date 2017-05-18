
function print_Subject_SensorArray_SNR_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information and calculate SEMG
    allData   = append_SensorArrayFullFile_2Array(allData,baseDir);
    [SNR, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SNR         = rename_StructFields(SNR,varNames);
    allData      = merge_Data(allData,SNR,options);
    SNR         = reduce_RedundantData(allData,varNames);    
    SNR.AllData = SNR{:,end-1:end};
    SNR_NoMVC   = SNR(~(SNR.TargetForce=='100%MVC'),:);
    
    %Plot
    SID = char(SNR.SID(1));
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable_MultiInputSubplot(SNR, options)
    print_FigureToWord(selection,['Subject :' SID],'WithMeta')
    close(gcf);
    
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
    PlotOptions.YVar            = {'AllData'};
    PlotOptions.YLabel          = 'SNR (Sensor Array)';
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
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);
   
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
    	allData = [allData,SEMG(:,[4,5])];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-1:end) = varNames;
end

