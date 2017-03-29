
% decompWorkspace = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA\decomp\BicepsStroke_BA_Workspace';

function decompOutput_tbl = get_DecompOutputs_FromSubjectFolder(subjDir,options)

    decompWorkspace  = get_SubjectDecompWorkspace(subjDir);
    decompOutput_tbl = get_Basic_DecompOutputInfo(decompWorkspace);
    decompOutput_tbl = parse_FileNameTable(decompOutput_tbl,options.DecompOutput);
    decompOutput_tbl = split_Decomp_RepID(decompOutput_tbl);
%     decompOutput_tbl = append_DecompLabels(decompOutput_tbl);
%     decompOutput_tbl = append_DecompChannels(decompOutput_tbl,decompWorkspace);
    
    decompOutput_tbl.Properties.VariableNames{1} = 'OutputFiles';
end

function tbl = get_Basic_DecompOutputInfo(decompWorkspace)

    x=tdfread([decompWorkspace '\MUDataFileLookup.txt']);
    
    for j=1:size(x.FileLabel,1)
        FileLabel(j,1)        = {strtrim(x.FileLabel(j,:))};
        StoredFileName(j,1)   = {strtrim(x.StoredFileName(j,:))}; 
        StoredFileFolder(j,1) = {strtrim(x.StoredFileFolder(j,:))}; 
    end
    
    tbl = table(FileLabel,StoredFileName,StoredFileFolder,'VariableNames',{'Files','StoredFileName','StoredFileFolder'});
   
end

function tbl = append_DecompLabels(tbl)

    for j=1:size(tbl,1)
        decompLabel(j,1) = {tbl.OutputFiles{j}(end-4)}; 
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
