

function create_Figure_FromTable_MultiInputSubplot(data, options)

    figure; 
    
    nSubplots = length(options.Plot.YVar);
    
    try
        data.FileID_Tag = [];
    end
    
    [data, options] = append_ColorData(data,options);
    [data, options] = append_GroupingInformation(data,options);

    cGroups = unique(data.(options.Plot.ColorBy{1}));
    pGroups = unique(data.PlotGroups); 
    for i=1:nSubplots
        for n=1:length(pGroups)
            hA(i)   = subplot(1,nSubplots,i); hold on;
            [x,y,c] = get_XY_Data(data,options,pGroups(n),i);
            hP(i,n) = plot(x,y,'Color',c); 
            format_DataSeries(hP(i,n),options)
            format_Plot(options)
            title(options.Plot.YVar{i},'fontsize',options.Plot.TitleSize,'interpreter','none');
        end
    end
    axes(hA(1)); add_PlotLabels(options);
    
    
    set(gcf,'position', [174   289   960   307]);
    if ~isempty(options.Plot.LegendLocation)
        setup_Legend(hA(1),cGroups,options)
    end
    
end

function add_PlotLabels(options)
    xlabel(options.Plot.XLabel,'interpreter','none');
    ylabel(options.Plot.YLabel,'interpreter','none');
end

function format_Plot(options)
    set(gca,'fontsize' ,options.Plot.FontSize)

    if ~isempty(options.Plot.XLim)
        xlim(options.Plot.XLim);
    end
    if ~isempty(options.Plot.YLim)
        ylim(options.Plot.YLim);
    end
    
end


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
    elseif length(options.Plot.Colors) < length(c)
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

function [x,y,c] = get_XY_Data(data,options,group,n)
    ind  = data.PlotGroups == group;
    x    = data.(options.Plot.XVar{1})(ind);
    y    = data.(options.Plot.YVar{n})(ind);
    
    i    = find(ind);
    c    = data.Color(i(1),:);
end

function setup_Legend(hA,groups,options)

    for n=1:length(groups)
        hF(n) = plot(0,0);
        set(hF(n),'Color',options.Plot.Colors(n,:));
        format_DataSeries(hF(n),options);
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

function [subplot_Data, options] = append_GroupingInformation(subplot_Data,options)

    nGroupVars = length(options.Plot.GroupBy);

    for n=1:nGroupVars
        opt_append.FileID_Tag(n) = options.Plot.GroupBy(n);
    end

    subplot_Data = append_FileID_Tag(subplot_Data, opt_append);
    ind = categorical(subplot_Data.Properties.VariableNames) == 'FileID_Tag';
    subplot_Data.Properties.VariableNames(ind) = {'PlotGroups'};

end

    
    
    