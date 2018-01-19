
function print_All_SensorArray_SEMG_Statistics_Normalized(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SensorArray.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate SEMG
    calc_SEMG_Fcn = @(trial_Data,options)calculate_SensorArray_SEMG_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SensorArrayFullFile_2Array(allData,baseDir);
    [SEMG, ~] = apply_To_Trials_In_DataTable(allData,...
                                             calc_SEMG_Fcn,...
                                             options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG         = rename_StructFields(SEMG,varNames);
    allData      = merge_Data(allData,SEMG,options);
    SEMG         = reduce_RedundantData(allData,varNames);
    Norm_SEMG    = normalize_EMG(SEMG,[5,7,8]);
    Norm_SEMG.AllData = Norm_SEMG{:,end-1:end};
    Norm_SEMG_NoMVC   = Norm_SEMG(~(Norm_SEMG.TargetForce=='100%MVC'),:);
    
    
    %Plot
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(Norm_SEMG,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    % Create plot - with MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(Norm_SEMG,options);
    xlabel('\Delta Regression slope (SA EMG/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);   
    
    % Print statistics
    statOut = reformat_Struct(stats);
    selection.TypeText(['Statistics - regressions including MVC.' char(13)]) 
    print_TableToWord(selection,cell2table(statOut)) 
    selection.InsertBreak;
    
    
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(Norm_SEMG_NoMVC,options);
    xlabel('\Delta Regression slope (SA EMG/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);      
    
    % Print statistics
    statOut = reformat_Struct(stats);
    selection.TypeText(['Statistics - regressions including MVC.' char(13)]) 
    print_TableToWord(selection,cell2table(statOut)) 
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
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
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
    PlotOptions.Response        = {'AllData'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
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

function  statOut = reformat_Struct(structIn)
    nSubjs = length(structIn);
    
    for n=1:nSubjs
       statOut{n,1} = structIn(n).SID;
       statOut{n,2} = structIn(n).fTest.p;
       statOut{n,3} = structIn(n).tTest(1).Estimate(1);
       statOut{n,4} = structIn(n).tTest(1).Estimate(2);
       statOut{n,5} = structIn(n).tTest(1).p;
       statOut{n,6} = structIn(n).tTest(1).DF;
       statOut{n,7} = structIn(n).tTest(2).p;
       statOut{n,8} = structIn(n).tTest(2).DF;
    end
    header  = {'SID','F_pVal','b1_AFF','b1_UNAFF','t_pVal','t_DF','t_pVal','t_DF'};
    statOut = [header;statOut];
end
