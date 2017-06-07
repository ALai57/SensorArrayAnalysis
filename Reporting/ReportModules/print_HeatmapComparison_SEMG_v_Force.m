



function print_HeatmapComparison_SEMG_v_Force(selection,s,options)

    s      = clean_S(s);
    s_Sort = sort_S(s,'Ratio','MVC_Force');
    
    plot_AFF_UNAFF_1(s_Sort)
    print_FigureToWord(selection,['Single Differential EMG v Force regessions' char(13)],'WithMeta')
    close(gcf)
    
    plot_Differences_2(s_Sort)
    print_FigureToWord(selection,['Difference in Regression Slope: (EMG v. Force)' char(13)],'WithMeta')
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


function plot_ScatterMatrices(s)
    
    vars = {'MVC_Force','BICM_v_Target_Force','BICL_v_Target_Force','BRD_v_Target_Force'};
    
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
    
    vars = {'MVC_Force','BICM_v_Target_Force','BICL_v_Target_Force','BRD_v_Target_Force'};
    
  
    
    c = find_Columns(s,vars);
    A = s.AFF{:,c};
    U = s.UNAFF{:,c};
    AP = s.AFF_p{:,c(2:end)};
    UP = s.UNAFF_p{:,c(2:end)};
    SID = s.SID;
    
    A(:,2:end) = A(:,2:end)*100;
    U(:,2:end) = U(:,2:end)*100;
    
    ATxt = make_Label(A,'3.0',{'N',' e-5',' e-5',' e-5'});
    UTxt = make_Label(U,'3.0',{'N',' e-5',' e-5',' e-5'});
    APTxt = make_Label(AP,'0.2',{'','',''});
    UPTxt = make_Label(UP,'0.2',{'','',''});
    
    mxA  = max(abs(A)); mxA(2:end) = max(mxA(2:end));
    mxU  = max(abs(U)); mxU(2:end) = max(mxU(2:end));
    mxA  = repmat(mxA,size(A,1),1);
    mxU  = repmat(mxU,size(U,1),1);
    
    % Relative - Diff and ratio
    figure;
    subplot(2,5,1:4);
    hM(1) = custom_heatmap(A./mxA, {'MVC Force','Slope (BICM)','Slope (BICL)','Slope (BRD)'}, SID, ...
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
    hM(3) = custom_heatmap(U./mxU,  {'MVC Force','Slope (BICM)','Slope (BICL)','Slope (BRD)'}, SID, ...
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
    
    set(gcf,'position',[ 2    42   680   642])
end

function plot_Differences_2(s)
    
    vars = {'MVC_Force','BICM_v_Target_Force','BICL_v_Target_Force','BRD_v_Target_Force'};
        
    c = find_Columns(s,vars);
    R = s.Ratio{:,c};
    D = s.Difference{:,c};
    P = s.Ttest2_p{:,c(2:end)};
    SID = s.SID;
    
    Force = [(R(:,1)-1)*100,D(:,1)];
    BICM  = [(R(:,2)-1)*100,D(:,2)*100];
    BICL  = [(R(:,3)-1)*100,D(:,3)*100];
    BRD   = [(R(:,4)-1)*100,D(:,4)*100];
    
    ForceTxt = make_Label(Force,'2.0',{'%%','N'});
    BICMTxt  = make_Label(BICM ,'2.0',{'%%',' e-5'});
    BICLTxt  = make_Label(BICL ,'2.0',{'%%',' e-5'});
    BRDTxt   = make_Label(BRD ,'2.0',{'%%',' e-5'});
    PTxt     = make_Label(P,'0.2',{'','',''});
    
    mxF   = max(abs(Force));
    mxF   = repmat(mxF,size(Force,1),1);
    mxBICM  = max(abs(BICM));
    mxBICM  = repmat(mxBICM,size(BICM,1),1);
    mxBICL  = max(abs(BICL));
    mxBICL  = repmat(mxBICL,size(BICL,1),1);
    mxBRD  = max(abs(BRD));
    mxBRD  = repmat(mxBRD,size(BRD,1),1);
    
    figure;
    subplot(1,11,1:2);
    hM(1) = custom_heatmap(Force./mxF, {'Relative','Absolute'}, SID, ...
                    ForceTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta MVC Forces')
    
    subplot(1,11,3:4);
    hM(2) = custom_heatmap(BICM./mxBICM, {'Relative','Absolute'}, [], ...
                   BICMTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta Slope (BICM)')
    
    subplot(1,11,5);
    hM(3) = custom_heatmap(P(:,1)/0.05, {'           p'}, [], ...
                    PTxt(:,1), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('p value')
    
    subplot(1,11,6:7);
    hM(2) = custom_heatmap(BICL./mxBICL, {'Relative','Absolute'}, [], ...
                   BICLTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta Slope (BICL)')
    
    subplot(1,11,8);
    hM(3) = custom_heatmap(P(:,2)/0.05, {'           p'}, [], ...
                    PTxt(:,2), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('p value')
    
    subplot(1,11,9:10);
    hM(2) = custom_heatmap(BRD./mxBRD, {'Relative','Absolute'}, [], ...
                   BRDTxt, 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('\Delta Slope (BRD)')
    
    subplot(1,11,11);
    hM(3) = custom_heatmap(P(:,3)/0.05, {'           p'}, [], ...
                    PTxt(:,3), 'Colormap', 'money2', ...
                    'UseFigureColormap',false,...
                    'ShowAllTicks',1,'TickAngle',25,...
                    'NaNColor',[0 0 0],'MinColorValue',-1,'MaxColorValue',1);
    title('p value')
    
   set(gcf,'position',[-3   131   993   342])
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
    