

function [s] = create_ComparisonOfTwoRegressions(allData,options,hA)

    groups = unique(allData.(options.Plot.GroupBy{1}));  
    for i=1:length(groups)

        ind_subj = allData.(options.Plot.GroupBy{1}) == groups(i);
        subjData = allData(ind_subj,:);
        
        comparisons = unique(subjData.(options.Plot.CompareBy{1}));  
        for n=1:length(comparisons)
            [x{n} y{n}] = get_Data(subjData,options,comparisons(n));
        end

        regression{1} = regress_linear(x{1},y{1});
        regression{2} = regress_linear(x{2},y{2});
        
        yName{i} = char(subjData.SID(1));
        s(i).SID = yName{i};  
        [s(i).fTest] = F_test_EqualRegressionVariances(regression{1},regression{2},0.05);
        [s(i).tTest] = T_test_EqualRegressionSlopes(regression{1},regression{2},0.05);
        
      
        
        if isempty(options.Plot.Axis)
            figure; 
            hA = axes();
        else
            hA = options.Plot.Axis;
            axes(hA);
        end
        ci = s(i).tTest(1).CI_95;
        effectSize = s(i).tTest(1).Estimate(2)-s(i).tTest(1).Estimate(1);
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

        
function [x,y] = get_Data(data,options,group)
    ind  = data.(options.Plot.CompareBy{1}) == group;
    x    = data.(options.Plot.Predictor{1})(ind);
    y    = data.(options.Plot.Response{1})(ind);
    
    x = [ones(size(x)),x];
    x(y==0)=[];
    y(y==0)=[];
end

function [b0,b1,ssx,sse,n,df] = get_regression_output(r)
    b0  = r.beta(1);
    b1  = r.beta(2);
    x   = r.predictor(:,2:end); 
    ssx = (x-mean(x))'*(x-mean(x));
    n   = size(x,1);
    df  = r.error_df;
    sse = r.sse;
end

function [Ftest] = F_test_EqualRegressionVariances(reg1,reg2,alpha)
    
    [b0_1,b1_1,ssx1,sse1,n1,df1] = get_regression_output(reg1);
    [b0_2,b1_2,ssx2,sse2,n2,df2] = get_regression_output(reg2);
        
%     Ftest(1).SID = '';
    
    %Are variances equal?
    if sse1>sse2
        Ftest(1).F_stat = sse1/sse2;
        Ftest(1).F_crit = finv(1-alpha/2,df1,df2);
        Ftest(1).p      = 1-fcdf(Ftest(1).F_stat,df1,df2);
    else
        Ftest(1).F_stat = sse2/sse1;
        Ftest(1).F_crit = finv(1-alpha/2,df2,df1);
        Ftest(1).p      = 1-fcdf(Ftest(1).F_stat,df2,df1);
    end
end

function  [tTest] = T_test_EqualRegressionSlopes(reg1,reg2,alpha)
    
    [b0_1,b1_1,ssx1,sse1,n1,df1] = get_regression_output(reg1);
    [b0_2,b1_2,ssx2,sse2,n2,df2] = get_regression_output(reg2);
    var1 = sse1/df1;
    var2 = sse2/df2;
    
    %Correct DF for unequal variances 
    tTest(1).Stat  = 'Beta1';
    tTest(1).Estimate  = [b1_1, b1_2];
    tTest(1).Type  = 'UnequalVariances';
    tTest(1).DF    = satterthwaite_DFapprox_regresssion_ttest2(var1,var2,ssx1,ssx2,df1,df2);
    num = b1_2-b1_1;
    denom = sse1/(n1-2)/ssx1+sse2/(n2-2)/ssx2;
    tTest(1).t_SE   = sqrt(denom);
    tTest(1).T_stat = num/sqrt(denom);
    tTest(1).T_crit = tinv(1-alpha/2,tTest(1).DF);
    p = tcdf(tTest(1).T_stat,tTest(1).DF);
    if p>0.5
        p = 1-p;
    end
    tTest(1).p     = p*2; % Two tailed test
    tTest(1).CI_95 = [num-tTest(1).t_SE*tTest(1).T_crit,num+tTest(1).t_SE*tTest(1).T_crit];
    
    %Do not need to correct DF for equal regression variances 
    tTest(2).Stat  = 'Beta1';
    tTest(2).Estimate  = [b1_1, b1_2];
    tTest(2).Type  = 'EqualVariances';
    tTest(2).DF    = n1+n2-4;
    num    = b1_2-b1_1;
    s_pool = (sse1+sse2)/(n1+n2-4);
    denom  = s_pool*(1/ssx1+1/ssx2);
    tTest(2).t_SE   = sqrt(denom);
    tTest(2).T_stat = num/sqrt(denom);
    tTest(2).T_crit = tinv(1-alpha/2,tTest(2).DF);
    p = tcdf(tTest(2).T_stat,tTest(2).DF);
    if p>0.5
        p = 1-p;
    end
    tTest(2).p     = p*2; % Two tailed test
    tTest(2).CI_95 = [num-tTest(2).t_SE*tTest(2).T_crit,num+tTest(2).t_SE*tTest(2).T_crit];
end



% function df = calc_DF(x1,x2,sse1,sse2)
%     ssx1 = sum((x1-mean(x1)).^2);
%     ssx2 = sum((x2-mean(x2)).^2);
% 
%     n1 = length(x1);
%     n2 = length(x2);
%     
%     num = (sse1/ssx1+sse2/ssx2)^2;
%     denom = (sse1/ssx1)^2/n1 + (sse2/ssx2)^2/n2; 
%     
%     df = num/denom;
% end
