%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Adds an additional folder for each subject's information
%   - Info folder can have Age, Clinical scores, etc...
%
%   BEFORE RUNNING, SETUP:
%   - No prerequisites
%   
%   INPUT: 
%   - dataDirs = directory where all subject data resides
%   - options including
%       File naming conventions
%    
%   OUTPUT: 
%   - trialInformation Folder containing "xxx_trial_Information.mat"
%
%   TO EDIT:
%   - Change target directory
%   - Change naming conventions if necessary
%
%   VARIABLES:
%   - options
%      .X.FileNameConvention = Naming convention, separated by underscores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% CREATE EMPTY MVC and FILE INFORMATION STRUCTS

dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke'};

options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.Subject_Analyses{1}            = @(subj_Dir,options)initialSetup_FileInformationFolder(subj_Dir, options);

loop_Over_SubjectType(dataDirs,options)
