
function create_HistogramComparison_FromTable(allData, options)

    figure; 
    
    if ~isempty(options.Plot.SubplotBy)
        subplot_ID = unique(allData.(options.Plot.SubplotBy{1})); 
    else
        subplot_ID = {'All'};
    end
    
    nSubplots = length(subplot_ID);
    
    for i=1:nSubplots
        
%         hA(i) = subplot(3,nSubplots,i); hold on;
        
        if ~isequal(subplot_ID,{'All'})
            ind_subplot = allData.(options.Plot.SubplotBy{1})==subplot_ID(i);
            subplot_Data = allData(ind_subplot,:);
        else
            subplot_Data = allData;
        end

        
        groups = unique(subplot_Data.(options.Plot.CompareBy{1}));  
        for n=1:length(groups)
            data{n} = get_Data(subplot_Data,options,groups(n));
            [y, x] = hist(data{n});
            
            hS(1,i) = subplot(6,i,1:2); hold on;
            hP(n) = plot(x,y,options.Plot.Colors{n}); 
            plot_Mean(data{n},x,y);
            format_DataSeries(hP(n),options)

            hS(2,i) = subplot(6,i,3:4); hold on;
            hP2(n) = plot(x,y/sum(y),options.Plot.Colors{n}); 
            plot_Mean(data{n},x,y/sum(y));
            format_DataSeries(hP2(n),options)
            % SHOW MEAN FR

        end

        
        hS(3,i) = subplot(6,i,6); hold on;
        
        options.Plot.Axis = hS(3,i);
        create_ComparisonOfTwoDistributionsStatistics(subplot_Data,options)
       
        format_Plot(hS,options);
        axes(hS(1,i));
        hL(i) = setup_Legend(hP,groups,options);
        title(options.Plot.Title(subplot_Data,options),'fontsize',options.Plot.TitleSize);
    end
 
end

function plot_Mean(data,x,y)
    avg = mean(data);
    
    i = find(avg<x,1,'first');
    
    pct = (avg-x(i-1))/(x(i)-x(i-1));
    yL(2) = y(i-1) + (y(i)-y(i-1))*pct;
    
    hold on; plot([avg avg],yL,'k')
end

function format_Plot(hS,options)
    
    axes(hS(1))
    ylabel(['# ' options.Plot.YLabel]);
    axes(hS(2))
    ylabel(['% ' options.Plot.YLabel]);
    xlabel(options.Plot.XLabel);
    axes(hS(3))
    xlabel(['\Delta' options.Plot.XLabel])
    for n=1:2
        axes(hS(n));
        set(gca,'fontsize' ,options.Plot.FontSize)
        if ~isempty(options.Plot.XLim)
            xlim(options.Plot.XLim);
        end
        if ~isempty(options.Plot.YLim)
            ylim(options.Plot.YLim);
        end
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
    ind  = data.(options.Plot.CompareBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    
    x(x==0)=[];
end

function hL = setup_Legend(hP,groups,options)
    for n=1:length(groups)
       
       if isnumeric(groups(n))
            legendEntries(n) = {num2str(groups(n))};
       else
            legendEntries(n) = {char(groups(n))}; 
       end
    end
    
    %%%% ADD EXTRA GROUP NAME    %hL = legend('MVC');
    hL = legend(hP,legendEntries);   
    set(hL,'position',options.Plot.LegendLocation)
    legend boxoff
end


                
%         [~,pT,ciT] = ttest2(data{2},data{1});
%         [pW,~,statsW] = ranksum(data{2},data{1});
%         effectSize_mean = mean(data{2}) - mean(data{1});
%         effectSize_median = median(data{2}) - median(data{1});
%         
%         pI = plot([ciT],[1 1],'k','linewidth',3); hold on;
%         pM = plot([effectSize_mean effectSize_mean],[0.9 1.1],'k','linewidth',1.5);
%         set(hS(3,i),'yticklabel',{'', 'Mean + CI', ''})
%         xlim(options.Plot.CI.XLim);
%         xL = get(gca,'XLim');
%         yL = get(gca,'YLim');
%         text(xL(1),yL(2), [char(groups(1)) ' Greater'])
%         text(xL(2),yL(2), [char(groups(2)) ' Greater'],'horizontalalignment','right')
%         plot([],[2 2])