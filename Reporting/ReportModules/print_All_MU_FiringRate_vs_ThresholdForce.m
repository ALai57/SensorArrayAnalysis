
function print_All_MU_FiringRate_vs_ThresholdForce(selection,allData,options)
      
    % Calculate MU Mean firing rate
    [MU_MeanFiringRate, ~]           = loop_Over_Trials_FromTable(allData,options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Calculate MU Onset
    [MU_Onset, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(2));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
     
    % Merge data
    allData           = append_FileID_Tag(allData,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    MU_Onset          = append_FileID_Tag(MU_Onset,options);
    if isequal(allData.FileID_Tag,MU_MeanFiringRate.FileID_Tag,MU_Onset.FileID_Tag)
    	allData = [allData,MU_MeanFiringRate(:,4),MU_Onset(:,[4,5])];
    end
    
    % Print statistics
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(allData,options);
    xlabel('\Delta Slope (pps/recruitment force)')
    title({'All subjects - Difference in regression slope: MU Mean firing rate vs threshold force','(Unaff-Aff): Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
     % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - Regression slope comparison.' char(13)])  
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
    PlotOptions.XLabel          = 'Recruitment Threshold (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'MeanFiringRate'};
    PlotOptions.YLabel          = 'Mean Firing rate(pps)';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end