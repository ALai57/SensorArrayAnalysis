

function print_Subject_MU_ThresholdForce_Statistics(selection,allData,options)
      
    % Calculate MU Onset
    [MU_Onset, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
     
    % Merge data
    allData           = append_FileID_Tag(allData,options);
    MU_Onset          = append_FileID_Tag(MU_Onset,options);
    if isequal(allData.FileID_Tag,MU_Onset.FileID_Tag)
    	allData = [allData,MU_Onset(:,[4,5])];
    end
    
    SID = allData.SID(1); 
    
    %Plot
    options.Plot = get_Plot_Options_Histogram_AbsoluteUnits();
    create_Histogram_FromTable(allData, options);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_BoxPlot_FromTable(allData, options);  
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
%     MU_Median = varfun(@median,allData,'InputVariables','MU_Onset_Force_N','GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce_N'});
%     
%     options.Plot = get_Plot_Options_HistogramMedian_AbsoluteUnits();
%     create_Figure_FromTable(MU_Median, options);  
%     print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
%     close(gcf);
    
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
    PlotOptions.XVar            = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'MU Recruitment Force (N)';
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
    PlotOptions.YVar            = {'MU_Onset_Force_N'};
    PlotOptions.YLabel          = 'MU Recruitment Force (N)';
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
    PlotOptions.YVar            = {'median_MU_Onset_Force_N'};
    PlotOptions.YLabel          = 'Median MU RecruitmentForce (N)';
    PlotOptions.YLim            = [0 0.1];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end