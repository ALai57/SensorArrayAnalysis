


function [theInfo] = parse_FileName(theFile,allFields,targetField)

    [~, name, ~] = fileparts(theFile); 
    file_parts   = strsplit(name,'_');
    
    %Check that the file matches the naming convention
    if length(file_parts) ~= length(allFields)
       display(['This file is not named correctly:', char(13), theFile])
       fConvention = sprintf('%s_', allFields{:});
       display(['Naming convention is: ' fConvention(1:end-1) '.mat']);
       error('File does not meet the naming convention')
    end
    
    %Find the target field
    for n=1:length(allFields)
        if isequal(allFields{n}, targetField)
            break;
        end
        if n==length(allFields)
            error(sprintf('Field not found: %s',targetField))
        end
    end
    
    theInfo = file_parts{n};
end