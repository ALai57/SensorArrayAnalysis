
function print_All_MU_FiringRate_Statistics(selection,allData,options)
      
    % Calculate MU Mean firing rate
    [MU_MeanFiringRate, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Merge data
    allData          = append_FileID_Tag(allData,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    
    if isequal(allData.FileID_Tag,MU_MeanFiringRate.FileID_Tag)
    	allData = [allData,MU_MeanFiringRate(:,4)];
    end
    
     %Plot
	subjs = unique(allData.SID);
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits();
    options.Plot.Axis = axes();
    create_ComparisonOfTwoDistributionsStatistics(allData,options)
    xlabel('\Delta Firing rate (pps)')
    title({'All subjects: Difference in MU firing rate (Unaff-Aff)','Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
   
end



function PlotOptions = get_Plot_Options_CombinedHistogram_AbsoluteUnits()

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
    PlotOptions.XVar            = {'MeanFiringRate'};
    PlotOptions.XLabel          = 'Mean Firing Rate (pps)';
    PlotOptions.XLim            = [0 40];
    PlotOptions.YLabel          = 'MUs';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end