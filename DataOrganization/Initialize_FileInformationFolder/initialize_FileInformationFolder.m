%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Initialize folder with subject-specific information
%
%   BEFORE RUNNING, SETUP:
%   - No prerequisites
%   
%   INPUT: 
%   - subject directory where all subject data reside
%   - options including
%       File naming conventions
%    
%   OUTPUT: 
%   - trialInformation file containing:
%       Subject MVC
%       Subject beginning of ramp time
%       Subject plateau time
%
%   TO EDIT:
%   - Change "create empty file information" function to add desired fields
%
%   VARIABLES:
%   - options
%      .X.FileNameConvention = Naming convention, separated by underscores
%      .X.FileID_Tag         = Unique identifier for each file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = initialize_FileInformationFolder(subj_Dir, options)

    [~,SID,~] = fileparts(subj_Dir);
    info_Dir  = [subj_Dir '\trial_information'];
    info_File = [info_Dir '\' SID '_Trial_Information.mat'];
    
    if exist(info_Dir,'dir')
        fprintf('Folder exists: %s\\trial_information\n',SID)
    else
        mkdir(info_Dir);
        fprintf('Folder created: %s\\trial_information\n',SID)
    end
    
    if ~exist(info_File,'file')
        [MVC,force_Info] = create_Empty_FileInformation(subj_Dir,options);
        save(info_File,'MVC','forceMatching_Info');
        fprintf('Blank file created: %s\n',info_File)
    else
        fprintf('File exists: %s\n', info_File); 
        return;
    end

    out = 'Complete';
    
end

function [MVC,force_Info] = create_Empty_FileInformation(subj_Dir,options)

    array_Dir  = [subj_Dir '\array'];
    array_Files = parse_FileNames_In_Folder(array_Dir,'.mat',options.SensorArray);
    
    arm_Types = unique(array_Files.ArmType);
    
    z = zeros(length(arm_Types),1);
    MVC = table(z,z,'VariableNames',{'Fx_N','Fz_N'});
    
    for n=1:length(arm_Types)
        MVC.Properties.RowNames{n} = arm_Types{n};
    end
    
    force_Info           = array_Files;
    force_Info.RampStart = repmat(3.5,size(force_Info,1),1);
    
    for n=1:size(array_Files.TargetForce,1)
        TF(n,1) = sscanf(array_Files.TargetForce{n}, '%g*');
        if TF(n,1) == 100 % MVC
           force_Info.RampStart(n) = 0;
           plateau_Delay(n,1) = 0;
           continue; 
        end
        if ~isempty(strfind(array_Files.TargetForce{n},'MVC'))
            plateau_Delay(n,1) = TF(n)/10;
        elseif ~isempty(strfind(array_Files.TargetForce{n},'Newtons'))
            plateau_Delay(n,1) = TF(n)/5;
        end
    end
    
    force_Info.PlateauStart = force_Info.RampStart+plateau_Delay;
    %%%%%%%%%%%%%%% START HERE NOW %%%%%%%%%%%%%% ADD MVC and RAMP START INFO.
end