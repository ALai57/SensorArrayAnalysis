%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Parses file names in a target folder and returns parsed info
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%   
%   INPUT: 
%   - directoryName = the directory containing the files
%   - ext = file extension 
%   - options including
%       File naming conventions
%    
%   OUTPUT: 
%   - fileInfo = table with information from each file (eg. SID,... etc)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .Trial
%       .FileNameConvention = the naming convention used for each file 
%                               (Fields must be separated by underscores)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function files = parse_FileNames_In_Folder(directoryName,ext,options)
    [matFiles,datenum] = get_AllFilesWithExtension(directoryName,ext);
    
    files = table(matFiles,datenum,'VariableNames',{'Files','Datenum'});
    files = parse_FileName_Table(files,options); %Old version: options.Trial
    files = append_FullFilePath(files,directoryName);
end

function files  = append_FullFilePath(files,directoryName)
    nFiles = size(files,1);
    
    for n=1:nFiles
        fullFileName{n,1} = [directoryName '\' files.Files{n}];
    end
    
    files.FullFile = fullFileName;
end