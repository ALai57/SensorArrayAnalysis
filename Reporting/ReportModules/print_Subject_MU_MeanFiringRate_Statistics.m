
function print_Subject_MU_MeanFiringRate_Statistics(selection,subjData,options)
      
    % Function to calculate MU Mean Firing Rate
    calc_MU_MFR_Fcn = @(trial_Data,options)calculate_MU_MeanFiringRate_FromTrial(trial_Data,options);

    % Calculate MU Mean firing rate
    [MU_MeanFiringRate, ~] = apply_To_Trials_In_DataTable(subjData, ...
                                                          calc_MU_MFR_Fcn, ...
                                                          options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Merge data
    subjData          = append_FileID_Tag(subjData,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    
    if isequal(subjData.FileID_Tag,MU_MeanFiringRate.FileID_Tag)
    	subjData = [subjData,MU_MeanFiringRate(:,4)];
    end
    
    
    SID = subjData.SID(1); 
    
     %Plot
    options.Plot = get_Plot_Options_Histogram_AbsoluteUnits();
    create_Histogram_FromTable(subjData, options);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_BoxPlot_FromTable(subjData, options);  
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SidewaysHistogram_AbsoluteUnits();
    create_SidewaysHistogram_FromTable(subjData, options);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits();
    create_HistogramComparison_FromTable(subjData, options);
    print_FigureToWord(selection,['Subject = ' SID char(13) '. Bottom plot is Mean with 95% CI'],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
   
end


function PlotOptions = get_Plot_Options_Histogram_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'TargetForce'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.6628    0.4147    0.2661    0.2869];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'MeanFiringRate'};
    PlotOptions.XLabel          = 'Mean Firing Rate (pps)';
    PlotOptions.XLim            = [0 40];
    PlotOptions.YLabel          = 'Number of MUs with given firing rate';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_Median_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.BoxPlotBy       = {'TargetForce'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.6628    0.4147    0.2661    0.2869];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [0 1.2];
    PlotOptions.YVar            = {'MeanFiringRate'};
    PlotOptions.YLabel          = 'Mean Firing Rate (pps)';
    PlotOptions.YLim            = [0 40];
    PlotOptions.Box.Units       = 'RelativeToMax';
    PlotOptions.Box.Width       = 0.03;
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_SidewaysHistogram_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.Colors          = {'r','b'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [ 0.1333    0.8218    0.1750    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (Newtons)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MeanFiringRate'};
    PlotOptions.YLabel          = 'Firing Rate at Plateau (pps)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': Distribution of all firing rates'] ;  
    PlotOptions.TitleSize       = 16; 
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
    PlotOptions.CI.XLim         = [-5 5];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end