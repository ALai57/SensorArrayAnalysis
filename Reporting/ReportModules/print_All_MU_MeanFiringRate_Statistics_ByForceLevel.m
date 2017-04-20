
function print_All_MU_MeanFiringRate_Statistics_ByForceLevel(selection,MU_Data,options)
    
    % Calculate MU Mean firing rate
    [MU_MeanFiringRate, ~] = loop_Over_Trials_FromTable(MU_Data,options.Analysis(1));
    MU_MeanFiringRate.MeanFiringRate = cell2mat(MU_MeanFiringRate.MeanFiringRate);
    
    % Merge data
    MU_Data          = append_FileID_Tag(MU_Data,options);
    MU_MeanFiringRate = append_FileID_Tag(MU_MeanFiringRate,options);
    
    if isequal(MU_Data.FileID_Tag,MU_MeanFiringRate.FileID_Tag)
    	MU_Data = [MU_Data,MU_MeanFiringRate(:,4)];
    end
    
    
    SID = MU_Data.SID(1); 
    
    ind = MU_Data.TargetForce == '100%MVC';
    MU_Data(ind,:) = [];
    
    % Median
    MU_Median = varfun(@median,MU_Data,'InputVariables','MeanFiringRate','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','ForceCategory'});
    MU_Median = sortrows(MU_Median,{'SID','TargetForce_N'},{'ascend','ascend'});
     
    % IQR
    MU_IQR = varfun(@iqr,MU_Data,'InputVariables','MeanFiringRate','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','ForceCategory'});
    MU_IQR = sortrows(MU_IQR,{'SID','TargetForce_N'},{'ascend','ascend'});
    
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_Figure_FromTable(MU_Median, options);  
    print_FigureToWord(selection,[': All Subjects included. Each colored line represents data from a single subject.' char(13)],'WithMeta')
    close(gcf);

    options.Plot = get_Plot_Options_IQR_AbsoluteUnits();
    create_Figure_FromTable(MU_IQR, options);  
    print_FigureToWord(selection,['All Subjects included. Each colored line represents data from a single subject.' char(13)],'WithMeta')
    close(gcf);

    
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_Median_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'median_MeanFiringRate'};
    PlotOptions.YLabel          = 'Median Firing Rate (pps)';
    PlotOptions.YLim            = [0 22];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_IQR_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'iqr_MeanFiringRate'};
    PlotOptions.YLabel          = 'IQR Firing Rate (pps)';
    PlotOptions.YLim            = [0 14];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
  
%     MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'TargetForce','TargetForce_N'});  
%     figure; 
%     [n0,x0] = hist(MU_Data.MU_Amplitude);
%     bar(x0,n0); hold on;
%     plot(x0,n0,'-o')
%    