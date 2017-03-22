

function print_Subject_EMGSummary_SingleDifferentialFiles(selection,subjFolder)

    options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.GroupingVariable = 'ArmType';
    options.Trial.Group = 'CTR';
    options.Plot.ShowID = {'TargetForce','ID'};
     
    singleDifferentialFolder = {[subjFolder '\singlediff']};
    fName = plot_AllTrialEMGdata_FromFolder(singleDifferentialFolder,options);
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    print_FigureToWord(selection,'Single Differential Trials','ScreenCapture'); 
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
    close(gcf);
    
    
end