
%%%%%% Calculate MU Duration CV %%%%%%%%
%%%%%%% PRINT MU Duration CV too %%%%%%%%
function generateReport_STA_Duration_Over_Time()

    options = get_Options();
    MU_Data = append_PtP_Duration_ToSTATable(options);

    analysis.IndividualSubject{1} = @(selection,subjData)print_Subject_PtP_Duration_Over_Time(selection,subjData);
    
    [serverHandle, selection] = open_ConnectionToWord();
    
    report_Description(selection);
    print_OptionsAndAnalyses(selection, options, analysis);
    report_BySubject_Table(selection, MU_Data, analysis.IndividualSubject);
    
    delete(serverHandle)
end

function print_OptionsAndAnalyses(selection, options, analysis)

    selection.TypeText(['STA Windowing options.' char(13)])  
    STA_Window_options = load(options.STA_Window.File,'options');
    print_StructToWord(selection,STA_Window_options.options)
    
    selection.TypeText(['Analysis and thresholding options.' char(13)]) 
    print_StructToWord(selection,options)
    
    selection.TypeText(['Analyses performed.' char(13)]) 
    print_StructToWord(selection,analysis);
    
    selection.InsertBreak;
end

function options = get_Options()
    options.STA.File                        = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl.mat';
    options.STA_Window.File                 = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Window_Control_4_10_2017.mat';
    options.STA_Window.Threshold.Type       = 'PeakToPeakCV';
    options.STA_Window.Threshold.Channels   = 'AllChannelsMeetThreshold';
    options.STA_Window.Threshold.Value      = 0.6;
    options.FileID_Tag                      = {'SensorArrayFile','ArrayNumber','MU'}; 
end

function MU_Data = append_PtP_Duration_ToSTATable(options)

    PtP_Out = get_Threshold_STA_PtP(options);

    load(options.STA.File,'MU_Data')
    PtP_Out = append_FileID_Tag(PtP_Out,options);
    MU_Data = append_FileID_Tag(MU_Data,options);

    if isequal(PtP_Out.FileID_Tag,MU_Data.FileID_Tag)
       MU_Data = [MU_Data,PtP_Out(:,4:8)]; 
       clear PtP_Out
    end
    
end

function report_Description(selection)
    selection.Font.Size = 56;
    selection.Font.Bold = 1;
    selection.TypeText(['MATLAB REPORT:' char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText([date() char(13) char(13) char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText(['This report contains a summary of how motor unit durations changed throughout different contractions.' char(13)])  
    selection.Font.Size = 12;
    selection.TypeText('Motor unit durations were calculated using a windowed STA algorithm (2 second windows, sliding every 0.5 seconds). Then the MU duration was calculated at each sliding window to see how MU duration changed over time.')
%     selection.TypeText(['- For each subject, a summary table of all trials is included.' char(13)]) 
%     selection.TypeText(['- The summary table is printed for both SensorArray.mat and SingleDifferential.mat files.' char(13)]) 
%     selection.TypeText(char(13)) 
%     selection.TypeText(['- After the summary table, Force traces from all trials are plotted.' char(13)]) 
%     selection.TypeText(['- Only force traces from SensorArray.mat files are included.' char(13)]) 
%     selection.TypeText(['- Force traces from SingleDifferential.mat files are not included.' char(13)']) 
    selection.InsertBreak;
end