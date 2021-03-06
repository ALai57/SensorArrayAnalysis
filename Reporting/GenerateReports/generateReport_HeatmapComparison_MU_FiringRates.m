

function generateReport_HeatmapComparison_MU_FiringRates()

    options = get_options();
    
    stats = import_StatisticalTable(options.StatTable);
    
    [serverHandle, selection] = open_ConnectionToWord();
    print_ReportDescription(selection);
    print_StructToWord(selection,options)
    print_HeatmapComparison_MU_FiringRates(selection,stats,options);
    print_HeatmapComparison_MU_FiringRates_v_Force(selection,stats,options);
    
    delete(serverHandle)
    
end

function options = get_options()
    options.StatTable.FileName  = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Reports\ReportSummary.xlsx';
    options.StatTable.Worksheet = 'AllComparisons';
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
    selection.TypeText(['This report contains a summary of MU Firing rate Statistics.' char(13)])  
    selection.Font.Size = 12;
    selection.InsertBreak;
end
