%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Assembles all data into data table used for subsequent analysis
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw sensor array data (.csv format) into .mat files
%   - Append decomposition results to sensor array .mat files
%   - Segment long .smr file into trials with .mat format
%   
%   INPUT: 
%   - dataDirs = directory where all subject data resides
%   - options including
%       File naming conventions
%       Sensor array location information
%    
%   OUTPUT: 
%   - MU_Data table containing ALL data
%
%   TO EDIT:
%   - Change target mat files
%   - Change naming conventions if necessary
%
%   VARIABLES:
%   - options
%      .X.FileNameConvention = Naming convention, separated by underscores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke'};

options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

options.Subject_Analyses{1} = @(subj_Dir, options)...
                                    apply_To_SensorArrayFiles_In_SubjectFolder(subj_Dir,options);
                                
options.Trial_Analyses{1}   = @(arrayFile,...
                               singlediffFile,...
                               trial_Information,...
                               MVC,...
                               options)...
                                  build_DataTable(arrayFile,...
                                                  singlediffFile,...
                                                  trial_Information,...
                                                  MVC,...
                                                  options );
                                                                                                                                  
dataStruct = apply_To_SubjectFolders_In_MasterFolder(dataDirs,options); 
MU_Data    = convert_DataStruct_ToTable(dataStruct);


