

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
    
    subplot_Var = get_Subplot_Variables(data, options);
    nSubplots   = length(subplot_Var);
    
    try
        data.FileID_Tag = [];
    end
    
    for i=1:nSubplots
        
        hA(i) = subplot(1,nSubplots,i); hold on;
        
        subplot_Data            = get_Subplot_Data(data,options,subplot_Var(i));
        [subplot_Data, options] = append_ColorData(subplot_Data,options);
        [subplot_Data, options] = append_GroupingInformation(subplot_Data,options);
        
        cGroups = unique(subplot_Data.(options.Plot.ColorBy{1}));
        pgroups  = unique(subplot_Data.PlotGroups); 
        for n=1:length(pgroups)
            [x,y,c] = get_XY_Data(subplot_Data,options,pgroups(n));
            hP(n)   = plot(x,y,'Color',c); 
            format_DataSeries(hP(n),options)
        end

        if ~isempty(options.Plot.AdditionalPlots)
            ind = decompData.TargetForce == '100%MVC';
            ind = find(ind);
            MVC = decompData.TargetForce_N(ind(1));
            plot([MVC, MVC],yL,'k','linewidth',4);
        end
        
        format_Plot(options)
        if ~isempty(options.Plot.LegendLocation)
            setup_Legend(hA(i),cGroups,options)
        end
        title(options.Plot.Title(subplot_Data,options),'fontsize',options.Plot.TitleSize,'interpreter','none');
    end
 
end

function format_Plot(options)
    set(gca,'fontsize' ,options.Plot.FontSize)
    xlabel(options.Plot.XLabel,'interpreter','none');
    ylabel(options.Plot.YLabel,'interpreter','none');
    
    if ~isempty(options.Plot.XLim)
        xlim(options.Plot.XLim);
    end
    if ~isempty(options.Plot.YLim)
        ylim(options.Plot.YLim);
    end
%     xlim(options.Plot.XLim);
%     ylim(options.Plot.YLim);
end

% function [subplot_Data, options] = append_ColorData(subplot_Data,options)
% 
%     [c, ~, colorIndex]    = unique(subplot_Data.(options.Plot.ColorBy{1}));
%     
%     if isempty(options.Plot.Colors) && length(c)<7
%         colorOrder = get(gca,'colororder');
%     elseif isempty(options.Plot.Colors) && length(colorIndex)>=7
%         colorOrder = varycolor(length(colorIndex));
%     else
%         colorOrder = options.Plot.Colors;
%     end
%     
%     for n=1:length(colorIndex)
%         color(n,:) = colorOrder(colorIndex(n),:);
%     end
%     
%     subplot_Data.Color = color; 
%     options.Plot.Colors = colorOrder;
% end

function [subplot_Data, options] = append_ColorData(subplot_Data,options)
    nColorVars = length(options.Plot.ColorBy);

    for n=1:nColorVars
        opt_append.FileID_Tag(n) = options.Plot.ColorBy(n);
    end
    subplot_Data = append_FileID_Tag(subplot_Data, opt_append);
    ind = categorical(subplot_Data.Properties.VariableNames) == 'FileID_Tag';
    subplot_Data.Properties.VariableNames(ind) = {'ColorGroups'};
    
    c = unique(subplot_Data.ColorGroups);
    if isempty(options.Plot.Colors) && length(c)<7
        colorOrder = get(gca,'colororder');
    elseif isempty(options.Plot.Colors) && length(c)>=7
        colorOrder = varycolor(length(c));
    else
        colorOrder = options.Plot.Colors;
    end
    
    cGroups = unique(subplot_Data.ColorGroups);
    color = zeros(size(subplot_Data,1),3);
    for n=1:length(cGroups)
        ind = subplot_Data.ColorGroups == cGroups(n);
        color(ind,:) = repmat(colorOrder(n,:),sum(ind),1);
    end
    
    subplot_Data.Color = color; 
    options.Plot.Colors = colorOrder;
    
end

function format_DataSeries(hP,options)
    set(hP,'LineWidth',options.Plot.LineWidth);
    set(hP,'Marker'   ,options.Plot.Marker);
    set(hP,'LineStyle',options.Plot.LineStyle);  
end

function [x,y,c] = get_XY_Data(data,options,group)
    ind  = data.PlotGroups == group;
    x    = data.(options.Plot.XVar{1})(ind);
    y    = data.(options.Plot.YVar{1})(ind);
    
    i    = find(ind);
    c    = data.Color(i(1),:);
end

function setup_Legend(hA,groups,options)

    for n=1:length(groups)
        hF(n) = plot(0,0);
        set(hF(n),'Color',options.Plot.Colors(n,:));
        format_DataSeries(hF(n),options);
%         set(hF(n),'Marker',options.Plot.Marker);
%         set(hF(n),'LineStyle',options.Plot.LineStyle);
%         set(hF(n),'LineWidth',
        set(hF(n),'Visible','off');
    end

    for n=1:length(groups)
       if isnumeric(groups(n))
            legendEntries(n) = {num2str(groups(n))};
       else
            legendEntries(n) = {char(groups(n))}; 
       end
    end
    
    %%%% ADD EXTRA GROUP NAME    %hL = legend('MVC');
    hL = legend(hF,legendEntries);   
    set(hL,'position',options.Plot.LegendLocation)
    legend boxoff
end

function subplot_Var = get_Subplot_Variables(data,options)
    if ~isempty(options.Plot.SubplotBy)
        subplot_Var = unique(data.(options.Plot.SubplotBy{1})); 
    else
        subplot_Var = {'All'};
    end
end

function subplot_Data = get_Subplot_Data(data,options,subplot_Var)
    if isequal(subplot_Var,{'All'})
        subplot_Data = data;
    else
        ind_subplot = data.(options.Plot.SubplotBy{1})==subplot_Var;
        subplot_Data = data(ind_subplot,:);
    end
end


function [subplot_Data, options] = append_GroupingInformation(subplot_Data,options)

    nGroupVars = length(options.Plot.GroupBy);

    for n=1:nGroupVars
        opt_append.FileID_Tag(n) = options.Plot.GroupBy(n);
    end

    subplot_Data = append_FileID_Tag(subplot_Data, opt_append);
    ind = categorical(subplot_Data.Properties.VariableNames) == 'FileID_Tag';
    subplot_Data.Properties.VariableNames(ind) = {'PlotGroups'};

end

    
    
    