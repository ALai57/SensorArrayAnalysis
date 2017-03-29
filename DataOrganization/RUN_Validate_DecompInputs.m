
% Validate that the inputs to the decomposition algorithm were all correct.
% Multiple naming conventions were used at the decomposition step, so there
% are multiple options

%% Naming convention 1
options.Decomp.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.Decomp.FileID_Tag         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileID_Tag         = options.Decomp.FileID_Tag;


match_SensorArray_DecompInput = [];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\DW';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ED';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JA';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JC';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JF';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\PT';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];


%% Naming convention 2
options.Decomp.FileNameConvention = {'SID','ArmType','ArmSide','TargetForce','Rep','ID'}; 
options.Decomp.FileID_Tag         = {'SID','ArmType','ArmSide','TargetForce','Rep','ID'}; 
options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileID_Tag         = options.Decomp.FileID_Tag;

subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AC';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\HS';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\MS';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ZR';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];

%% Naming convention 3
options.Decomp.FileNameConvention = {'SID','ArmType','ArmSide','TargetForce','Rep','ID'}; 
options.Decomp.FileID_Tag         = {'TargetForce','Rep','ID'}; 
options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileID_Tag         = options.Decomp.FileID_Tag;

subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\GR';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];

%% Naming convention 4
options.Decomp.FileNameConvention = {'SID','ArmInfo','Experiment','TargetForce','Rep','ID'}; 
options.Decomp.FileID_Tag         = {'SID','TargetForce','Rep','ID'}; 
options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileID_Tag         = options.Decomp.FileID_Tag;

subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AL';  match_SensorArray_DecompInput = [match_SensorArray_DecompInput; validate_DecompInputs(subjDir,options)];

%% File output
theFile = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\Validation_DecompInputs.txt';
writetable(match_SensorArray_DecompInput,theFile,'Delimiter','\t')
