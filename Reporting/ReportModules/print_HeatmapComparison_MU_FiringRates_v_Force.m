



function print_HeatmapComparison_MU_FiringRates_v_Force(selection,s,options)

    s      = clean_S(s);
    s_Sort = sort_S(s,'Ratio','MVC_Force');
    
    plot_AFF_UNAFF_1(s_Sort)
    print_FigureToWord(selection,['FR v Force regessions' char(13)],'WithMeta')
    close(gcf)
    
    plot_Differences_2(s_Sort)
    print_FigureToWord(selection,['Difference in Regression Slope: (FR v. Force)' char(13)],'WithMeta')
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
    
    vars = {'MVC_Force','BothArray_Firing_Rate_v_Target_Force'};
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    R = (s.Ratio{:,c}-1)*100;
    D = s.Difference{:,c};

    figure; [S,AX,BigAx,H,HAx] = plotmatrix(A);
    label_ScatterAxis(AX,{'MVC Force (N)','Slope (pps/N)'},'AFFECTED')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(U)
    label_ScatterAxis(AX,{'MVC Force (N)','Slope (pps/N)'},'UNAFFECTED')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(R) 
    label_ScatterAxis(AX,{'\Delta MVC Force (%)','\Delta Slope (pps/N)'},'Ratio')
    figure; [S,AX,BigAx,H,HAx] = plotmatrix(D)
    label_ScatterAxis(AX,{'\Delta MVC Force (N)','\Delta Slope (pps/N)'},'Difference')
end

function label_ScatterAxis(hax,vars,txt)
       
    title(txt)
    for n=1:size(hax,1)
       ylabel(hax(n,1),vars{n}) 
       xlabel(hax(end,n),vars{n})
    end

end

function plot_AFF_UNAFF_1(s)
    
    vars = {'MVC_Force','BothArray_Firing_Rate_v_Target_Force'};
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    AP = s.AFF_p{:,c(2)};
    UP = s.UNAFF_p{:,c(2)};
    SID = s.SID;
    
    A(:,2) = A(:,2)*100;
    U(:,2) = U(:,2)*100;
    
    ATxt = make_Label(A,'3.0',{'N',' pps/100N'});
    UTxt = make_Label(U,'3.0',{'N',' pps/100N'});
    APTxt = make_Label(AP,'0.2',{''});
    UPTxt = make_Label(UP,'0.2',{''});
    
    mxA  = max(abs(A));
    mxU  = max(abs(U));
    mxA  = repmat(mxA,size(A,1),1);
    mxU  = repmat(mxU,size(U,1),1);
    
    % Relative - Diff and ratio
    figure;
    subplot(2,5,1:4);
    hM(1) = custom_heatmap(A./mxA, {'MVC Force','Slope (FR v Force)'}, SID, ...
                    ATxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',0,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('AFF')
    subplot(2,5,5);
    hM(2) = custom_heatmap(AP/0.05, {'p'}, [], ...
                    APTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',0,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('Slope p')
    
    
    subplot(2,5,6:9);
    hM(3) = custom_heatmap(U./mxU,  {'MVC Force','Slope (FR v Force)'}, SID, ...
                    UTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',0,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('UNAFF')
    subplot(2,5,10);
    hM(2) = custom_heatmap(UP/0.05, {'p'}, [], ...
                    UPTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',0,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('Slope p')
    
    set(gcf,'position',[2    42   463   642])
end

function plot_Differences_2(s)
    
    vars = {'MVC_Force','BothArray_Firing_Rate_v_Target_Force'};
    
    c = find_Columns(s,vars);
    R = s.Ratio{:,c};
    D = s.Difference{:,c};
    P = s.Ttest2_p{:,c(2)};
    SID = s.SID;
    
    Force = [(R(:,1)-1)*100,D(:,1)];
    FRvF  = [(R(:,2)-1)*100,D(:,2)*100];
    
    ForceTxt = make_Label(Force,'2.0',{'%%','N'});
    FRTxt    = make_Label(FRvF ,'2.0',{'%%','pps/100N'});
    PTxt     = make_Label(P,'0.2',{''});
    
    mxF   = max(abs(Force));
    mxFR  = max(abs(FRvF));
    mxF   = repmat(mxF,size(Force,1),1);
    mxFR  = repmat(mxFR,size(FRvF,1),1);
    
    figure;
    subplot(1,5,1:2);
    hM(1) = custom_heatmap(Force./mxF, {'Relative','Absolute'}, SID, ...
                    ForceTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC Forces')
    
    subplot(1,5,3:4);
    hM(2) = custom_heatmap(FRvF./mxFR, {'Relative','Absolute'}, [], ...
                   FRTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta Slope (pps/N)')
    
    subplot(1,5,5);
    hM(3) = custom_heatmap(P/0.05, {'           p'}, [], ...
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
    