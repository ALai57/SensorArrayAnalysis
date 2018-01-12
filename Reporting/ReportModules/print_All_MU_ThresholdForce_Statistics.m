
function print_All_MU_ThresholdForce_Statistics(selection,allData,options)
    
    % Function to calculate MU Onset
    theFcn = @(trial_Data,options)calculate_MU_Onset_FromTrial(trial_Data,options);

    % Calculate MU Onset
    [MU_Onset, ~] = apply_To_Trials_In_DataTable(allData, theFcn, options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
     
    % Merge data
    allData           = append_FileID_Tag(allData,options);
    MU_Onset          = append_FileID_Tag(MU_Onset,options);
    if isequal(allData.FileID_Tag,MU_Onset.FileID_Tag)
    	allData = [allData,MU_Onset(:,[4,5])];
    end
    
    % Median
    MU_Median = varfun(@median,allData,'InputVariables','MU_Onset_Force_N','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N'});
    MU_Median = sortrows(MU_Median,{'SID','TargetForce_N'},{'ascend','ascend'});
     
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_Figure_FromTable(MU_Median, options);  
    print_FigureToWord(selection,['All subjects' char(13)],'WithMeta')
    close(gcf);
    
    % IQR
    MU_IQR = varfun(@iqr,allData,'InputVariables','MU_Onset_Force_N','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N'});
    MU_IQR = sortrows(MU_IQR,{'SID','TargetForce_N'},{'ascend','ascend'});
       
    options.Plot = get_Plot_Options_IQR_AbsoluteUnits();
    create_Figure_FromTable(MU_IQR, options);  
    print_FigureToWord(selection,['All subjects' char(13)],'WithMeta')
    close(gcf);
    
    subjs = unique(allData.SID);
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoDistributionsStatistics(allData,options);
    xlabel('\Delta MU Recruitment Threshold (N)')
    title({'All subjects: \Delta MU Recruitment threshold','(Unaff-Aff) Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
     % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - MU Recruitment Threshold comparison.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
      
   
end


function PlotOptions = get_Plot_Options_Median_AbsoluteUnits()

    PlotOptions.SubplotBy       = {}; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1548    0.7837    0.1679    0.1012];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'median_MU_Onset_Force_N'};
    PlotOptions.YLabel          = 'Median MU Recruitment Force (N)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All subjects: '] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_IQR_AbsoluteUnits()

    PlotOptions.SubplotBy       = {}; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1548    0.7837    0.1679    0.1012];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'iqr_MU_Onset_Force_N'};
    PlotOptions.YLabel          = 'IQR MU Recruitment Force (N)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All subjects: '] ;  
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
    PlotOptions.XVar            = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'MU Recruitment Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YLabel          = 'MUs';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
