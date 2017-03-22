


function print_Subject_ForceSummary(selection,subjFolder)

    options.Trial.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.MatchFilesBy        = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
    options.Trial.GroupingVariable    = 'ArmType';
    options.Trial.Group               = 'All';

    sensorArrayFolder        = [subjFolder '\array'];
    singleDifferentialFolder = [subjFolder '\singlediff'];
    
    fEqual = validate_ForceTracesAreEqual_FromDifferentFolders({sensorArrayFolder, singleDifferentialFolder},options);
    
    selection.TypeText(sprintf('%d/%d Forces from SensorArray.mat and SingleDifferential.mat are equal. \n',sum(fEqual),length(fEqual))); 
    %%%%% PRINT TEXT THAT FORCES ARE EQUAL - number of total %%%%%%%%%%%
    
    fName = plot_AllTrialForceTraces_FromFolder(singleDifferentialFolder,options);
    print_FigureToWord(selection,'All force traces','Bitmap'); 
    close(gcf);
    
end

%     fName = plot_AllTrialForceTraces_FromFolder(sensorArrayFolder,options);
%     print_FigureToWord(selection,'Sensor Array Trials','Bitmap'); 
%     close(gcf);