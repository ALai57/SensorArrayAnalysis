%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Appends the Delsys decomposition data to sensor array data files
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw sensor array data (.csv format) into .mat files
%   - Export Delsys decomposition files: 
%       MUAPs.txt 
%       MUFiringTimes.txt
%   
%   INPUT: 
%   - folder where all subject data reside
%   - options including
%       File naming conventions
%       Sensor array location information
%    
%   OUTPUT: 
%   - 'Array' struct appended to each SensorArray.mat file, containing:
%       MU Firing Times 
%       MUAP Templates
%       Array Location information 
%
%   TO EDIT:
%   - Change target mat files
%   - Change naming conventions if necessary
%
%   VARIABLES:
%   - options
%      .X.FileNameConvention = Naming convention, separated by underscores
%      .X.FileID_Tag         = Unique identifier for each file
%      .Array                = Sensor Array Information 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
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

% Elderly control
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\DW',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ED',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JA',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JC',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\JF',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\PT',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT',options)

% Young control
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AC',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AL',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\GR',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\HS',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\MS',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\ZR',options)

% Stroke
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\EW',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JD',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JL',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\JR',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\KB',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\KP',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\MM',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\NG',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\NT',options)
append_DecompositionResults_ToSensorArrayFile('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke\WS',options)
