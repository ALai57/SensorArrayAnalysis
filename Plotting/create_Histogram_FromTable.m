
function create_Histogram_FromTable(data, options)

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
            data = get_Data(subplot_Data,options,groups(n));
            if isempty(data) || length(data)<2
                plot(0,0);
            else
                [y, x] = hist(data);
                hP(n) = plot(x,y); 
                format_DataSeries(hP(n),options)
            end
        end

        if ~isempty(options.Plot.AdditionalPlots)
            ind = decompData.TargetForce == '100%MVC';
            ind = find(ind);
            MVC = decompData.TargetForce_N(ind(1));
            plot([MVC, MVC],yL,'k','linewidth',4);
        end
        
        format_Plot(options)
        hL(i) = setup_Legend(hA(i),groups,options);
%         title(options.Plot.Title,'fontsize',options.Plot.TitleSize);
        title(options.Plot.Title(subplot_Data,options),'fontsize',options.Plot.TitleSize);
    end
 
end

function format_Plot(options)
    set(gca,'fontsize' ,options.Plot.FontSize)
    xlabel(options.Plot.XLabel);
    ylabel(options.Plot.YLabel);
    
    if ~isempty(options.Plot.XLim)
        xlim(options.Plot.XLim);
    end
    if ~isempty(options.Plot.YLim)
        ylim(options.Plot.YLim);
    end
%     xlim(options.Plot.XLim);
%     ylim(options.Plot.YLim);
end

function format_DataSeries(hP,options)
    set(hP,'LineWidth',options.Plot.LineWidth);
    set(hP,'Marker'   ,options.Plot.Marker);
    set(hP,'LineStyle','-') 
end

function x = get_Data(data,options,group)
    ind  = data.(options.Plot.GroupBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    
    x(x==0)=[];
end

function hL = setup_Legend(hA,groups,options)
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