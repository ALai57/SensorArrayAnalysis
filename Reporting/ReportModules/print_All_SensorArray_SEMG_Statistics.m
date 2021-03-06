
function print_All_SensorArray_SEMG_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information and calculate SEMG
    allData   = append_SensorArrayFullFile_2Array(allData,baseDir);
    [SEMG, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG         = rename_StructFields(SEMG,varNames);
    allData      = merge_Data(allData,SEMG,options);
    SEMG         = reduce_RedundantData(allData,varNames);    
    SEMG.AllData = SEMG{:,end-1:end};
    SEMG_NoMVC   = SEMG(~(SEMG.TargetForce=='100%MVC'),:);
    
    SEMG_NoMVC.Mean_Lateral = mean(SEMG_NoMVC.LateralArray_SEMG')';
    SEMG_NoMVC.Mean_Medial  = mean(SEMG_NoMVC.MedialArray_SEMG')';
    
    %Plot
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(SEMG,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    
    SDs = {'Mean_Medial','Mean_Lateral'};
    for n=1:2
        compare_Regressions(options,SEMG_NoMVC,SDs(n),selection)
    end
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
    
   
    
end

function compare_Regressions(options,SEMG_NoMVC,SAs,selection)
   
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SAs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SEMG_NoMVC,options);
    set(gcf,'position',[403   315   449   351])
    xlabel(['\Delta Regression slope (' SAs{1} ' SD EMG/Force)'])
    title({'All subjects: Difference in Regression Slopes',...
           'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    
    close(gcf);  
    
    % Print statistics
    statOut = formatStruct_tTest(stats);
    statOut{:,3:5} = statOut{:,3:5}*1000;
    selection.TypeText(['Statistics - regressions NOT including MVC. bs multiplied by 1000' char(13)]) 
    print_TableToWord(selection,statOut) 
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




function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits(SA_Sensor)

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
    PlotOptions.Response        = SA_Sensor;
    PlotOptions.YLabel          = ['RMS EMG (Sensor Array - ' SA_Sensor{1} ')'];
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
    
    varNames = options.Analysis(1).Trial.OutputVariable;
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
    	allData = [allData,SEMG(:,[4,5])];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-1:end) = varNames;
end


% 

%     
%     % Create plot - with MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SEMG,options);
%     xlabel('\Delta Regression slope (SA EMG/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            '(Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta')
%     close(gcf);   
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5}*1000;
%     selection.TypeText(['Statistics - regressions including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;
%     
%     
%     % Create plot - without MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SEMG_NoMVC,options);
%     xlabel('\Delta Regression slope (SA EMG/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta')
%     close(gcf);      
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5}*1000;
%     selection.TypeText(['Statistics - regressions NOT including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;
