

function tbl_MATFile = extract_FileInformation_FromFolder(directoryName,ext,options)
    [matFiles,datenum] = get_AllFilesWithExtension(directoryName,ext);
    tbl_MATFile        = table(matFiles,datenum,'VariableNames',{'Files','Datenum'});
    tbl_MATFile        = parse_FileNameTable(tbl_MATFile,options.Trial);
    tbl_MATFile        = append_FullFileName_ToTable(tbl_MATFile,directoryName);
end

function tbl_MATFile  = append_FullFileName_ToTable(tbl_MATFile,directoryName)
    nFiles = size(tbl_MATFile,1);
    
    for n=1:nFiles
        fullFileName{n,1} = [directoryName '\' tbl_MATFile.Files{n}];
    end
    
    tbl_MATFile.FullFile = fullFileName;
end