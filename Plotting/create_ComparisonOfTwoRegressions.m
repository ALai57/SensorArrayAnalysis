

function create_ComparisonOfTwoRegressions(allData,options,hA)

    groups = unique(allData.(options.Plot.GroupBy{1}));  
    for i=1:length(groups)

        ind_subj = allData.(options.Plot.GroupBy{1}) == groups(i);
        subjData = allData(ind_subj,:);
        
        comparisons = unique(subjData.(options.Plot.CompareBy{1}));  
        for n=1:length(comparisons)
            [x{n} y{n}] = get_Data(subjData,options,comparisons(n));
        end

        
        %FINISH REGRESSION ANALYSIS 4.27.2017
%         [b,bint,r,rint,stats]   = regress(y{1},x{1});
%         [b1, sd_b1, sse1, df1] = regress_linear(x{1},y{1});
%         [b2, sd_b2, sse2, df2] = regress_linear(x{2},y{2});

        regression{1} = regress_linear(x{1},y{1});

        effectSize = b1(2) - b2(2);
        denom = sqrt(sd_b1(2).^2 + sd_b2(2).^2);
        t_stat = effectSize/denom;
        
        df = calc_DF(x{1}(:,2),x{2}(:,2),sse1,sse2);
        
        yName{i} = char(subjData.SID(1));


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

% function [b, sd_b, sse, df] = regress_linear(x,y)
%     b    = inv(x'*x)*(x'*y);
%     e    = y-x*b;
%     df   = length(x)-2;
%     sse  = sum(e.*e);
%     mse  = sse/df;
%     bvar = mse*inv(x'*x);
%     sd_b = sqrt(abs(bvar));
%     sd_b = [sd_b(1,1); sd_b(2,2)];
% %     b(1)+sd_b(1,1)*tinv(1-0.05/2,df);
% end

function [x,y] = get_Data(data,options,group)
    ind  = data.(options.Plot.CompareBy{1}) == group;
    x    = data.(options.Plot.Predictor{1})(ind);
    y    = data.(options.Plot.Response{1})(ind);
    
    x = [ones(size(x)),x];
    x(y==0)=[];
    y(y==0)=[];
end

function df = calc_DF(x1,x2,sse1,sse2)
    ssx1 = sum((x1-mean(x1)).^2);
    ssx2 = sum((x2-mean(x2)).^2);

    n1 = length(x1);
    n2 = length(x2);
    
    num = (sse1/ssx1+sse2/ssx2)^2;
    denom = (sse1/ssx1)^2/n1 + (sse2/ssx2)^2/n2; 
    
    df = num/denom;
end
