%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Gets the decomp workspace name in the decomp folder ("decomp/workspace name) 
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
%    
%   OUTPUT: 
%   - decompWorkspace = name of folder with decomp workspace
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - N/A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dWorkspace = get_SubjectDecompWorkspace(masterFolder)
    decompFolder = [masterFolder '\decomp'];
    
    dContents = dir(decompFolder);
    dContents = dContents(3:end);
    
    ind        = [dContents.isdir]';
    dWorkspace = [decompFolder '\' dContents(ind).name];
end