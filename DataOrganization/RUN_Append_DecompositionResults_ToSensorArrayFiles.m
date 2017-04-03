
% % This script sets up a program that appends the Delsys decomposition data to the sensor array data files
% 
%     % Inputs: 
%         % options
%         % subjectFolder
%     
%     % Output:
%         % An extra 'Array' struct appended to each SensorArray.mat file
%         % The Array struct contains MUFiringTimes, MUAPs, and Array info
%     
%     
% % options
%     % .X.FileNameConvention = the naming convention used for each file type
%     % .X.FileID_Tag = the way to identify files that come from the same trial
%     % .Array = Information about the sensor arrays used in the experiment
    
options.DecompInput.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompOutput.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompExport.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

ID_Tag = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
options.DecompInput.FileID_Tag   = ID_Tag;
options.DecompOutput.FileID_Tag  = ID_Tag;
options.DecompExport.FileID_Tag  = ID_Tag;
options.SensorArray.FileID_Tag   = ID_Tag;
options.FileID_Tag               = ID_Tag;

options.Array.Number   = {'1','2'};
options.Array.Names    = {'Medial','Lateral'};
options.NumberOfArrays = length(options.Array.Number);


append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\DW',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ED',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JA',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JC',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JF',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\PT',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT',options)


append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AC',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AL',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\GR',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\HS',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\MS',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ZR',options)


