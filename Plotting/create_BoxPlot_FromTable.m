

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

function create_BoxPlot_FromTable(data, options)

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

        
        groups = unique(subplot_Data.(options.Plot.BoxPlotBy{1}));  
        x = zeros(length(groups),1);
        y = [];
        for n=1:length(groups)
            [x(n),y{n}] = get_Data(subplot_Data,options,groups(n));
            hP(n,:) = boxplot(y{n},'labels',{char(groups(n))},'position',x(n)); 
            hold on;      
        end
        
        options.Plot.YMax = max(data.(options.Plot.YVar{1}));
        options.Plot.YMin = min(data.(options.Plot.YVar{1}));
        
        format_Plot(options);
        xlabel(options.Plot.BoxPlotBy{1});
        format_DataSeries(hP,x,groups,options);
        title({options.Plot.Title(subplot_Data,options)},'fontsize',options.Plot.TitleSize);
        xlabel(options.Plot.XLabel);
        
        if ~isempty(options.Plot.AdditionalPlots)
            ind = decompData.TargetForce == '100%MVC';
            ind = find(ind);
            MVC = decompData.TargetForce_N(ind(1));
            plot([MVC, MVC],yL,'k','linewidth',4);
        end
       
       
    end
 
end

function format_Plot(options)
    set(gca,'fontsize' ,options.Plot.FontSize)
    xlabel(options.Plot.XLabel);
    ylabel(options.Plot.YLabel);
end

function format_DataSeries(hP,x,groups,options)
    
    for n=1:size(hP,1)
        dx = options.Plot.Box.Width;
        
        if options.Plot.Box.Units == 'RelativeToMax'
            set(hP(n,3),'XData',[x(n) x(n)] + [-dx dx]*max(x)*0.8 );
            set(hP(n,4),'XData',[x(n) x(n)] + [-dx dx]*max(x)*0.8 );
            set(hP(n,5),'XData',[x(n) x(n) x(n) x(n) x(n)] + [-dx -dx dx dx -dx]*max(x) );
            set(hP(n,6),'XData',[x(n) x(n)] + [-dx dx]*max(x) );
            xlim(options.Plot.XLim*max(x));
        elseif options.Plot.BoxUnits == 'Absolute'
            set(hP(n,3),'XData',[x(n) x(n)] + [-dx dx]*0.8 );
            set(hP(n,4),'XData',[x(n) x(n)] + [-dx dx]*0.8 );
            set(hP(n,5),'XData',[x(n) x(n) x(n) x(n) x(n)] + [-dx -dx dx dx -dx]);
            set(hP(n,6),'XData',[x(n) x(n)] + [-dx dx]);
            xlim(options.Plot.XLim);
        end
     
        set(hP(n,1),'LineWidth',options.Plot.LineWidth);
        set(hP(n,2),'LineWidth',options.Plot.LineWidth);
        set(hP(n,3),'LineWidth',options.Plot.LineWidth);
        set(hP(n,4),'LineWidth',options.Plot.LineWidth);
        set(hP(n,5),'LineWidth',options.Plot.LineWidth);
        set(hP(n,6),'LineWidth',options.Plot.LineWidth);
        
%         set(hP,'Marker'   ,options.Plot.Marker);
%         set(hP,'LineStyle','none') 
    end
    
    if isempty(options.Plot.YLim)
        ylim([0 options.Plot.YMax*1.05]);
    else
        ylim(options.Plot.YLim);
    end
    
    ax1 = gca;
    ax1_pos = ax1.Position; % position of first axes
    axes(ax1); box off;
    set(ax1,'position',ax1_pos.*[1,1,1,0.85])
    ax1_pos = ax1.Position;
    xL = get(ax1,'xlim');
    [~, i] = sort(x);
    set(ax1,'xtick',x(i));
    labels = char(groups);
    labels = cellstr(labels(:,1:3));
    set(ax1,'xticklabel',labels(i));
    
    ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
    set(ax2,'xlim',xL);
    set(ax2,'yticklabel',[]);
    set(ax2,'ytick',[]);
    
    
    
end

function [x,y] = get_Data(data,options,group)
    ind  = data.(options.Plot.BoxPlotBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    y    = data.(options.Plot.YVar{1})(ind);
    x    = x(1);
end

function setup_Legend(hA,groups,options)
    for n=1:length(groups)
       
       if isnumeric(groups(n))
            legendEntries(n) = {num2str(groups(n))};
       else
            legendEntries(n) = {char(groups(n))}; 
       end
    end
    
    %%%% ADD EXTRA GROUP NAME    %hL = legend('MVC');
    hL = legend(hA,legendEntries);   
    set(hL,'position',options.Plot.LegendLocation)
    legend boxoff
end