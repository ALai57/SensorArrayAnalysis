

function tbl = get_DecompFileInfo_FromFolder(decompWorkspace)
    tbl = get_Basic_DecompFileInfo(decompWorkspace);
    tbl = append_DecompLabels(tbl);
    tbl = append_DecompChannels(tbl,decompWorkspace);      
end

function tbl = get_Basic_DecompFileInfo(decompWorkspace)

    x=tdfread([decompWorkspace '\MUDataFileLookup.txt']);
    
    for j=1:size(x.FileLabel,1)
        FileLabel(j,1)        = {strtrim(x.FileLabel(j,:))};
        StoredFileName(j,1)   = {strtrim(x.StoredFileName(j,:))}; 
        StoredFileFolder(j,1) = {strtrim(x.StoredFileFolder(j,:))}; 
    end
    
    tbl = table(FileLabel,StoredFileName,StoredFileFolder,'VariableNames',{'FileLabel','StoredFileName','StoredFileFolder'});
   
end

function tbl = append_DecompLabels(tbl)

    for j=1:size(tbl,1)
        decompLabel(j,1) = {tbl.FileLabel{j}(end-4)}; 
    end    
    decompLabel = table(decompLabel,'VariableNames',{'decompLabel'});
    tbl = [tbl,decompLabel];

end

function tbl = append_DecompChannels(tbl,decompWorkspace)

    for j=1:size(tbl,1)
        specsFile = [decompWorkspace '\' tbl.StoredFileFolder{j} '\' tbl.StoredFileFolder{j} '.' tbl.decompLabel{j} '_MUSpecs.mat'];
        
        if exist(specsFile)
            load(specsFile) 
            decompChannels(j,1) = {NextMUAnalysisSpecs.DecompChIdx};
        else
            decompChannels(j,1) = {[]};
        end
    end
    decompChannels = table(decompChannels,'VariableNames',{'decompChannels'});
    tbl = [tbl,decompChannels];
    
end
