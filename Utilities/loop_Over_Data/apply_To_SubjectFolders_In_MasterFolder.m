%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Perform analysis, looping over all subjects with a specific attribute
%
%   BEFORE RUNNING, SETUP:
%   - No prerequisites
%   
%   INPUT: 
%   - dataDirs = directory where all subject data resides
%   - options including
%       File naming conventions
%       Analysis to be performed on each subject (as a function handle)
%    
%   OUTPUT: 
%   - analysis data structure, each cell contains results from one subject
%
%   TO EDIT:
%   - Change naming conventions if necessary
%   - Change function that subject subfolders 'get_subfolders'
%
%   VARIABLES:
%   - options
%      .X.FileNameConvention = Naming convention, separated by underscores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Example - build data table, looping over only control subjects
%
% dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control'};
% 
% options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% 
% options.Subject_Analyses{1}                    = @(subj_Dir, options)apply_To_SensorArrayFiles_In_Subject_Folder(subj_Dir,options);
% options.Trial_Analyses{1}                      = @(arrayFile,singlediffFile,trial_Information,MVC,options)build_2Array_DataTable(arrayFile,...
%                                                                                                                                       singlediffFile,...
%                                                                                                                                       trial_Information,...
%                                                                                                                                       MVC,...
%                                                                                                                                       options );
% [4,5,8,9,10,12,13] = new Control subjects
%  [1,2,3,6,7,11,14] = old Control subjects


function analysis = apply_To_SubjectFolders_In_MasterFolder(dataDirs,options)

    analysis = cell(length(options.Subject_Analyses),1);
    
     %Loop over all master folders - this is typically the folder
     %labeled "stroke" or "control"
    for status=1:length(dataDirs)
        
        SIDs = get_subFolders(dataDirs{status});

        for subj=1:length(SIDs) %Loop through each subject

            SID            = SIDs{subj};
            
            %%%%% EDIT THIS IF FOLDER STRUCTURE CHANGES %%%%%%%
            subj_Dir       = [dataDirs{status} '\' SID]; 
           
            tic;
            for a=1:length(options.Subject_Analyses)
                analysis{a} = [analysis{a}; ...
                               options.Subject_Analyses{a}(subj_Dir,options)...
                              ];
            end     
            elapsed = toc;
            fprintf('Subject: %-5s  | Elapsed time: %-8.2f secs\n',SID,elapsed); 
            
        end
    end

end

function subFolders = get_subFolders(dataDirs) 
    fContents   = dir(dataDirs);
    
    dirFlag    = false(length(fContents),1);
    subFolders = {};
    for n=3:length(fContents) % First two folders are '.' and '..'
       if isdir([fContents(n).folder '\' fContents(n).name])
           dirFlag(n) = true;
           subFolders(end+1,1) = {fContents(n).name};
       end
    end
    
end