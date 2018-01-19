
function print_All_SingleDifferential_SEMG_v_SEMG_Normalized(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate SEMG from Single Differential Electrodes
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
    mm = {'BICL','BICM';...
          'BRD','BICM';...
          'BRD','BICL'};
      
    at = {'AFF','UNAFF'};
    
%     SEMG.ArmType = SEMG.ArmSide;
%     at = {'R','L'};
     
    Norm_SEMG  = normalize_EMG(SEMG,[5,7:11]+1);

    
    
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
                                    
   
    xL = [0 1.5];
    yL = xL;
                                 
    for n=1:size(mm,1)
        i = Norm_SEMG.ArmType == at{1};
        figure;
        subplot(2,2,1)
        plotg(Norm_SEMG.(mm{n,1})(i),...
              Norm_SEMG.(mm{n,2})(i),...
              Norm_SEMG.SID(i),...
              'o');
        title(at{1})
        plot([0 1], [0 1],'k')
        xlim(xL)
        ylim(yL)
        subplot(2,2,2)
        plotg(Norm_SEMG.(mm{n,1})(~i),...
              Norm_SEMG.(mm{n,2})(~i),...
              Norm_SEMG.SID(~i),...
              'o');
        title(at{2})
        plot([0 1], [0 1],'k')
        xlim(xL)
        ylim(yL)

        subplot(2,2,3)
        plotg(Norm_SEMG.(mm{n,1})(i),...
              Norm_SEMG.(mm{n,2})(i),...
              Norm_SEMG.SID(i),...
              '-o');
        title(at{1})
        plot([0 1], [0 1],'k')
        xlim(xL);
        ylim(yL)
        xlabel([mm{n,1} ' (%MVC)'])
        ylabel([mm{n,2} ' (%MVC)'])
        subplot(2,2,4)
        plotg(Norm_SEMG.(mm{n,1})(~i),...
              Norm_SEMG.(mm{n,2})(~i),...
              Norm_SEMG.SID(~i),...
              '-o');
        title(at{2})
        plot([0 1], [0 1],'k')
        xlim(xL)
        ylim(yL)
        
%         i = Norm_SEMG_Mean.ArmType == at{1};
%         subplot(2,2,3)
%         plotg(Norm_SEMG_Mean.(['mean_' mm{n,1}])(i),...
%               Norm_SEMG_Mean.(['mean_' mm{n,2}])(i),...
%               Norm_SEMG_Mean.SID(i),...
%               '-o');
%         title(at{1})
%         plot([0 1], [0 1],'k')
%         xlim(xL);
%         ylim(yL)
%         xlabel([mm{n,1} ' (%MVC)'])
%         ylabel([mm{n,2} ' (%MVC)'])
%         subplot(2,2,4)
%         plotg(Norm_SEMG_Mean.(['mean_' mm{n,1}])(~i),...
%               Norm_SEMG_Mean.(['mean_' mm{n,2}])(~i),...
%               Norm_SEMG_Mean.SID(~i),...
%               '-o');
%         title(at{2})
%         plot([0 1], [0 1],'k')
%         xlim(xL)
%         ylim(yL)
    end
 
    % Print statistics
    for n=1:length(mm)
        print_FigureToWord(selection,mm{length(mm)-n+1},'WithMeta') 
        selection.InsertBreak;
        close(gcf);
    end
   
end


function PlotOptions = get_Plot_Options_RegressionComparison_Normalized

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.CompareBy       = {'ArmType'};
%     PlotOptions.ColorBy         = {'ArmType'};
%     PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.Predictor       = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'BICM', 'BICL','TRI','BRD','BRA'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
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
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','ArmSide','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-4:end) = varNames;
end

function  statOut = reformat_Struct(structIn)
    nSubjs = length(structIn);
    
    for n=1:nSubjs
       statOut{n,1} = structIn(n).SID;
       statOut{n,2} = structIn(n).fTest.p;
       statOut{n,3} = structIn(n).tTest(1).Estimate(1);
       statOut{n,4} = structIn(n).tTest(1).Estimate(2);
       statOut{n,5} = structIn(n).tTest(1).p;
       statOut{n,6} = structIn(n).tTest(1).DF;
       statOut{n,7} = structIn(n).tTest(2).p;
       statOut{n,8} = structIn(n).tTest(2).DF;
    end
    header  = {'SID','F_pVal','b1_AFF','b1_UNAFF','t_pVal','t_DF','t_pVal','t_DF'};
    statOut = [header;statOut];
end


