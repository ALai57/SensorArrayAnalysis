
%%%% NEED OUTSIDE WRAPPER FUNCTION
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

function create_Figure_FromTable(data, options)

    figure; 
    
    if ~isempty(options.Plot.SubplotBy)
        subplot_ID = unique(data.(options.Plot.SubplotBy{1})); 
    else
        subplot_ID = {'All'};
    end
    
    nSubplots = length(subplot_ID);
    
    for i=1:nSubplots
        
        hA(i) = subplot(1,nSubplots,i); hold on;
        
        if ~isequal(subplot_ID,{'All'})
            ind_subplot = data.(options.Plot.SubplotBy{1})==subplot_ID(i);
            subplot_Data = data(ind_subplot,:);
        else
            subplot_Data = data;
        end

        
        groups = unique(subplot_Data.(options.Plot.GroupBy{1}));  
        for n=1:length(groups)
            [x,y] = get_XY_Data(subplot_Data,options,groups(n));
            hP(n) = plot(x,y); 
            format_DataSeries(hP(n),options)
        end

        if ~isempty(options.Plot.AdditionalPlots)
            ind = decompData.TargetForce == '100%MVC';
            ind = find(ind);
            MVC = decompData.TargetForce_N(ind(1));
            plot([MVC, MVC],yL,'k','linewidth',4);
        end
        
        format_Plot(options)
        setup_Legend(hA(i),groups,options)
%         title(options.Plot.Title,'fontsize',options.Plot.TitleSize);
        title(options.Plot.Title(subplot_Data,options),'fontsize',options.Plot.TitleSize);
    end
 
end

function format_Plot(options)
    set(gca,'fontsize' ,options.Plot.FontSize)
    xlabel(options.Plot.XLabel);
    ylabel(options.Plot.YLabel);
    xlim(options.Plot.XLim);
    ylim(options.Plot.YLim);
end

function format_DataSeries(hP,options)
    set(hP,'LineWidth',options.Plot.LineWidth);
    set(hP,'Marker'   ,options.Plot.Marker);
    set(hP,'LineStyle','none') 
end

function [x,y] = get_XY_Data(data,options,group)
    ind  = data.(options.Plot.GroupBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    y    = data.(options.Plot.YVar{1})(ind);
end

function setup_Legend(hA,groups,options)
    for n=1:length(groups)
       legendEntries(n) = {char(groups(n))}; 
    end
    
    %%%% ADD EXTRA GROUP NAME    %hL = legend('MVC');
    hL = legend(hA,legendEntries);   
    set(hL,'position',options.Plot.LegendLocation)
    legend boxoff
end