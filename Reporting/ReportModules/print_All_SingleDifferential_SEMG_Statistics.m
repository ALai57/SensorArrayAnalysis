
function print_All_SingleDifferential_SEMG_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [SEMG, ~] = apply_To_Trials_In_DataTable(allData,options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG       = rename_StructFields(SEMG,varNames);
    allData    = merge_Data(allData,SEMG,options);
    SEMG       = reduce_RedundantData(allData,varNames);
    SEMG_NoMVC = SEMG(~(SEMG.TargetForce=='100%MVC'),:);

    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    
    SDs = {'BICM','BICL','BRD'};
    for n=1:3
        compare_Regressions(options,SEMG_NoMVC,SDs(n),selection)
    end
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
    
   
end

function compare_Regressions(options,SEMG_NoMVC,SDs,selection)
   
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SDs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SEMG_NoMVC,options);
    set(gcf,'position',[403   315   449   351])
    xlabel(['\Delta Regression slope (' SDs{1} ' SD EMG/Force)'])
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

function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits(SD_Sensor)

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
    PlotOptions.Response        = SD_Sensor;
    PlotOptions.YLabel          = [SD_Sensor{1} ' RMS EMG (Sensor Arrays)'];
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


%     % Create plot - with MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SEMG,options);
%     xlabel('\Delta Regression slope (SD EMG/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            '(Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta');
%     close(gcf);  
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5}*1000;
%     selection.TypeText(['Statistics - regressions including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;



% 
%     % Create plot - without MVC in regression
%     options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
%     options.Plot.Axis = axes();
%     [stats] = create_ComparisonOfTwoRegressions(SEMG_NoMVC,options);
%     xlabel('\Delta Regression slope (SD EMG/Force)')
%     title({'All subjects: Difference in Regression Slopes',...
%            'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
%     print_FigureToWord(selection,['All Subjects'],'WithMeta');
%     close(gcf);  
%     
%     % Print statistics
%     statOut = formatStruct_tTest(stats);
%     statOut{:,3:5} = statOut{:,3:5}*1000;
%     selection.TypeText(['Statistics - regressions NOT including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%     print_TableToWord(selection,statOut) 
%     selection.InsertBreak;
   