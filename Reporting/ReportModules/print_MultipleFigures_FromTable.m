

% options.Plot.PlotBy          = {'SID'};
% options.Plot.SubplotBy       = {'ArmType'}; 
% options.Plot.GroupBy         = {'ArrayNumber'};
% options.Plot.AdditionalPlots = [];
% options.Plot.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
% options.Plot.LineWidth       = 2;
% options.Plot.LineStyle       = 'none';
% options.Plot.Marker          = 'o';
% options.Plot.FontSize        = 12;
% 
% options.Plot.XVar            = {'TargetForce_N'};
% options.Plot.XLabel          = 'Target Force (N)';
% options.Plot.XLim            = [0 100];
% options.Plot.YVar            = {'nMU'};
% options.Plot.YLabel          = 'Number of Motor Units';
% options.Plot.YLim            = [0 60];
% options.Plot.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;        %   'Hi' %
% options.Plot.TitleSize       = 16;
% 
% load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Stroke_4_6_2017.mat')
% 
% options.nArrays = 2;
% options.NewVariableNames = {'nMU'};
% options.TableVariables   = {'SID',...
%                            'ArmType',...
%                            'ArmSide',...
%                            'Experiment',...
%                            'TargetForce',...
%                            'ID',...
%                            'TrialName',...
%                            'SensorArrayFile',...
%                            'SingleDifferentialFile',...
%                            'ArrayNumber',...
%                            'ArrayLocation',...
%                            'DecompChannels',...
%                            'TargetForce_MVC',...
%                            'TargetForce_N'};
% 
% 
% trialData{1} = @(arrayData_tbl,options)get_NumberOfMUsDecomposed(arrayData_tbl,options);
% data         = get_Data_FromTrial(MU_Data,trialData,options);

function print_MultipleFigures_FromTable(selection, data, options)
    
    options.FileID_Tag = options.Plot.PlotBy;
    data = append_FileID_Tag(data,options); 
    ind = categorical(data.Properties.VariableNames) == 'FileID_Tag';
    data.Properties.VariableNames(ind) = {'PlotID_Tag'};

    
    plot_ID = unique(data.PlotID_Tag); 
    nPlots = length(plot_ID);
    
    for n=1:nPlots
        ind_plot = data.PlotID_Tag == plot_ID(n);
        plotData = data(ind_plot,:);
        create_Figure_FromTable(plotData, options)
        
        print_FigureToWord(selection,[char(plot_ID(n))],'WithMeta')
        close(gcf);
        selection.InsertBreak;
    end

end



