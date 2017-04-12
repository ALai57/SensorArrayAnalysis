
function generateReport_NumberOfMUsDecomposed()
    
    options  = get_Options();
    analyses = get_Analyses();   
    
    load(options.STA.File,'MU_Data');
    
    [serverHandle, selection] = open_ConnectionToWord(); 
    print_ReportDescription(selection);
    print_All_NumberOfMUsDecomposed(selection, MU_Data);
    print_Analysis_LoopOverSubjects(selection, MU_Data, analyses.IndividualSubject, options)
    
    %%% INCLUDE FORCE LEVELS TABLE....
    delete(serverHandle)
end

function analyses = get_Analyses()
    analyses.IndividualSubject{1} = @(selection,subjData,options)print_Subject_NumberOfMUsDecomposed(selection,subjData,[]);
end

function options = get_Options()
    options.STA.File = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl.mat';
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
    selection.TypeText(['Description of contents: This report contains a summary of all the Motor Units decomposed from each subject.' char(13)])  
    selection.Font.Size = 12;
    selection.InsertBreak;
end