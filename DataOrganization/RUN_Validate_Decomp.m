
 
options.DecompInput.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompOutput.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompExport.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

ID_Tag = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
options.DecompInput.FileID_Tag   = ID_Tag;
options.DecompOutput.FileID_Tag  = ID_Tag;
options.DecompExport.FileID_Tag  = ID_Tag;
options.SensorArray.FileID_Tag   = ID_Tag;

options.NumberOfArrays = 2;

decompValidation_tbl = [];

subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\DW'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ED'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JA'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JC'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JF'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\PT'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];