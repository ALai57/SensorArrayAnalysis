
function create_SidewaysHistogram_FromTable(allData, options)

    figure; 
    
    if ~isempty(options.Plot.SubplotBy)
        subplot_ID = unique(allData.(options.Plot.SubplotBy{1})); 
    else
        subplot_ID = {'All'};
    end
    
    nSubplots = length(subplot_ID);
    
    for i=1:nSubplots
        
        hA(i) = subplot(1,nSubplots,i); hold on;
        
        if ~isequal(subplot_ID,{'All'})
            ind_subplot = allData.(options.Plot.SubplotBy{1})==subplot_ID(i);
            subplot_Data = allData(ind_subplot,:);
        else
            subplot_Data = allData;
        end

        
        groups = unique(subplot_Data.(options.Plot.GroupBy{1}));  
        for n=1:length(groups)
            [xdata,ydata] = get_Data(subplot_Data,options,groups(n));
            nXgroups = unique(xdata);
            for j = 1:length(nXgroups)
                ind_x = xdata == nXgroups(j);
                x = xdata(ind_x);
                y = ydata(ind_x);
                if isempty(y) || length(y)<2
                    plot(0,0);
                else
                    [n0, x0] = hist(y);
                    try
                        nNorm = n0/max(n0)*0.9*(nXgroups(2)-nXgroups(1));
                    catch
                        continue;
                    end
                    hP(n) = plot(nNorm+x(1),x0,options.Plot.Colors{n},'linewidth',2); 
                    hF(n) = fill([nNorm,flip(nNorm*0)]+x(1),[x0,flip(x0)],options.Plot.Colors{n});
                    set(hF(n),'facealpha',.5);
                    plot([0 max(nNorm)]+x(1),[median(y), median(y)],'k','linewidth',2)
    %                 format_DataSeries(hP(n),options)
                end
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
    set(hP,'LineStyle','-'); 
end

function [x,y] = get_Data(data,options,group)
    ind  = data.(options.Plot.GroupBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    y    = data.(options.Plot.YVar{1})(ind);
    
    x(y==0)=[];
    y(y==0)=[];
end

function hL = setup_Legend(hA,groups,options)
    


    for n=1:length(groups)
       
       hP(n) = plot(0,0,options.Plot.Colors{n},'linewidth',3);
       if isnumeric(groups(n))
            legendEntries(n) = {num2str(groups(n))};
       else
            legendEntries(n) = {char(groups(n))}; 
       end
    end
    
    hP(n+1) = plot(0,0,'k','linewidth',2);
    legendEntries(n+1) = {'Median'};
    %%%% ADD EXTRA GROUP NAME    %hL = legend('MVC');
    hL = legend(hP,legendEntries);   
    set(hL,'position',options.Plot.LegendLocation)
    legend boxoff
end