
function print_All_SensorArray_SNR_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate Sensor Array SNR
    calc_SA_SNR_Fcn = @(trial_Data,options)calculate_SensorArray_SNR_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SensorArrayFullFile_2Array(allData,baseDir);
    [SNR, ~] = apply_To_Trials_In_DataTable(allData,...
                                            calc_SA_SNR_Fcn,...
                                            options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SNR         = rename_StructFields(SNR,varNames);
    allData      = merge_Data(allData,SNR,options);
    SNR         = reduce_RedundantData(allData,varNames);    
    SNR.AllData = SNR{:,end-1:end};
    SNR_NoMVC   = SNR(~(SNR.TargetForce=='100%MVC'),:);
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    
    SDs = {'MedialArray_SNR','LateralArray_SNR'};
    for n=1:2
        compare_Histograms(options,SNR_NoMVC,SDs(n),selection)
        compare_Regressions(options,SNR_NoMVC,SDs(n),selection)
    end
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
  
end

function compare_Histograms(options,SNR_NoMVC,SAs,selection)
    
    % Create histogram
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits(SAs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoDistributionsStatistics(SNR_NoMVC,options);
    set(gcf,'position',[403   315   449   351])
    xlabel('\Delta Sensor Array SNR')
    title({['All subjects: \Delta Sensor Array ' SAs{1} ' SNR'],'(Unaff-Aff) Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
     % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - Sensor Array ' SAs{1} ' SNR comparison.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
    
end

function compare_Regressions(options,SNR_NoMVC,SAs,selection)

    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SAs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SNR_NoMVC,options);
    set(gcf,'position',[403   315   449   351])
    xlabel('\Delta Regression slope (SNR/Force)')
    title({['All subjects: Difference in Regression Slopes '  SAs{1}],...
           'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut = formatStruct_tTest(stats);
    statOut{:,3:5} = statOut{:,3:5};
    selection.TypeText(['Statistics - regressions NOT including MVC. bs multiplied by 1000' char(13)]) 
    print_TableToWord(selection,statOut) 
    selection.InsertBreak;
end

function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits(SAs)

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
    PlotOptions.Response        = SAs;
    PlotOptions.YLabel          = ['SNR (Sensor Array ' SAs{1} ')'];
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_CombinedHistogram_AbsoluteUnits(SAs)

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.CompareBy       = {'ArmType'};
    PlotOptions.Colors          = {'r','b'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = SAs;
    PlotOptions.XLabel          = ['SNR (Sensor Array ' SAs{1} ' )'];
    PlotOptions.XLim            = [];
    PlotOptions.YLabel          = 'Trials';
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



    
%     % Create histogram
%     options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoDistributionsStatistics(SNR_NoMVC,options);
%     xlabel('\Delta Sensor Array SNR')
%     title({'All subjects: \Delta Sensor Array SNR','(Unaff-Aff) Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta')
%     close(gcf);
%     
%      % Print statistics
%     statOut  = formatStruct_tTest(stats);
%     selection.TypeText(['Statistics - Sensor Array SNR comparison.' char(13)])  
%     print_TableToWord(selection,statOut)
%     selection.InsertBreak;
%     
%     
%     % Create plot - with MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SNR,options);
%     xlabel('\Delta Regression slope (SNR/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            '(Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta');
%     close(gcf);  
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5};
%     selection.TypeText(['Statistics - regressions including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;
%    
%     % Create plot - without MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SNR_NoMVC,options);
%     xlabel('\Delta Regression slope (SNR/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta');
%     close(gcf);  
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5};
%     selection.TypeText(['Statistics - regressions NOT including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;
