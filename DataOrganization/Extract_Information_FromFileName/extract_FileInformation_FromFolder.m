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

%%%% CHANGE OPTIONS.TRIAL to OPTIONS

function fileInfo = extract_FileInformation_FromFolder(directoryName,ext,options)
    [matFiles,datenum] = get_AllFilesWithExtension(directoryName,ext);
    
    fileInfo = table(matFiles,datenum,'VariableNames',{'Files','Datenum'});
%     fileInfo = parse_FileNameTable(fileInfo,options.Trial);
    fileInfo = parse_FileNameTable(fileInfo,options);
    fileInfo = append_FullFileName_ToTable(fileInfo,directoryName);
end

function fileTable  = append_FullFileName_ToTable(fileTable,directoryName)
    nFiles = size(fileTable,1);
    
    for n=1:nFiles
        fullFileName{n,1} = [directoryName '\' fileTable.Files{n}];
    end
    
    fileTable.FullFile = fullFileName;
end