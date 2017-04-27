
function print_Subject_MU_Amplitude_Statistics(selection,MU_Data,options)
    
    % Calculate MU Amplitude
    [MU_PtP_Amp, ~] = loop_Over_Trials_FromTable(MU_Data,options.Analysis(1));
    MU_PtP_Amp.MU_Amplitude  = cell2mat(MU_PtP_Amp.MU_Amplitude);
    MU_PtP_Amp.MU_Amplitude  = 1000*MU_PtP_Amp.MU_Amplitude;
    
    % Merge tables
    MU_Data           = append_FileID_Tag(MU_Data,options);
    MU_PtP_Amp        = append_FileID_Tag(MU_PtP_Amp,options);
    
    if isequal(MU_Data.FileID_Tag,MU_PtP_Amp.FileID_Tag)
    	MU_Data = [MU_Data, MU_PtP_Amp(:,4)];
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
    
    MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce_N'});
    
    options.Plot = get_Plot_Options_HistogramMedian_AbsoluteUnits();
    create_Figure_FromTable(MU_Median, options);  
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
    PlotOptions.XVar            = {'MU_Amplitude'};
    PlotOptions.XLabel          = 'MU Amplitude (mV)';
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
    PlotOptions.YVar            = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Box.Units       = 'RelativeToMax';
    PlotOptions.Box.Width       = 0.03;
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end

 
function PlotOptions = get_Plot_Options_HistogramMedian_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'SID'}; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [1,0,0;0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1351    0.8247    0.1750    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'median_MU_Amplitude'};
    PlotOptions.YLabel          = 'Median MU Amplitude (mV)';
    PlotOptions.YLim            = [0 0.1];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end

%     MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'TargetForce','TargetForce_N'});  
%     figure; 
%     [n0,x0] = hist(MU_Data.MU_Amplitude);
%     bar(x0,n0); hold on;
%     plot(x0,n0,'-o')
%    