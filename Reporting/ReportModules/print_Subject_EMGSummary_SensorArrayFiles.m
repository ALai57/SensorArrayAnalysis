
function print_Subject_EMGSummary_SensorArrayFiles(selection,subjFolder)

    options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.GroupingVariable = 'ArmType';
    options.Trial.Group = 'CTR';
    options.Trial.MatchFilesBy  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
    options.Plot.ShowID = {'TargetForce','ID'};
    
    sensorArrayFolder = {[subjFolder '\array']};
    fName = plot_AllTrialEMGdata_FromFolder(sensorArrayFolder,options);
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    print_FigureToWord(selection,'Sensor Array Trials','ScreenCapture'); 
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
    close(gcf);
      
end

