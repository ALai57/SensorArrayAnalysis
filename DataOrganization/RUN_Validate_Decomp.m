
%  % This script sets up a validation for Delsys dEMG decomp
%  % The script checks that the decomposition was done correctly
%  
%  % The file checks that
%     % 1) All trials were set up for decomposition
%     % 2) The correct EMG channels were decomposed
%     % 3) Decomposition outputs were obtained from Delsys dEMG
%     % 4) Decompositions were exported
    
options.DecompInput.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompOutput.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.DecompExport.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SensorArray.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

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

subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AC'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AL'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\GR'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\HS'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\MS'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ZR'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];


subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\EW'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JD'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JL'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JR'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\KB'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\KP'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\MM'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\NG'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\NT'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];
subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\WS'; decompValidation_tbl  = [decompValidation_tbl; validate_Decomp(subjDir,options)];



