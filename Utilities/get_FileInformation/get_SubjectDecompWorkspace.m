
function decompWorkspace = get_SubjectDecompWorkspace(subjDir)
    decompFolder = [subjDir '\decomp'];
    dContents = dir(decompFolder);
    dContents = dContents(3:end);
    ind = [dContents.isdir]';
    decompWorkspace = [decompFolder '\' dContents(ind).name];
end