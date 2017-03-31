
function generateReport_NumberOfMUsDecomposed(MU_Data)

    analyses{1} = @(selection,subjData)print_Subject_NumberOfMUsDecomposed(selection,subjData);

    report_BySubject_Table(MU_Data, @reportDescription, analyses)
    
    %%% INCLUDE ABILITY TO PRINT OPTIONS RIGHT UP FRONT.
    %%% INCLUDE FORCE LEVELS TABLE....
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
    selection.TypeText(['Description of contents: This report contains a summary of all the Motor Units decomposed from each subject.' char(13)])  
    selection.Font.Size = 12;
%     selection.TypeText(['- For each subject, a summary table of all trials is included.' char(13)]) 
%     selection.TypeText(['- The summary table is printed for both SensorArray.mat and SingleDifferential.mat files.' char(13)]) 
%     selection.TypeText(char(13)) 
%     selection.TypeText(['- After the summary table, Force traces from all trials are plotted.' char(13)]) 
%     selection.TypeText(['- Only force traces from SensorArray.mat files are included.' char(13)]) 
%     selection.TypeText(['- Force traces from SingleDifferential.mat files are not included.' char(13)']) 
    selection.InsertBreak;
end