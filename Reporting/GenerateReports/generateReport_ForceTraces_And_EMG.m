
%     dataFolder = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';
%     dataFolder = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke';

function generateReport_ForceTraces_And_EMG(dataFolder)

    analyses{1} = @(selection,subjFolder)print_Subject_FileSummary(selection,subjFolder);
    analyses{2} = @(selection,subjFolder)print_Subject_ForceSummary(selection,subjFolder);
    analyses{3} = @(selection,subjFolder)print_Subject_EMGSummary(selection,subjFolder);

    report_BySubject(dataFolder, @reportDescription, analyses)
end


function reportDescription(selection)
    selection.Font.Size = 56;
    selection.Font.Bold = 1;
    selection.TypeText(['MATLAB REPORT:' char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText([date() char(13) char(13) char(13)]);
    selection.Font.Size = 16;
    selection.Font.Bold = 0;
    selection.TypeText(['Description of contents: This report contains a summary of all the force traces and all EMG signals from each subject.' char(13)])  
    selection.Font.Size = 12;
    selection.TypeText(['- For each subject, a summary table of all trials is included.' char(13)]) 
    selection.TypeText(['- The summary table is printed for both SensorArray.mat and SingleDifferential.mat files.' char(13)]) 
    selection.TypeText(['- The function checks that the force traces from SensorArray.mat and SingleDifferential.mat files match.' char(13)]) 
    selection.TypeText(char(13)) 
    selection.TypeText(['- After the summary table, Force traces from all trials are plotted.' char(13)])  
    selection.TypeText(['- Then, EMG signals from all trials are plotted.' char(13)]) 
    
end