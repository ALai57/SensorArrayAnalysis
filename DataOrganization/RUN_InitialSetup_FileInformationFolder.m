
%%% CREATE EMPTY MVC and FILE INFORMATION STRUCTS

dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control'};

options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.Subject_Analyses{1}            = @(subj_Dir,options)initialSetup_FileInformationFolder(subj_Dir, options);

loop_Over_SubjectType(dataDirs,options)
