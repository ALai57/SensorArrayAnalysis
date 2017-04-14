
% load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_3_30_2017');
% ind = MU_Data.SID == 'JC';
% subjData = MU_Data(ind,:);

function print_Subject_NumberOfMUsDecomposed(selection,subjData,options)
    
    options.nArrays = 2;
    options.NewVariableNames = {'nMU'};
    options.TableVariables   = {'SID',...
                               'ArmType',...
                               'ArmSide',...
                               'Experiment',...
                               'TargetForce',...
                               'ID',...
                               'TrialName',...
                               'SensorArrayFile',...
                               'SingleDifferentialFile',...
                               'ArrayNumber',...
                               'ArrayLocation',...
                               'DecompChannels',...
                               'TargetForce_MVC',...
                               'TargetForce_N'};
      
    trialData{1} = @(arrayData_tbl,options)get_NumberOfMUsDecomposed(arrayData_tbl,options);
    data         = get_Data_FromTrial(subjData,trialData,options);

    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(data, options)
    SID = data.SID(1);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_PctMVC();
    create_Figure_FromTable(data, options);
    SID = data.SID(1);
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_AbsoluteUnits()

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
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'nMU'};
    PlotOptions.YLabel          = 'Number of Motor Units';
    PlotOptions.YLim            = [0 60];
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


