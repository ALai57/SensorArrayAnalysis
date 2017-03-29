

function  decompExport_tbl = get_DecompExports_FromSubjectFolder(subjDir,options)

    options.Trial = options.DecompExport;
    
    decompFolder     = [subjDir '\decomp'];
    decompExport_tbl = extract_FileInformation_FromFolder(decompFolder,'.txt',options);
   	decompExport_tbl = split_Decomp_RepID(decompExport_tbl);
    decompExport_tbl.Properties.VariableNames{1} = 'ExportFiles';
end
