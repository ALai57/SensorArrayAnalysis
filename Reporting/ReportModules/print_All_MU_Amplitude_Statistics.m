
function print_All_MU_Amplitude_Statistics(selection,MU_Data,options)
    
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
    
    % Median
    MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N'});
    MU_Median = sortrows(MU_Median,{'SID','TargetForce_N'},{'ascend','ascend'});
     
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_Figure_FromTable(MU_Median, options);  
    print_FigureToWord(selection,['All subjects' char(13)],'WithMeta')
    close(gcf);
    
    % IQR
    MU_IQR = varfun(@iqr,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N'});
    MU_IQR = sortrows(MU_IQR,{'SID','TargetForce_N'},{'ascend','ascend'});
       
    options.Plot = get_Plot_Options_IQR_AbsoluteUnits();
    create_Figure_FromTable(MU_IQR, options);  
    print_FigureToWord(selection,['All subjects' char(13)],'WithMeta')
    close(gcf);
    
    subjs = unique(MU_Data.SID);
    options.Plot = get_Plot_Options_CombinedHistogram_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoDistributionsStatistics(MU_Data,options);
    xlabel('\Delta MU Amplitude (mV)')
    title({'All subjects: Difference in MU Amplitudes (Unaff-Aff)','Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
     % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - MU Amplitude comparison.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
    
    
    % Create plot - without MVC in regression
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(MU_Data,options);
    xlabel('\Delta Regression slope (MU Amplitude/Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,['All Subjects'],'WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics - regressions without MVC.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
   
    
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
    PlotOptions.YVar            = {'median_MU_Amplitude'};
    PlotOptions.YLabel          = 'Median MU Amplitude (mV)';
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
    PlotOptions.YVar            = {'iqr_MU_Amplitude'};
    PlotOptions.YLabel          = 'IQR MU Amplitude (mV)';
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
    PlotOptions.XVar            = {'MU_Amplitude'};
    PlotOptions.XLabel          = 'MU Amplitude (mV)';
    PlotOptions.XLim            = [];
    PlotOptions.YLabel          = 'MUs';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
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
    PlotOptions.Predictor       = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
