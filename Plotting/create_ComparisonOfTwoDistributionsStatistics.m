

function [s] = create_ComparisonOfTwoDistributionsStatistics(allData,options,hA)

    groups = unique(allData.(options.Plot.GroupBy{1}));  
    for i=1:length(groups)

        ind_subj = allData.(options.Plot.GroupBy{1}) == groups(i);
        subjData = allData(ind_subj,:);
        
        comparisons = unique(subjData.(options.Plot.CompareBy{1}));  
        for n=1:length(comparisons)
            data{n} = get_Data(subjData,options,comparisons(n));
        end

        
        yName{i} = char(subjData.SID(1));
        s(i).SID = yName{i};  
        switch options.Plot.CI.Statistic
            case 'Mean'    
                [s(i).fTest] = F_test_EqualVariances(data{1},data{2},0.05);
                [s(i).tTest] = T_test_EqualMeans(data{1},data{2},0.05);
                [~,p,ci]   = ttest2(data{2},data{1});
                effectSize = mean(data{2}) - mean(data{1});
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




function [Ftest] = F_test_EqualVariances(x,y,alpha)
    
    df1  = length(x)-1;
    df2  = length(y)-1;
    sse1 = sum((x-mean(x)).^2);
    sse2 = sum((y-mean(y)).^2);
    mse1 = sse1/df1;
    mse2 = sse2/df2;
    
    %Are variances equal?
    if sse1>sse2
        Ftest(1).F_stat = mse1/mse2;
        Ftest(1).F_crit = finv(1-alpha/2,df1,df2);
        Ftest(1).p      = 1-fcdf(Ftest(1).F_stat,df1,df2);
    else
        Ftest(1).F_stat = mse2/mse1;
        Ftest(1).F_crit = finv(1-alpha/2,df2,df1);
        Ftest(1).p      = 1-fcdf(Ftest(1).F_stat,df2,df1);
    end
end

function  [tTest] = T_test_EqualMeans(x,y,alpha)
    
    n1   = length(x);
    n2   = length(y);
    df1  = length(x)-1;
    df2  = length(y)-1;
    sse1 = sum((x-mean(x)).^2);
    sse2 = sum((y-mean(y)).^2);
    
    var1 = sse1/df1;
    var2 = sse2/df2;
    
    %Correct DF for unequal variances 
    tTest(1).Stat  = 'Mean';
    tTest(1).Estimate  = [mean(x), mean(y)];
    tTest(1).Type  = 'UnequalVariances';
    tTest(1).DF    = satterthwaite_DFapprox_regresssion_ttest2(var1,var2,1,1,df1,df2);
    num = mean(x)-mean(y);
    denom = sqrt(sse1/(df1)/n1+sse2/(df2)/n2);
    tTest(1).t_SE   = denom;
    tTest(1).T_stat = num/denom;
    tTest(1).T_crit = tinv(1-alpha/2,tTest(1).DF);
    p = tcdf(tTest(1).T_stat,tTest(1).DF);
    if p>0.5
        p = 1-p;
    end
    tTest(1).p     = p*2; % Two tailed test
    tTest(1).CI_95 = [num-tTest(1).t_SE*tTest(1).T_crit,num+tTest(1).t_SE*tTest(1).T_crit];

    %Do not need to correct DF for equal regression variances 
    tTest(2).Stat  = 'Mean';
    tTest(2).Estimate  = [mean(x), mean(y)];
    tTest(2).Type  = 'EqualVariances';
    tTest(2).DF    = n1+n2-2;
    num    = mean(x)-mean(y);
    s_pool = (sse1+sse2)/(n1+n2-2);
    denom  = sqrt(s_pool)*sqrt(1/n1+1/n2);
    tTest(2).t_SE   = denom;
    tTest(2).T_stat = num/denom;
    tTest(2).T_crit = tinv(1-alpha/2,tTest(2).DF);
    p = tcdf(tTest(2).T_stat,tTest(2).DF);
    if p>0.5
        p = 1-p;
    end
    tTest(2).p     = p*2; % Two tailed test
    tTest(2).CI_95 = [num-tTest(2).t_SE*tTest(2).T_crit,num+tTest(2).t_SE*tTest(2).T_crit];

end
