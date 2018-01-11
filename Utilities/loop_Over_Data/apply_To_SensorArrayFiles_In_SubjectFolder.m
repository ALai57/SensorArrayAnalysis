%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - This utility searches for all .mat files in the 'array' and
%     'singlediff' folders and performs the same set of analyses on each file
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%
%   INPUT: 
%   - masterFolder = the directory (usu subj folder) that has subfolders for
%        array
%        decomp
%        hpf
%        singlediff
%        smr
%        trial_information
%   - options including
%       File naming conventions
%       Analysis to perform on each trial
%    
%   OUTPUT: 
%   - dataTbl = table containing ALL data
%
%   TO EDIT:
%   - If different function inputs are needed, it is possible to edit the
%       arguments in the function handle call 
%
%   VARIABLES:
%   - options 
%       .SensorArray
%       .SingleDifferential
%           both with
%               .FileNameConvention = naming convention for each file 
%       .Trial_Analyses = function handle with analysis to be performed on
%                           each trial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 
% options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% 
% options.Trial_Analyses{1}                      = @(arrayFile,singlediffFile,trial_Information,MVC,options)build_2Array_DataTable(arrayFile,...
%                                                                                                                                       singlediffFile,...
%                                                                                                                                       trial_Information,...
%                                                                                                                                       MVC,...
%                                                                                                                                       options );
% subj_Dir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT';                                                                                                                                  
%                                                                                                                                   

function analysis = apply_To_SensorArrayFiles_In_SubjectFolder(masterFolder, options)

    [~,SID,~] = fileparts(masterFolder);
    
    array_Dir      = [masterFolder '\array'];
    singlediff_Dir = [masterFolder '\singlediff'];
    info_Dir       = [masterFolder '\trial_Information'];
    
    %Extract relevant files from subject sub-folders
    arrayFiles      = parse_FileNames_In_Folder(array_Dir,...
                                                         '.mat',...
                                                         options.SensorArray);
    singlediffFiles = parse_FileNames_In_Folder(singlediff_Dir,...
                                                         '.mat',...
                                                         options.SingleDifferential);
    
    load([info_Dir '\' SID '_Trial_Information.mat'])
    
    % Loop through each trial in subject's array folder - e.g. Sensor array data
    analysis = cell(length(options.Trial_Analyses),1);
    for i=1:size(arrayFiles,1)  
        for j=1:length(options.Trial_Analyses)
            analysis{j} = [analysis{j}; ...
                            options.Trial_Analyses{j}(arrayFiles(i,:),...
                                                      singlediffFiles(i,:),...
                                                      forceMatching_Info(i,:),...
                                                      MVC,...
                                                      options )...
                          ];
        end
    end

end