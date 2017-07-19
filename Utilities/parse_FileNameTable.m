%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Parses file names in a table and returns parsed info
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%   
%   INPUT: 
%   - fileTable = table with all the files. Must have field "Files"
%   - options including
%       File naming conventions
%    
%   OUTPUT: 
%   - tbl_out = table with information from each file (eg. SID,... etc)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .FileNameConvention = the naming convention used for each file 
%                               (Fields must be separated by underscores)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function tbl_out = parse_FileNameTable(fileTable,options)

    allFields = options.FileNameConvention;
    
    for i=1:length(allFields) 
        for n=1:size(fileTable,1)
            theFile        = fileTable.Files{n};
            targetField    = allFields{i};
            cellArray{n,i} = extract_Information_FromFileName(theFile,...
                                                              allFields,...
                                                              targetField);
        end
    end
    
    tmp = array2table(cellArray);
    tmp.Properties.VariableNames = allFields;
    
    tbl_out = [fileTable,tmp];
end