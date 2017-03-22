

function print_Subject_ForceSummary_SensorArrayFiles(selection,subjFolder)

    options.Trial.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.GroupingVariable    = 'ArmType';
    options.Trial.Group               = 'CTR';

    sensorArrayFolder        = [subjFolder '\array'];
    fName = plot_AllTrialForceTraces_FromFolder(sensorArrayFolder,options);
    print_FigureToWord(selection,'Sensor Array Trials Only','Bitmap'); 
    close(gcf);
    
end