

function print_WeaknessCorrelations(selection,s,options)

    s      = clean_S(s);
    s_Sort = sort_S(s,'Ratio','MVC_Force');
    
    plot_ScatterMatrices(s_Sort)
    selection.TypeText(['Scatter Matrices' char(13)])  
    print_FigureToWord(selection,['Difference'],'WithMeta'); close(gcf)
    print_FigureToWord(selection,['Ratio'],'WithMeta'); close(gcf)
    print_FigureToWord(selection,['UNAFF'],'WithMeta'); close(gcf)
    print_FigureToWord(selection,['AFF'],'WithMeta'); close(gcf)
    selection.InsertBreak;
    

end

function s_Sort = sort_S(s,sort_Qty,sortField)

    [~,ind] = sort( s.(sort_Qty).(sortField) );

    fN = fieldnames(s);
    
    for n=1:length(fN)
       if istable(s.(fN{n}))
           s_Sort.(fN{n}) = s.(fN{n})(ind,:); 
       elseif iscell(s.(fN{n}))
           s_Sort.(fN{n}) = s.(fN{n})(ind);
       end
    end
   
end

function s = clean_S(s)

    fN = fieldnames(s);
    
    for n=1:length(fN)
       tmp = s.(fN{n});
       if ~istable(tmp)
           continue;
       end
          
       cN  = tmp.Properties.VariableNames;
       
       for i=1:length(cN)
           switch class(tmp.(cN{i}))
               case 'cell'
                   tmp.(cN{i}) = NaN( size( tmp.(cN{i}) ) );
           end
       end
       
       s.(fN{n}) = tmp;
    end
end

function c_ind = find_Columns(s,vars)
    colNames = s.Ratio.Properties.VariableNames;
    for n=1:length(vars)
       c_ind(n) = find(strcmp(colNames,vars(n)));
    end   
end


function plot_ScatterMatrices(s)
%  
%     vars = {'MVC_Force',...
%             'MVC_Medial_Array',...
%             'MVC_Lateral_Array',...
%             'MVC_BICM',...
%             'MVC_BICL',...
%             'MVC_BRD'};
%         
%     c = find_Columns(s,vars);

    A = s.AFF{:,:};
    U = s.UNAFF{:,:};
    R = (s.Ratio{:,:}-1)*100;
    D = s.Difference{:,:};

    figure;
    hA = tight_subplot(5,9,[0.04,0.03],[0.05,0.05],[0.05,0.05]);
    for n=1:size(D,2)
        axes(hA(n));
        plot(D(:,n),D(:,1),'o','markerfacecolor','b'); hold on;
        mdl{n} = fitlm(D(:,n),D(:,1));
        if n~=37
           set(gca,'yticklabel',[]) 
        end
        set(gca,'xticklabel',[]) 
        pval = mdl{n}.Coefficients.pValue(2);
        rsq  = mdl{n}.Rsquared.Ordinary;
        title(sprintf('p=%0.2f:RSQ=%0.2f',pval,rsq))
%         title(s.Difference.Properties.VariableNames(n))
    end
    
    figure;
    hA = tight_subplot(5,9,[0.04,0.03],[0.05,0.05],[0.05,0.05]);
    for n=1:size(R,2)
        axes(hA(n));
        plot(R(:,n),R(:,1),'o','markerfacecolor','b'); hold on;
        mdl{n} = fitlm(R(:,n),R(:,1));
        if n~=37
           set(gca,'yticklabel',[]) 
        end
        set(gca,'xticklabel',[]) 
        pval = mdl{n}.Coefficients.pValue(2);
        rsq  = mdl{n}.Rsquared.Ordinary;
        title(sprintf('p=%0.2f:RSQ=%0.2f',pval,rsq))
%         title(s.Difference.Properties.VariableNames(n))
    end
    
end

function label_ScatterAxis(hax,vars,txt)
       
    title(txt)
    for n=1:size(hax,1)
       ylabel(hax(n,1),vars{n}) 
       xlabel(hax(end,n),vars{n})
    end

end

function Txt = make_Label(val,tformat,appendTxt)
    for i=1:size(val,1)
        for j=1:size(val,2)
             Txt{i,j} = sprintf(['%' tformat 'f' appendTxt{j}],val(i,j));
        end
    end

end


% %STATS 
%     ind_t = [1:5];
%     mean((R_Sort(ind_t,[4,5])-1)*100)
%     std( (R_Sort(ind_t,[4,5])-1)*100)/sqrt(5)
% 
%     t = R_Sort(ind_t,[4,5])-1;
%     mean(t(:)*100)
%     std( t(:)*100)/sqrt(10)
% 
%     
%     ind_t = [6:10];
%     mean((R_Sort(ind_t,[4,5])-1)*100)
%     std( (R_Sort(ind_t,[4,5])-1)*100)/sqrt(5)
% 
%     t = R_Sort(ind_t,[4,5])-1;
%     mean(t(:)*100)
%     std( t(:)*100)/sqrt(10)
    