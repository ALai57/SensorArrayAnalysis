
function print_Subject_SingleDifferential_SEMG_v_Force_Normalized(selection,allData,options)
   
  % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate Single Differential EMG
    calc_SD_EMG_Fcn = @(trial_Data,options)calculate_SingleDifferential_SEMG_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [SEMG, ~] = apply_To_Trials_In_DataTable(allData,...
                                             calc_SD_EMG_Fcn,...
                                             options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG       = rename_StructFields(SEMG,varNames);
    allData    = merge_Data(allData,SEMG,options);
    SEMG       = reduce_RedundantData(allData,varNames);
    
    %Control vs stroke. Change here.
    mm = {'TargetForce_N','BICM';...
          'TargetForce_N','BICL';...
          'TargetForce_N','BRD'};
      
    at = {'AFF','UNAFF'};
    
%     SEMG.ArmType = SEMG.ArmSide;
%     at = {'R','L'};
     
    Norm_SEMG  = normalize_EMG(SEMG,[5,7:11]);

    
    
    % Create plot - with MVC in regression
    Norm_SEMG_Mean = varfun(@mean,Norm_SEMG,...
                             'InputVariables',...
                                    {'BICM',...
                                     'BICL',...
                                     'TRI',...
                                     'BRD',...
                                     'BRA'},...
                             'GroupingVariables',...
                                    {'SID',...
                                     'ArmType',...
                                     'TargetForce',...
                                     'TargetForce_N'});
                                    
   
    figure;
    for n=1:size(mm,1)
        
        subplot(size(mm,1),2,2*(n-1)+1);
        i = Norm_SEMG.ArmType == at{1};
        plotg(Norm_SEMG.TargetForce_N(i),...
              Norm_SEMG.(mm{n,2})(i),...
              Norm_SEMG.SID(i),...
              '-o');
        title(at{1})
        plot([0 1], [0 1],'k')
        xlim([0 1.1]);
        ylim([0 1.5])
        xlabel([mm{n,1} ' (%MVC)'])
        ylabel([mm{n,2} ' (%MVC)'])
        
        subplot(size(mm,1),2,2*n);
        plotg(Norm_SEMG.TargetForce_N(~i),...
              Norm_SEMG.(mm{n,2})(~i),...
              Norm_SEMG.SID(~i),...
              '-o');
        title(at{2})
        plot([0 1], [0 1],'k')
        ylim([0 1.1])
        xlim([0 1.5])
        
%          subplot(size(mm,1),2,2*(n-1)+1);
%         i = Norm_SEMG_Mean.ArmType == at{1};
%         plotg(Norm_SEMG_Mean.TargetForce_N(i),...
%               Norm_SEMG_Mean.(['mean_' mm{n,2}])(i),...
%               Norm_SEMG_Mean.SID(i),...
%               '-o');
%         title(at{1})
%         plot([0 1], [0 1],'k')
%         xlim([0 1.1]);
%         ylim([0 1.5])
%         xlabel([mm{n,1} ' (%MVC)'])
%         ylabel([mm{n,2} ' (%MVC)'])
%         
%         subplot(size(mm,1),2,2*n);
%         plotg(Norm_SEMG_Mean.TargetForce_N(~i),...
%               Norm_SEMG_Mean.(['mean_' mm{n,2}])(~i),...
%               Norm_SEMG_Mean.SID(~i),...
%               '-o');
%         title(at{2})
%         plot([0 1], [0 1],'k')
%         ylim([0 1.1])
%         xlim([0 1.5])
    end
 
    set(gcf,'position',[403    95   560   571])
    
    % Print statistics
    print_FigureToWord(selection,mm{length(mm)-n+1},'WithMeta') 
    selection.InsertBreak;
    close(gcf);

   
   
end



function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BICM', 'BICL','TRI','BRD','BRA'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function SEMG = rename_StructFields(SEMG,varNames)
    for n=1:length(varNames) 
        name = varNames{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
end

function allData = merge_Data(allData,SEMG,options)
    % Merge data
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);
    
    varNames = options.Analysis(1).Trial.OutputVariable;
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
        allData = [allData,SEMG(:,3+[1:length(varNames)])];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-4:end) = varNames;
end




%     SID = char(SEMG.SID(1));
%     options.Plot = get_Plot_Options_AbsoluteUnits();
%     options.Plot.YVar = {'BICM'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BICM'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BICL'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BICL'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'TRI'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' TRI'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BRD'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BRD'],'WithMeta')
%     close(gcf);
%     
%     options.Plot.YVar = {'BRA'};
%     create_Figure_FromTable(SEMG,options)
%     print_FigureToWord(selection,['Subject :' SID ' BRA'],'WithMeta')
%     close(gcf);