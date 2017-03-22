


function [files,dates] = get_AllFilesWithExtension(directoryName,ext)
    files     = dir( fullfile(directoryName,['*' ext]) );
    
    for n=1:length(files)
        dates(n,1)     = files(n).datenum;
    end
    [~,files] = cellfun(@fileparts, {files.name}   , 'UniformOutput',false);
    
    for n=1:length(files)
       files{n} = [files{n} ext]; 
    end
    
    files = files';
end