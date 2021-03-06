
function print_All_MU_Amplitude_vs_MeanFiringRate(selection,subjData,options)
    
    % Calculate MU Onset
    [MU_MeanFiringRate, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Calculate MU Amplitude
    [MU_PtP, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(2));
    MU_PtP.MU_Amplitude  = cell2mat(MU_PtP.MU_Amplitude);
    MU_PtP.MU_Amplitude  = 1000*MU_PtP.MU_Amplitude;
    
    % Merge tables
    subjData          = append_FileID_Tag(subjData,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    MU_PtP            = append_FileID_Tag(MU_PtP,options);
    
    if isequal(subjData.FileID_Tag,MU_MeanFiringRate.FileID_Tag,MU_PtP.FileID_Tag)
    	subjData = [subjData, MU_MeanFiringRate(:,4),MU_PtP(:,4)];
    end
    
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(subjData,options);
    xlabel('\Delta Regression slope (MU Amplitude/Mean FR)')
    title({'All subjects: Difference in Regression Slopes',...
           'NoMVC trials. (Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut = formatStruct_tTest(stats);
    selection.TypeText(['Statistics. ' char(13)]) 
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
    PlotOptions.Predictor       = {'MeanFiringRate'};
    PlotOptions.XLabel          = 'Firing rate (pps)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
