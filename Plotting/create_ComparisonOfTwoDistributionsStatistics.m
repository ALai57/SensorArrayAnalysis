

function create_ComparisonOfTwoDistributionsStatistics(allData,options,hA)

    groups = unique(allData.(options.Plot.GroupBy{1}));  
    for i=1:length(groups)

        ind_subj = allData.(options.Plot.GroupBy{1}) == groups(i);
        subjData = allData(ind_subj,:);
        
        comparisons = unique(subjData.(options.Plot.CompareBy{1}));  
        for n=1:length(comparisons)
            data{n} = get_Data(subjData,options,comparisons(n));
        end

        switch options.Plot.CI.Statistic
            case 'Mean'    
                [~,p,ci]   = ttest2(data{2},data{1});
                effectSize = mean(data{2}) - mean(data{1});
                yName{i} = char(subjData.SID(1));
            case 'Median'
                [p,~,stat] = ranksum(data{2},data{1});
                ci = [0 0];
                effectSize = median(data{2}) - median(data{1});
        end

        if isempty(options.Plot.Axis)
            figure; 
            hA = axes();
        else
            hA = options.Plot.Axis;
            axes(hA);
        end

        hI = plot([ci],[i i],'k','linewidth',3); hold on;
        hM = plot([effectSize effectSize],[-0.1 0.1]+i,'k','linewidth',1.5);

    end
    set(hA,'ytick',0:length(groups));
    set(hA,'yticklabel',[{''}, yName, {''}]);
    if ~isempty(options.Plot.CI.XLim)
        xlim(options.Plot.CI.XLim);
    end
    xL = get(gca,'XLim');
    yL = get(gca,'YLim');
    hTxt = findobj(gca,'Type','Text');
    plot([0 0],yL,'r');
    yL = get(gca,'YLim');
    delete(hTxt);
    text(xL(1),yL(2), [char(comparisons(1)) ' Greater'],'verticalalignment','top')
    text(xL(2),yL(2), [char(comparisons(2)) ' Greater'],'horizontalalignment','right','verticalalignment','top')

end


function x = get_Data(data,options,group)
    ind  = data.(options.Plot.CompareBy{1}) == group;
    x    = data.(options.Plot.XVar{1})(ind);
    
    x(x==0)=[];
end





% 
% 
% function create_ComparisonOfTwoDistributionsStatistics(data,groupNames,hA,ht,statistic,options)
%         
%         switch statistic
%             case 'Mean'    
%                 [~,p,ci]   = ttest2(data{2},data{1});
%                 effectSize = mean(data{2}) - mean(data{1});
%                 yName = 'Mean + CI';
%             case 'Median'
%                 [p,~,stat] = ranksum(data{2},data{1});
%                 ci = [0 0];
%                 effectSize = median(data{2}) - median(data{1});
%         end
%         
%         if isempty(hA)
%             figure; 
%             hA = axes();
%         else
%             axes(hA);
%         end
%         
%         hI = plot([ci],[ht ht],'k','linewidth',3); hold on;
%         hM = plot([effectSize effectSize],[-0.1 0.1]+ht,'k','linewidth',1.5);
%         
%         set(hA,'yticklabel',{'', yName, ''})
%         xlim(options.CI.XLim);
%         xL = get(gca,'XLim');
%         yL = get(gca,'YLim');
%         hTxt = findobj(gca,'Type','Text');
%         delete(hTxt);
%         text(xL(1),yL(2), [char(groupNames(1)) ' Greater'])
%         text(xL(2),yL(2), [char(groupNames(2)) ' Greater'],'horizontalalignment','right')
% 
% end