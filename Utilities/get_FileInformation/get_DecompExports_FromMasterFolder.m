%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Fetches information from exported .txt files in "decomp" folder 
%     by parsing file names
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
%   - DE_FileInfo = table with information from each file (eg. SID,... etc)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .DecompExport
%       .FileNameConvention = the naming convention used for each file 
%                               (Fields must be separated by underscores)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  DE_FileInfo = get_DecompExports_FromMasterFolder(masterFolder,options)
    
    decompFolder = [masterFolder '\decomp'];
    DE_FileInfo  = extract_FileInformation_FromFolder(decompFolder,...
                                                      '.txt',...
                                                      options.DecompExport);
   	DE_FileInfo = split_Decomp_RepID(DE_FileInfo);
    DE_FileInfo.Properties.VariableNames{1} = 'ExportFiles';
end
