

function print_HeatmapComparison_All(selection,s,options)

    s      = clean_S(s);
    s_Sort = sort_S(s,'Ratio','MVC_Force');
    
    plot_Differences_2(s_Sort)
    print_FigureToWord(selection,['Differences' char(13)],'WithMeta')
    close(gcf)

    
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
 
    vars = {'MVC_Force',...
            'MVC_Medial_Array',...
            'MVC_Lateral_Array',...
            'MVC_BICM',...
            'MVC_BICL',...
            'MVC_BRD'};
        
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    R = (s.Ratio{:,c}-1)*100;
    D = s.Difference{:,c};

    figure; [S,AX,BigAx,H,HAx] = plotmatrix(A);
    label_ScatterAxis(AX,{'MVC Force (N)',...
                          'Medial Array',...
                          'Lateral Array',...
                          'BICM',...
                          'BICL',...
                          'BRD'},'AFFECTED')
    set(gcf,'position',[ 223    58   862   609])
    
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(U)
    label_ScatterAxis(AX,{'MVC Force (N)',...
                          'Medial Array',...
                          'Lateral Array',...
                          'BICM',...
                          'BICL',...
                          'BRD'},'UNAFFECTED') 
    set(gcf,'position',[ 223    58   862   609]) 
    
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(R) 
    label_ScatterAxis(AX,{'\Delta MVC Force (%)',...
                          '\Delta Medial Array (%)',...
                          '\Delta Lateral Array (%)',...
                          '\Delta BICM (%)',...
                          '\Delta BICL (%)',...
                          '\Delta BRD (%)'},'Ratio')  
    set(gcf,'position',[ 223    58   862   609])  
    
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(D)
    label_ScatterAxis(AX,{'\Delta MVC Force (N)',...
                          '\Delta Medial Array',...
                          '\Delta Lateral Array',...
                          '\Delta BICM',...
                          '\Delta BICL',...
                          '\Delta BRD'},'Difference') 
    set(gcf,'position',[ 223    58   862   609])
end

function label_ScatterAxis(hax,vars,txt)
       
    title(txt)
    for n=1:size(hax,1)
       ylabel(hax(n,1),vars{n}) 
       xlabel(hax(end,n),vars{n})
    end

end

function plot_AFF_UNAFF_2(s)
    
    vars = {'MVC_Force','BothArray_Mean_MU_Firing_Rate'};
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    P = s.Ttest2_p{:,c};
    SID = s.SID;
    
    F = [A(:,1),U(:,1)];
    FR = [A(:,2),U(:,2)];
    
    FTxt  = make_Label(F,'2.0',{'N','N'});
    FRTxt = make_Label(FR,'2.0',{'pps','pps'});
    PTxt  = make_Label(P(:,2),'0.2',{''});
    
    mxF   = max( abs(F(:)) );
    mxFR  = max( abs(FR(:)) );
    mxF   = repmat(mxF,size(F));
    mxFR  = repmat(mxFR,size(FR));
    
    % Relative - Diff and ratio
    figure;
    subplot(1,5,1:2);
    hM(1) = custom_heatmap(F./mxF, {'AFF','UNAFF'}, SID, ...
                    FTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('Force')
    
    subplot(1,5,3:4);
    hM(2) = custom_heatmap(FR./mxFR, {'AFF','UNAFF'}, [], ...
                    FRTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',0,'MaxColorValue',1);
    title('Mean Firing Rate')
    
    subplot(1,5,5);
    hM(3) = custom_heatmap(P(:,2)/0.05, {'           p'}, [], ...
                    PTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('p value')
end


function plot_Differences_2(s)
      
    c = 1:size(s.Ratio,2);
    R = s.Ratio{:,c};
    D = s.Difference{:,c};
    SID = s.SID;
    
    Rel = (R-1)*100;
    Abs = D;
    Abs(:,2:end) = Abs(:,2:end)*1000;
    
    AbsTxt = make_Label(Abs,'2.0',{'N',...
                                   'e-3',...
                                   'e-3',...
                                   'e-3',...
                                   'e-3',...
                                   'e-3'});
    RelTxt = make_Label(Rel,'2.0',{'%%',...
                                   '%%',...
                                   '%%',...
                                   '%%',...
                                   '%%',...
                                   '%%'});
    
    mxRel  = max(abs(Rel));
    mxAbs  = max(abs(Abs));
    mxRel  = repmat(mxRel,size(Abs,1),1);
    mxAbs  = repmat(mxAbs,size(Rel,1),1);
    
    figure;
    subplot(2,5,1);
    hM(1) = custom_heatmap(Abs(:,1)./mxAbs(:,1),...
                    {'     Force (N)'}, SID, ...
                    AbsTxt(:,1), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC Forces')
    
    subplot(2,5,2:5);
    hM(2) = custom_heatmap(Abs(:,2:end)./mxAbs(:,2:end),...
                    {'Medial Array','Lateral Array','BICM','BICL','BRD'},...
                    [], ...
                   AbsTxt(:,2:end), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC EMG')
    
    
    
    subplot(2,5,6);
    hM(3) = custom_heatmap(Rel(:,1)./mxRel(:,1),...
                    {'           Force'}, SID, ...
                    RelTxt(:,1), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC Forces')
    
    subplot(2,5,7:10);
    hM(4) = custom_heatmap(Rel(:,2:end)./mxRel(:,2:end),...
                    {'Medial Array','Lateral Array','BICM','BICL','BRD'},...
                    [], ...
                   RelTxt(:,2:end), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC EMG')
    
    
    set(gcf,'position',[2    42   681   642])
   
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
    