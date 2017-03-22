
function [theInfo] = extract_Information_FromFileName(theFile,options,desiredInformation)

    [~, name, ~] = fileparts(theFile); 
    file_parts   = strsplit(name,'_');
    
    %Check that the file matches the naming convention
    if length(file_parts) ~= length(options.FileNameConvention)
       display(['This file is not named correctly:', char(13), theFile])
       fConvention = sprintf('%s_', options.FileNameConvention{:});
       display(['Naming convention is: ' fConvention(1:end-1) '.mat']);
       error('File does not meet the naming convention')
    end
    
    %Find the condition the SMR file was created under
    for n=1:length(options.FileNameConvention)
        if isequal(options.FileNameConvention{n}, desiredInformation)
            break;
        end
        if n==length(options.FileNameConvention)
            error(sprintf('Field not found: %s',desiredInformation))
        end
    end
    
    theInfo = file_parts{n};
end