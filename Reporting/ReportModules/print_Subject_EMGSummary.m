
% [serverHandle, selection] = open_ConnectionToWord();
% subjFolder = 'Q:\Andrew\DelsysArray - Copy\Data\Control\AC';

function print_Subject_EMGSummary(selection,subjFolder)

    options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.GroupingVariable = 'ArmType';
    options.Trial.Group = 'All';
    options.Trial.MatchFilesBy  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
    options.Plot.ShowID = {'TargetForce','ID'};
    
    Folder = {[subjFolder '\array'], [subjFolder '\singlediff']};
    fName = plot_AllTrialEMGdata_FromFolder(Folder,options);
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientLandscape';
    print_FigureToWord(selection,'Trials','ScreenCapture'); 
    selection.InsertBreak(2) %'wdSectionBreakNextPage';
    selection.PageSetup.Orientation = 'wdOrientPortrait';
    close(gcf);
    
end

% sensorArrayFolder = {[subjFolder '\array']};
% fName = plot_AllTrialEMGdata_FromFolder(sensorArrayFolder,options);
% print_FigureToWord(selection,'Sensor Array Trials','ScreenCapture'); 
% close(gcf);
% 
% singleDifferentialFolder = {[subjFolder '\singlediff']};
% fName = plot_AllTrialEMGdata_FromFolder(singleDifferentialFolder,options);
% print_FigureToWord(selection,'Single Differential Trials','ScreenCapture'); 
% close(gcf);
    