



function print_HeatmapComparison_MU_FiringRates(selection,s,options)

    s      = clean_S(s);
    s_Sort = sort_S(s,'Ratio','MVC_Force');
    
%     plot_Differences_1(s_Sort)
%     selection.TypeText(['Difference in MU Firing' char(13)])  
%     print_FigureToWord(selection,'WithMeta')
%     selection.InsertBreak;
    
    plot_Differences_2(s_Sort)
    print_FigureToWord(selection,['Difference in MU Firing' char(13)],'WithMeta')
    close(gcf)
%     plot_AFF_UNAFF_1(s_Sort)
%     selection.TypeText(['Affected and Unaffected arms' char(13)])  
%     print_FigureToWord(selection,'WithMeta')
%     selection.InsertBreak;
    
    plot_AFF_UNAFF_2(s_Sort)
    print_FigureToWord(selection,['Affected and unaffected arms' char(13)],'WithMeta')
    close(gcf)
    selection.InsertBreak;
    
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


function    plot_ScatterMatrices(s)
    
    vars = {'MVC_Force','BothArray_Mean_MU_Firing_Rate'};
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    R = (s.Ratio{:,c}-1)*100;
    D = s.Difference{:,c};

    figure; [S,AX,BigAx,H,HAx] = plotmatrix(A);
    label_ScatterAxis(AX,{'MVC Force (N)','Mean Firing Rate (pps)'},'AFFECTED')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(U)
    label_ScatterAxis(AX,{'MVC Force (N)','Mean Firing Rate (pps)'},'UNAFFECTED')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(R) 
    label_ScatterAxis(AX,{'\Delta MVC Force (%)','\Delta Mean Firing Rate (%)'},'Ratio')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(D)
    label_ScatterAxis(AX,{'\Delta MVC Force (N)','\Delta Mean Firing Rate (pps)'},'Difference')
end

function label_ScatterAxis(hax,vars,txt)
       
    title(txt)
    for n=1:size(hax,1)
       ylabel(hax(n,1),vars{n}) 
       xlabel(hax(end,n),vars{n})
    end

end

function plot_AFF_UNAFF_1(s)
    
    vars = {'MVC_Force','BothArray_Mean_MU_Firing_Rate'};
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    SID = s.SID;
    
    ATxt = make_Label(A,'2.0',{'N','pps'});
    UTxt = make_Label(U,'2.0',{'N','pps'});

    mxA  = max(abs(A));
    mxU  = max(abs(U));
    mxA  = repmat(mxA,size(A,1),1);
    mxU  = repmat(mxU,size(U,1),1);
    
    % Relative - Diff and ratio
    figure;
    subplot(1,2,1);
    hM(1) = custom_heatmap(A./mxA, vars, SID, ...
                    ATxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('AFF')
    
    subplot(1,2,2);
    hM(2) = custom_heatmap(U./mxU, vars, SID, ...
                    UTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('UNAFF')
   
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


function plot_Differences_1(s)
    
    vars = {'MVC_Force','BothArray_Mean_MU_Firing_Rate'};
    
    c = find_Columns(s,vars);
    R = (s.Ratio{:,c}-1)*100;
    D = s.Difference{:,c};
    SID = s.SID;
    
    RTxt = make_Label(R,'2.0',{'%%','%%'});
    DTxt = make_Label(D,'2.0',{'N','pps'});

    mxR   = max(abs(R));
    mxD  = max(abs(D));
    mxR   = repmat(mxR,size(R,1),1);
    mxD  = repmat(mxD,size(D,1),1);
    
    % Relative - Diff and ratio
    figure;
    subplot(1,2,1);
    hM(1) = custom_heatmap(R./mxR, vars, SID, ...
                    RTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta relative')
    
    subplot(1,2,2);
    hM(2) = custom_heatmap(D./mxD, vars, SID, ...
                    DTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta absolute')
   
end

function plot_Differences_2(s)
    
    vars = {'MVC_Force','BothArray_Mean_MU_Firing_Rate'};
    
    c = find_Columns(s,vars);
    R = s.Ratio{:,c};
    D = s.Difference{:,c};
    P = s.Ttest2_p{:,c};
    SID = s.SID;
    
    Force = [(R(:,1)-1)*100,D(:,1)];
    FR    = [(R(:,2)-1)*100,D(:,2)];
    
    ForceTxt = make_Label(Force,'2.0',{'%%','N'});
    FRTxt    = make_Label(FR,'2.0',{'%%','pps'});
    PTxt    = make_Label(P(:,2),'0.2',{''});
    
    mxF   = max(abs(Force));
    mxFR  = max(abs(FR));
    mxF   = repmat(mxF,size(Force,1),1);
    mxFR  = repmat(mxFR,size(FR,1),1);
    
    figure;
    subplot(1,5,1:2);
    hM(1) = custom_heatmap(Force./mxF, {'Relative','Absolute'}, SID, ...
                    ForceTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC Forces')
    
    subplot(1,5,3:4);
    hM(2) = custom_heatmap(FR./mxFR, {'Relative','Absolute'}, [], ...
                   FRTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta Mean Firing rate')
    
    subplot(1,5,5);
    hM(3) = custom_heatmap(P(:,2)/0.05, {'           p'}, [], ...
                    PTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('p value')
    
   
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
    