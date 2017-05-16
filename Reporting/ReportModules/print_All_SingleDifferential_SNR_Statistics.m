
function print_All_SingleDifferential_SNR_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [SNR, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SNR       = rename_StructFields(SNR,varNames);
    allData   = merge_Data(allData,SNR,options);
    SNR       = reduce_RedundantData(allData,varNames);
    SNR_NoMVC = SNR(~(SNR.TargetForce=='100%MVC'),:);

    % Create plot - with MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SNR,options);
    xlabel('\Delta Regression slope (SNR/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut = formatStruct_tTest(stats);
    statOut{:,3:5} = statOut{:,3:5};
    selection.TypeText(['Statistics - regressions including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
    print_TableToWord(selection,statOut) 
    selection.InsertBreak;
   
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SNR_NoMVC,options);
    xlabel('\Delta Regression slope (SNR/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut = formatStruct_tTest(stats);
    statOut{:,3:5} = statOut{:,3:5};
    selection.TypeText(['Statistics - regressions NOT including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
    print_TableToWord(selection,statOut) 
    selection.InsertBreak;
   
end


function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.CompareBy       = {'ArmType'};
%     PlotOptions.ColorBy         = {'ArmType'};
%     PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.Predictor       = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'BICM_SNR', 'BICL_SNR','TRI_SNR','BRD_SNR','BRA_SNR'};
    PlotOptions.YLabel          = 'SNR (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
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

