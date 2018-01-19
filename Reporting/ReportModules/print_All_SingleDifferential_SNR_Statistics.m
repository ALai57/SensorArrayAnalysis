
function print_All_SingleDifferential_SNR_Statistics(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate Single differential SNR
    calc_SD_SNR_Fcn = @(trial_Data,options)calculate_SingleDifferential_SNR_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [SNR, ~] = apply_To_Trials_In_DataTable(allData,...
                                            calc_SD_SNR_Fcn,...
                                            options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SNR       = rename_StructFields(SNR,varNames);
    allData   = merge_Data(allData,SNR,options);
    SNR       = reduce_RedundantData(allData,varNames);
    SNR_NoMVC = SNR(~(SNR.TargetForce=='100%MVC'),:);

    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    
    SDs = {'BICM_SNR','BICL_SNR','BRD_SNR'};
    for n=1:3
        compare_Distributions(options,SNR_NoMVC,SDs(n),selection)
    end
    selection.InsertBreak;
    for n=1:3
        compare_Regressions(options,SNR_NoMVC,SDs(n),selection)
    end
    
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
end

function  compare_Distributions(options,SNR_NoMVC,SDs,selection)
    % Create histogram
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits(SDs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoDistributionsStatistics(SNR_NoMVC,options);
    set(gcf,'position',[403   315   449   351])
    xlabel(['\Delta ' SDs{1} ' Single Differential SNR'],'interpreter','none')
    title({['All subjects: \Delta ' SDs{1} '  Single Differential SNR'],'(Unaff-Aff) Mean and 95% CI'},...
        'interpreter','none')
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);

     % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - ' SDs{1} '  Single differential SNR comparison.' char(13)])  
    print_TableToWord(selection,statOut)
end

function compare_Regressions(options,SNR,SDs,selection)
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SDs);
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(SNR,options);
    set(gcf,'position',[403   315   449   351])
    xlabel('\Delta Regression slope (SNR/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  

    % Print statistics
    statOut = formatStruct_tTest(stats);
    statOut{:,3:5} = statOut{:,3:5};
    selection.TypeText(['Statistics -  ' SDs{1} ' regressions including MVC. bs multiplied by 1000' char(13)]) 
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
    PlotOptions.YLabel          = ['SNR (Single Diff ' SD_Sensor{1} ')'];
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_CombinedHistogram_AbsoluteUnits(SD_Sensor)

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
    PlotOptions.XVar            = SD_Sensor;
    PlotOptions.XLabel          = ['SNR (Single Diff ' SD_Sensor{1} ')'];
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




%         % Create histogram
%         options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits(SDs(n));
%         options.Plot.Axis = axes();
%         [stats] = create_ComparisonOfTwoDistributionsStatistics(SNR_NoMVC,options);
%         xlabel(['\Delta ' SDs{1} ' Single Differential SNR'])
%         title({['All subjects: \Delta ' SDs{1} '  Single Differential SNR'],'(Unaff-Aff) Mean and 95% CI'})
%         print_FigureToWord(selection,['All Subjects'],'WithMeta')
%         close(gcf);
% 
%          % Print statistics
%         statOut  = formatStruct_tTest(stats);
%         selection.TypeText(['Statistics - ' SDs{1} '  Single differential SNR comparison.' char(13)])  
%         print_TableToWord(selection,statOut)
%         selection.InsertBreak;

        % Create plot - with MVC in regression%         
%         options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SDs(n));
%         options.Plot.Axis = axes();
%         [stats] = create_ComparisonOfTwoRegressions(SNR,options);
%         xlabel('\Delta Regression slope (SNR/Force)')
%         title({'All subjects: Difference in Regression Slopes',...
%                '(Unaff-Aff). Mean and 95% CI'})
%         print_FigureToWord(selection,['All Subjects'],'WithMeta');
%         close(gcf);  
% 
%         % Print statistics
%         statOut = formatStruct_tTest(stats);
%         statOut{:,3:5} = statOut{:,3:5};
%         selection.TypeText(['Statistics -  ' SDs{1} ' regressions including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%         print_TableToWord(selection,statOut) 
%         selection.InsertBreak;

%         % Create plot - without MVC in regression
%         options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits(SDs(n));
%         options.Plot.Axis = axes();
%         [stats] = create_ComparisonOfTwoRegressions(SNR_NoMVC,options);
%         xlabel(['\Delta  ' SDs{1} ' Regression slope (SNR/Force)'])
%         title({'All subjects: Difference in Regression Slopes',...
%                'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
%         print_FigureToWord(selection,['All Subjects'],'WithMeta');
%         close(gcf);  
% 
%         % Print statistics
%         statOut = formatStruct_tTest(stats);
%         statOut{:,3:5} = statOut{:,3:5};
%         selection.TypeText(['Statistics -  ' SDs{1} ' regressions NOT including MVC.' char(13) 'bs multiplied by 1000' char(13)]) 
%         print_TableToWord(selection,statOut) 
%         selection.InsertBreak;