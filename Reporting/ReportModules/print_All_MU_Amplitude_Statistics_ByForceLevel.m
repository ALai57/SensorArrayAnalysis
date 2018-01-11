
function print_All_MU_Amplitude_Statistics_ByForceLevel(selection,MU_Data,options)
    
    % Calculate MU Amplitude
    [MU_PtP_Amp, ~] = apply_To_Trials_In_DataTable(MU_Data,options.Analysis(1));
    MU_PtP_Amp.MU_Amplitude  = cell2mat(MU_PtP_Amp.MU_Amplitude);
    MU_PtP_Amp.MU_Amplitude  = 1000*MU_PtP_Amp.MU_Amplitude;
    
    % Merge tables
    MU_Data           = append_FileID_Tag(MU_Data,options);
    MU_PtP_Amp        = append_FileID_Tag(MU_PtP_Amp,options);
    
    if isequal(MU_Data.FileID_Tag,MU_PtP_Amp.FileID_Tag)
    	MU_Data = [MU_Data, MU_PtP_Amp(:,4)];
    end
    
    SID = MU_Data.SID(1); 
    
    ind = MU_Data.TargetForce == '100%MVC';
    MU_Data(ind,:) = [];
    
    % Median
    MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','ForceCategory'});
    MU_Median = sortrows(MU_Median,{'SID','TargetForce_N'},{'ascend','ascend'});
     
    % IQR
    MU_IQR = varfun(@iqr,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','ForceCategory'});
    MU_IQR = sortrows(MU_IQR,{'SID','TargetForce_N'},{'ascend','ascend'});
    
    arms = unique(MU_IQR.ArmType);
    
    for n=1:length(arms)
        ind_m = MU_Median.ArmType == arms(n);
        options.Plot = get_Plot_Options_Median_AbsoluteUnits();
        create_Figure_FromTable(MU_Median(ind_m,:), options);  
        print_FigureToWord(selection,[char(arms(n)) ': All Subjects included. Each colored line represents data from a single subject. Small forces and large forces are plotted on separate plots, for visualization.' char(13)],'WithMeta')
        close(gcf);

        ind_i = MU_Median.ArmType == arms(n);
        options.Plot = get_Plot_Options_IQR_AbsoluteUnits();
        create_Figure_FromTable(MU_IQR(ind_i,:), options);  
        print_FigureToWord(selection,[char(arms(n)) 'All Subjects included. Each colored line represents data from a single subject. Small forces and large forces are plotted on separate plots, for visualization.' char(13)],'WithMeta')
        close(gcf);
    end
    
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_Median_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ForceCategory'}; 
    PlotOptions.GroupBy         = {'SID','ForceCategory'};
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
    PlotOptions.YVar            = {'median_MU_Amplitude'};
    PlotOptions.YLabel          = 'Median MU Amplitude (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_IQR_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ForceCategory'}; 
    PlotOptions.GroupBy         = {'SID','ForceCategory'};
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
    PlotOptions.YVar            = {'iqr_MU_Amplitude'};
    PlotOptions.YLabel          = 'IQR MU Amplitude (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
  
%     MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'TargetForce','TargetForce_N'});  
%     figure; 
%     [n0,x0] = hist(MU_Data.MU_Amplitude);
%     bar(x0,n0); hold on;
%     plot(x0,n0,'-o')
%    