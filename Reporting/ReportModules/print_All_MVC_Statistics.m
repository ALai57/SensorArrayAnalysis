
function print_All_MVC_Statistics(selection,allData,options)
   
    allData   = allData((allData.TargetForce=='100%MVC'),:);

    % For readability make temporary variables
    baseDir_SA  = options.SensorArray.BaseDirectory;
    baseDir_SD  = options.SingleDifferential.BaseDirectory;
    varNames_SA = options.Analysis(1).Trial.OutputVariable;   
    varNames_SD = options.Analysis(2).Trial.OutputVariable;
    varNames    = [varNames_SA,varNames_SD];
    
    % Get all trial information and calculate SEMG
    allData     = append_SensorArrayFullFile_2Array(allData,baseDir_SA);
    [SA_EMG, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(1)); 
    
    allData     = append_SingleDifferentialFullFile_2Array(allData,baseDir_SD);
    [SD_EMG, ~] = loop_Over_Trials_FromTable(allData,options.Analysis(2)); 
    
    % Merge SEMG data with all trial information
    SA_EMG         = rename_StructFields(SA_EMG,varNames_SA);
    SD_EMG         = rename_StructFields(SD_EMG,varNames_SD);
    allData        = merge_Data(allData,SA_EMG,options);
    allData        = merge_Data(allData,SD_EMG,options);
    MVC            = reduce_RedundantData(allData,varNames);   
    MVC.AllData_SA = MVC{:,end-6:end-5};
    
    SA_MVC = varfun(@mean,MVC,'InputVariables',{'AllData_SA','MedialArray_SEMG','LateralArray_SEMG'},...
                              'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SA_MVC = varfun(@mean,SA_MVC,'InputVariables',{'mean_AllData_SA','mean_MedialArray_SEMG','mean_LateralArray_SEMG'},...
                                 'GroupingVariables',{'SID','ArmType','TargetForce','TargetForce_N'});
    SA_MVC.Properties.VariableNames(end-2:end) = {'AllData_SA','MedialArray_MVC','LateralArray_MVC'};
    
    SD_MVC = varfun(@mean,MVC,'InputVariables',{'BICM','BICL','TRI','BRD','BRA'},...
                              'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SD_MVC = varfun(@mean,SD_MVC,'InputVariables',{'mean_BICM','mean_BICL','mean_BRD'},...
                                 'GroupingVariables',{'SID','ArmType','TargetForce','TargetForce_N'});
    SD_MVC.Properties.VariableNames(end-2:end) = {'BICM','BICL','BRD'};
    
    MVC = varfun(@mean,MVC,'InputVariables',{'MedialArray_SEMG','LateralArray_SEMG','BICM','BICL','TRI','BRD','BRA'},...
                              'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    MVC = varfun(@mean,MVC,'InputVariables',{'mean_MedialArray_SEMG','mean_LateralArray_SEMG','mean_BICM','mean_BICL','mean_BRD'},...
                                 'GroupingVariables',{'SID','ArmType','TargetForce','TargetForce_N'});
    MVC.Properties.VariableNames(end-4:end) = {'MedialArray_SEMG','LateralArray_SEMG','BICM','BICL','BRD'};
    
    %Plot
    options.Plot = get_Plot_Options_SA_All_AbsoluteUnits();
    create_Figure_FromTable(SA_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SA_Medial_AbsoluteUnits();
    create_Figure_FromTable(SA_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SA_Lateral_AbsoluteUnits();
    create_Figure_FromTable(SA_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SD_BICM_AbsoluteUnits();
    create_Figure_FromTable(SD_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SD_BICL_AbsoluteUnits();
    create_Figure_FromTable(SD_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_SD_BRD_AbsoluteUnits();
    create_Figure_FromTable(SD_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
    options.Plot = get_Plot_Options_F_AbsoluteUnits();
    create_Figure_FromTable(SD_MVC,options)
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    
        
%     stats = reformat_Table(SA_MVC,SD_MVC);
    
    stats = reformat_Table(MVC);
    selection.TypeText(['Statistics .' char(13)]) 
    print_FigureToWord(selection,['All Subjects'],'WithMeta')
    close(gcf);
    print_TableToWord(selection,stats(:,1:7)) 
    selection.InsertBreak;
    
    
    % PLOT NORMALIZED EMG
   
end


function PlotOptions = get_Plot_Options_F_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'TargetForce_N'};
    PlotOptions.YLabel          = 'Target Force (N)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_SA_All_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'AllData_SA'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end

function PlotOptions = get_Plot_Options_SA_Medial_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MedialArray_MVC'};
    PlotOptions.YLabel          = 'RMS EMG (Medial Array)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end

function PlotOptions = get_Plot_Options_SA_Lateral_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'LateralArray_MVC'};
    PlotOptions.YLabel          = 'RMS EMG (Lateral Sensor Array)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end

function PlotOptions = get_Plot_Options_SD_BICM_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BICM'};
    PlotOptions.YLabel          = 'RMS EMG (BICM SD)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end

function PlotOptions = get_Plot_Options_SD_BICL_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BICL'};
    PlotOptions.YLabel          = 'RMS EMG (BICL SD)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end

function PlotOptions = get_Plot_Options_SD_BRD_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'SID'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'ArmType'};
    PlotOptions.XLabel          = 'Arm Type (Aff/Con)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BRD'};
    PlotOptions.YLabel          = 'RMS EMG (BRA SD)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All Subjects'] ;  
    PlotOptions.TitleSize       = 16; 
end





function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits()

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
    PlotOptions.Response        = {'AllData'};
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
    	allData = [allData(:,1:end-1),SEMG(:,4:end-1)];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-length(varNames)+1:end) = varNames;
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


