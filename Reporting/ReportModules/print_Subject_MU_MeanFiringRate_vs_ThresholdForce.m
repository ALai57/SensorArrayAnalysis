
function print_Subject_MU_MeanFiringRate_vs_ThresholdForce(selection,subjData,options)
    
    % Calculate MU Onset
    [MU_Onset, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
    
    % Calculate MU Mean firing rate
    [MU_MeanFiringRate, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(2));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Merge data
    subjData          = append_FileID_Tag(subjData,options);
    MU_Onset          = append_FileID_Tag(MU_Onset,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    
    if isequal(subjData.FileID_Tag,MU_Onset.FileID_Tag,MU_MeanFiringRate.FileID_Tag)
    	subjData = [subjData, MU_Onset(:,[4,5]),MU_MeanFiringRate(:,4)];
    end
    
    %Plot
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(subjData, options)
    SID = subjData.SID(1);
    
    %Finish
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'TargetForce'};
    PlotOptions.ColorBy         = {'TargetForce'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'MU Onset Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MeanFiringRate'};
    PlotOptions.YLabel          = 'Mean Firing Rate (pps)';
    PlotOptions.YLim            = [0 40];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_PctMVC()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'ArrayNumber'};
    PlotOptions.ColorBy         = {'TargetForce'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_MVC'};
    PlotOptions.XLabel          = 'TargetForce (%MVC)';
    PlotOptions.XLim            = [0 100];
    PlotOptions.YVar            = {'nMU'};
    PlotOptions.YLabel          = 'Number of Motor Units';
    PlotOptions.YLim            = [0 60];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end





