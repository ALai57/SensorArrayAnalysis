
function print_Subject_MU_Duration_Statistics(selection,MU_Data,options)
    
    % Function to calculate MU Duration
    calc_MU_Dur_Fcn = @(trial_Data,options)calculate_STA_AmplitudeAndDuration(trial_Data,options);

    % Calculate MU Amplitude
    [MU_PtP, ~] = apply_To_Trials_In_DataTable(MU_Data,...
                                               calc_MU_Dur_Fcn,...
                                               options.Analysis(1));
    MU_PtP.MU_Duration  = cell2mat(MU_PtP.MU_Duration);
    MU_PtP.MU_Duration  = 1000*MU_PtP.MU_Duration;
    
    % Merge tables
    MU_Data  = append_FileID_Tag(MU_Data,options);
    MU_PtP   = append_FileID_Tag(MU_PtP,options);
    
    if isequal(MU_Data.FileID_Tag,MU_PtP.FileID_Tag)
    	MU_Data = [MU_Data, MU_PtP(:,5)];
    end
    
    SID = MU_Data.SID(1); 
    
    %Plot
    options.Plot = get_Plot_Options_Histogram_AbsoluteUnits();
    create_Histogram_FromTable(MU_Data, options);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_BoxPlot_FromTable(MU_Data, options);  
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
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
    PlotOptions.XVar            = {'MU_Duration'};
    PlotOptions.XLabel          = 'MU Duration (ms)';
    PlotOptions.XLim            = [];
    PlotOptions.YLabel          = 'Number of units';
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
    PlotOptions.YVar            = {'MU_Duration'};
    PlotOptions.YLabel          = 'MU Duration (ms)';
    PlotOptions.YLim            = [];
    PlotOptions.Box.Units       = 'RelativeToMax';
    PlotOptions.Box.Width       = 0.03;
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end

 