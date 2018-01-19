

function generateReport_SingleDifferential_SNR_Statistics()

    options  = get_Options();
    analyses = get_Analyses();
    
    MU_Data = threshold_MUs(options);
    
    MU_Data = append_AgeCategory(MU_Data,options);
    MU_Data = append_ForceCategory(MU_Data,options);
    
    [serverHandle, selection] = open_ConnectionToWord();
    print_ReportDescription(selection);
    print_OptionsAndAnalyses(selection, options, analyses);
    print_All_SingleDifferential_SNR_Statistics(selection, MU_Data, options);
    print_Analysis_LoopOverSubjects(selection, MU_Data, analyses.IndividualSubject,options);
    
    delete(serverHandle)
end

function analyses = get_Analyses()
    analyses.IndividualSubject{1} = @(selection,subjData,options)print_Subject_SingleDifferential_SNR_Statistics(selection,subjData,options); 
end

function options = get_Options()
    
    options.SingleDifferential.BaseDirectory     = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data';
    
%     options.STA.File                           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl_4_12_2017.mat';
%     options.STA_Window.File                    = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Window_Control_4_10_2017.mat';
    
    options.STA.File                           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Stroke_4_17_2017.mat';
    options.STA_Window.File                    = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Window_Stroke_4_17_2017.mat';
    
    options.STA_Window.Threshold.On              = 0;
    options.STA_Window.Threshold.Statistic       = 'PtP_Amplitude_Mean_CV';
    options.STA_Window.Threshold.Function        = {@(qty,thresh)lt(qty,thresh)};
    options.STA_Window.Threshold.Value           = 0.6;
    options.STA_Window.PtPAmplitude.Statistic    = 'Mean_CV';
    options.STA_Window.PtPDuration.Statistic     = 'Mean_CV';
    options.STA_CrossCorrelation.Threshold.On    = 0;
    options.STA_CrossCorrelation.Threshold.Statistic = 'Mean_XC';
    options.STA_CrossCorrelation.Threshold.Function  = {@(qty,thresh)gt(qty,thresh)};
    options.STA_CrossCorrelation.Threshold.Value = 0.8;
    options.STA_CrossCorrelation.XC.Statistic    = 'Mean_XC';
    options.MUs.Threshold.On                     = 0;
    options.MUs.Threshold.Type                   = 'MinNumberUnits_PerForceLevel';
    options.MUs.Threshold.Function               = {@(MU_Data,options)threshold_NumberOfMUs(MU_Data,options)};
    options.MUs.Threshold.Value                  = 10;
    options.FileID_Tag                           = {'SensorArrayFile','ArrayNumber','MU'};  
    
    options.AgeRange.Threshold                 = [0,65; 65,Inf];
    options.AgeRange.Names                     = {'Young','Elderly'};
    
    options.ForceRange.Threshold                 = [0,30; 30,Inf];
    options.ForceRange.Names                     = {'Under_30N','Above_30N'};
    
    % Calculate single differential SNR
    options.Analysis(1).Trial.OutputVariable(1) = {'BICM_SNR'};
    options.Analysis(1).Trial.OutputVariable(2) = {'BICL_SNR'};
    options.Analysis(1).Trial.OutputVariable(3) = {'TRI_SNR'};
    options.Analysis(1).Trial.OutputVariable(4) = {'BRD_SNR'};
    options.Analysis(1).Trial.OutputVariable(5) = {'BRA_SNR'};
    options.Analysis(1).SEMG.Method             = 'PtP';
    options.Analysis(1).SEMG.Statistic          = 'Max';
    options.Analysis(1).SEMG.Window             = 2;
    options.Analysis(1).SEMG.SlideStep          = 0.1;
    options.Analysis(1).SEMG.Start              = [];
    options.Analysis(1).SEMG.End                = [];
    options.Analysis(1).SEMG.PtP.Number         = 200;    
    options.Analysis(1).Baseline.Method         = 'PtP';
    options.Analysis(1).Baseline.Statistic      = 'Raw';
    options.Analysis(1).Baseline.Window         = 2;
    options.Analysis(1).Baseline.SlideStep      = 0.1;
    options.Analysis(1).Baseline.Start          = 0.5;
    options.Analysis(1).Baseline.End            = 2.5;
    options.Analysis(1).Baseline.PtP.Number     = 200;   
end


function print_ReportDescription(selection)
    selection.Font.Size = 56;
    selection.Font.Bold = 1;
    selection.TypeText(['MATLAB REPORT:' char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText([date() char(13) char(13) char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText(['This report contains a summary of Single Differential Surface EMG data.' char(13)])  
    selection.Font.Size = 12;%     selection.TypeText(['- For each subject, a summary table of all trials is included.' char(13)]) 
%     selection.TypeText(['- The summary table is printed for both SensorArray.mat and SingleDifferential.mat files.' char(13)]) 
%     selection.TypeText(char(13)) 
%     selection.TypeText(['- After the summary table, Force traces from all trials are plotted.' char(13)]) 
%     selection.TypeText(['- Only force traces from SensorArray.mat files are included.' char(13)]) 
%     selection.TypeText(['- Force traces from SingleDifferential.mat files are not included.' char(13)']) 
    selection.InsertBreak;
end


