

function generateReport_MU_Amplitude_vs_MeanFiringRate()

    options  = get_Options();
    analyses = get_Analyses();
    
%     MU_Data = append_STA_Window_Statistics_ToSTATable([],options);  %ONLY FOR THRESHOLDING
    
    load(options.STA.File,'MU_Data');
    
    [serverHandle, selection] = open_ConnectionToWord();
    print_ReportDescription(selection);
    print_OptionsAndAnalyses(selection, options, analyses);
%     print_All_MU_Amplitude_vs_MeanFiringRate(selection, MU_Data, options)
    print_Analysis_LoopOverSubjects(selection, MU_Data, analyses.IndividualSubject,options);
    
    delete(serverHandle)
end

function analyses = get_Analyses()
    analyses.IndividualSubject{1} = @(selection,subjData,options)print_Subject_MU_Amplitude_vs_MeanFiringRate(selection,subjData,options);
end

function print_OptionsAndAnalyses(selection, options, report)

    if options.STA_Window.Threshold.On 
        selection.TypeText(['Thresholding and STA Windowing options.' char(13)])  
        STA_Window_options = load(options.STA_Window.File,'options');
        print_StructToWord(selection,STA_Window_options.options)
        print_StructToWord(selection,options.STA_Window)
    else
        options.STA_Window = [];
    end
    
    selection.TypeText(['Analysis options.' char(13)]) 
    print_StructToWord(selection,options)
    
    selection.TypeText(['Reporting functions performed.' char(13)]) 
    print_StructToWord(selection,report);
    
    selection.InsertBreak;
end

function options = get_Options()
    options.STA.File                           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl.mat';
    options.STA_Window.File                    = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Window_Control_4_10_2017.mat';
    options.STA_Window.Threshold.On            = 0;
    options.STA_Window.Threshold.Type          = 'Amplitude';
    options.STA_Window.Threshold.Statistic     = 'CV';
    options.STA_Window.Threshold.Channels      = 'AllChannelsMeetThreshold';
    options.STA_Window.Threshold.Value         = 0.6;
    options.STA_Window.PtPAmplitude.Statistic  = 'CV';
    options.STA_Window.PtPDuration.Statistic   = 'CV';
    options.FileID_Tag                         = {'SensorArrayFile','ArrayNumber','MU'}; 
    
    % Set up MU Onset calcuation
    options.Analysis(1).Trial.Function          = {@(trial_Data,options)calculate_MU_MeanFiringRate_FromTrial(trial_Data,options)};
    options.Analysis(1).Trial.OutputVariable(1) = {'MeanFiringRate'};
    options.Analysis(1).BaseDirectory           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';
    options.Analysis(1).MFR.Start               = 'RelativeToPlateauStart';
    options.Analysis(1).MFR.StartAfterPlateau   = +2;
    options.Analysis(1).MFR.Duration            = 5;
   
    % Set up PtP Amplitude calculation
    options.Analysis(2).Trial.Function          = {@(trial_Data,options)calculate_STA_AmplitudeAndDuration(trial_Data,options)};
    options.Analysis(2).Trial.OutputVariable(1) = {'MU_Amplitude'};
    options.Analysis(2).BaseDirectory           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';
    options.Analysis(2).STA.ColumnName          = {'STA_Template'};
    options.Analysis(2).STA.Amplitude.Statistic = 'Max'; %Average, All
    
%     options.GroupAnalysis(1).Group
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
    selection.TypeText(['This report contains a summary of MU Amplitude vs. MU Mean Firing Rate.' char(13)])  
    selection.Font.Size = 12;%     selection.TypeText(['- For each subject, a summary table of all trials is included.' char(13)]) 
    selection.InsertBreak;
end