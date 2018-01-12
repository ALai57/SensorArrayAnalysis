
function print_Subject_MU_Duration_vs_MeanFiringRate(selection,subjData,options)
    
    
    % Functions to calculate MU Mean Firing Rate (MFR) and Duration
    calc_MU_MFR_Fcn = @(trial_Data,options)calculate_MU_MeanFiringRate_FromTrial(trial_Data,options);
    calc_MU_Dur_Fcn = @(trial_Data,options)calculate_STA_AmplitudeAndDuration(trial_Data,options);

    % Calculate MU MFR
    [MU_MeanFiringRate, ~] = apply_To_Trials_In_DataTable(subjData,...
                                                          calc_MU_MFR_Fcn,...
                                                          options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Calculate MU Duration
    [MU_PtP, ~] = apply_To_Trials_In_DataTable(subjData,...
                                               calc_MU_Dur_Fcn,...
                                               options.Analysis(2));
    MU_PtP.MU_Duration  = cell2mat(MU_PtP.MU_Duration);
    MU_PtP.MU_Duration  = 1000*MU_PtP.MU_Duration;
    
    % Merge tables
    subjData          = append_FileID_Tag(subjData,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    MU_PtP            = append_FileID_Tag(MU_PtP,options);
    
    if isequal(subjData.FileID_Tag,MU_MeanFiringRate.FileID_Tag,MU_PtP.FileID_Tag)
    	subjData = [subjData, MU_MeanFiringRate(:,4),MU_PtP(:,5)];
    end
    
    %Plot
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(subjData, options);
    SID = subjData.SID(1);
    
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
    PlotOptions.XVar            = {'MeanFiringRate'};
    PlotOptions.XLabel          = 'MU Mean Firing Rate(pps)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MU_Duration'};
    PlotOptions.YLabel          = 'MU Duration (ms)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


