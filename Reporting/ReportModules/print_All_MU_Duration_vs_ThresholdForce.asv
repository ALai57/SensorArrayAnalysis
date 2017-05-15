

function print_All_MU_Duration_vs_ThresholdForce(selection,subjData,options)
    
    % Calculate MU Onset
    [MU_Onset, ~]             = loop_Over_Trials_FromTable(subjData,options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
    
    % Calculate MU Duration
    [MU_PtP, ~]        = loop_Over_Trials_FromTable(subjData,options.Analysis(2));
    MU_PtP.MU_Duration = cell2mat(MU_PtP.MU_Duration);
    MU_PtP.MU_Duration = 1000*MU_PtP.MU_Duration;
    
    % Merge tables
    subjData      = append_FileID_Tag(subjData,options);
    MU_Onset      = append_FileID_Tag(MU_Onset,options);
    MU_PtP        = append_FileID_Tag(MU_PtP,options);
    
    if isequal(subjData.FileID_Tag,MU_Onset.FileID_Tag,MU_PtP.FileID_Tag)
    	subjData = [subjData, MU_Onset(:,[4,5]),MU_PtP(:,5)];
    end
    
    % Create plot
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(subjData,options);
    xlabel('\Delta Regression slope (MU Duration/Recruitment Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,'All Subjects','WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics MU duration vs. Recruitment Force Regressions.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
end

function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.CompareBy       = {'ArmType'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.Predictor       = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'Recruitment Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'MU_Duration'};
    PlotOptions.YLabel          = 'MU Duration (ms)';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