function out = reformat_Table(MVC)%(MVC_SA,MVC_SD)

    subjs = unique(MVC.SID);
    aff   = MVC.ArmType == 'AFF';
    for n=1:length(subjs)
        i1 = MVC.SID == subjs(n);

        MVC_F_Aff    = MVC.TargetForce_N(i1&aff);
        MVC_F_Contra = MVC.TargetForce_N(i1&~aff);
        MVC_F_Ratio  = MVC_F_Aff./MVC_F_Contra;

        MVC_SA_Medial_Aff    = MVC.MedialArray_SEMG(i1&aff,:);
        MVC_SA_Medial_Contra = MVC.MedialArray_SEMG(i1&~aff,:);
        MVC_SA_Medial_Ratio  = MVC_SA_Medial_Aff./MVC_SA_Medial_Contra;
        
        MVC_SA_Lateral_Aff    = MVC.LateralArray_SEMG(i1&aff,:);
        MVC_SA_Lateral_Contra = MVC.LateralArray_SEMG(i1&~aff,:);
        MVC_SA_Lateral_Ratio  = MVC_SA_Lateral_Aff./MVC_SA_Lateral_Contra;
        
        MVC_SD_BICM_Aff    = MVC.BICM(i1&aff);
        MVC_SD_BICM_Contra = MVC.BICM(i1&~aff);
        MVC_SD_BICM_Ratio  = MVC_SD_BICM_Aff./MVC_SD_BICM_Contra;

        MVC_SD_BICL_Aff    = MVC.BICL(i1&aff);
        MVC_SD_BICL_Contra = MVC.BICL(i1&~aff);
        MVC_SD_BICL_Ratio  = MVC_SD_BICL_Aff./MVC_SD_BICL_Contra;

        MVC_SD_BRD_Aff    = MVC.BRD(i1&aff);
        MVC_SD_BRD_Contra = MVC.BRD(i1&~aff);
        MVC_SD_BRD_Ratio  = MVC_SD_BRD_Aff./MVC_SD_BRD_Contra;

        out{n,1} = char(subjs(n));
        out{n,2} = MVC_F_Ratio;
        out{n,3} = MVC_SA_Medial_Ratio;
        out{n,4} = MVC_SA_Lateral_Ratio;
        out{n,5} = MVC_SD_BICM_Ratio;
        out{n,6} = MVC_SD_BICL_Ratio;
        out{n,7} = MVC_SD_BRD_Ratio;
        out{n,9} = MVC_F_Aff;
        out{n,10} = MVC_F_Contra;
        out{n,11} = MVC_SA_Medial_Aff;
        out{n,12} = MVC_SA_Medial_Contra;
        out{n,13} = MVC_SA_Lateral_Aff;
        out{n,14} = MVC_SA_Lateral_Contra;
        out{n,15} = MVC_SD_BICM_Aff;
        out{n,16} = MVC_SD_BICM_Contra;
        out{n,17} = MVC_SD_BICL_Aff;
        out{n,18} = MVC_SD_BICL_Contra;
        out{n,19} = MVC_SD_BRD_Aff;
        out{n,20} = MVC_SD_BRD_Contra;
        
    end
    
    header = {'SID','MVC_Ratio', 'SA_Medial_Ratio', 'SA_Lateral_Ratio','BICM_Ratio','BICL_Ratio', 'BRD_Ratio','E',...
              'MVC_Aff','MVC_Contra','SA_Medial_Aff','SA_Medial_Contra','SA_Lateral_Aff','SA_Lateral_Contra','BICM_Aff','BICM_Contra' ,'BICL_Aff','BICL_Contra','BRD_Aff','BRD_Contra'};
    
    out = cell2table(out);
    out.Properties.VariableNames = header;
    figure; 
    plot(out.MVC_Ratio,out.SA_Medial_Ratio,'.','markersize',20); hold on;
    plot(out.MVC_Ratio,out.SA_Lateral_Ratio,'.','markersize',20);
    plot(out.MVC_Ratio,out.BICM_Ratio,'.','markersize',20);
    plot(out.MVC_Ratio,out.BICL_Ratio,'.','markersize',20);
    plot(out.MVC_Ratio,out.BRD_Ratio,'.','markersize',20);
    plot(out.MVC_Ratio,out.MVC_Ratio,'-k','linewidth',2);

    xlabel('Reduction in MVC','fontweight','bold','fontsize',16);
    ylabel('Reduction in EMG','fontweight','bold','fontsize',16);
    xlim([0 2])
    ylim([0 2])
    legend('Array Medial','Array Lateral','Single Diff BICM','Single Diff BICL','Single Diff BRD')
    text(0,-0.2,'UNAFF Greater Force')
    text(1.6,-0.2,'AFF Greater Force')
    text(-0.2,-0.2,'UNAFF Greater EMG','rotation',90)
    text(-0.2,1.5,'AFF Greater EMG','rotation',90)
    title('All Subjects')
end

%     varNames = options.Analysis(1).Trial.OutputVariable;
%     SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce_N','TargetForce'});
%     SEMG.Properties.VariableNames(end-1:end) = varNames;


%     SEMG         = reduce_RedundantData(allData,varNames);
%     
%     SA_EMG.AllData = SA_EMG{:,end-1:end};
%     
% %     SD_EMG         = rename_StructFields(SA_EMG,varNames);
% %     SA_EMG         = reduce_RedundantData(allData,varNames);
%     SA_EMG.AllData = SA_EMG{:,end-1:end};