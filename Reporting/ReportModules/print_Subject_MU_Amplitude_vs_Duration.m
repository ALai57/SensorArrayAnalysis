
function print_Subject_MU_Amplitude_vs_Duration(selection,subjData,options)
        
    % Calculate MU Amplitude
    [MU_PtP, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(1));
    MU_PtP.MU_Amplitude  = cell2mat(MU_PtP.MU_Amplitude);
    MU_PtP.MU_Amplitude  = 1000*MU_PtP.MU_Amplitude;
    
    MU_PtP.MU_Duration  = cell2mat(MU_PtP.MU_Duration);
    MU_PtP.MU_Duration  = 1000*MU_PtP.MU_Duration;
    
    % Merge tables
    subjData          = append_FileID_Tag(subjData,options);
    MU_PtP            = append_FileID_Tag(MU_PtP,options);
    
    if isequal(subjData.FileID_Tag,MU_PtP.FileID_Tag)
    	subjData = [subjData,...
                    MU_PtP(:,[4,5])];
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
    PlotOptions.XVar            = {'MU_Duration'};
    PlotOptions.XLabel          = 'MU Duration(ms)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_PctMVC()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'ArrayNumber'};
    PlotOptions.ColorBy         = {'ArrayNumber'};
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


