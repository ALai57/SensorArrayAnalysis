%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Fetches information from files in "array" folder by parsing file
%   names
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
%    
%   OUTPUT: 
%   - SA_FileInfo = table with information from each file (eg. SID,... etc)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .SensorArray
%       .FileNameConvention = the naming convention used for each file 
%                               (Fields must be separated by underscores)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SA_FileInfo = get_SensorArrayFileInfo_FromMasterFolder(masterFolder,options)
    arrayFolder   = [masterFolder '\array'];
    SA_FileInfo   = parse_FileNames_In_Folder(arrayFolder,...
                                                       '.mat',...
                                                       options.SensorArray);
end