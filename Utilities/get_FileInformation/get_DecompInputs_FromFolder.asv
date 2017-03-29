
% decompWorkspace = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT\decomp\WT_MUWorkspace';

function decompInputs_tbl = get_DecompInputs_FromFolder(decompWorkspace)

    archiveFolder = [decompWorkspace '\MUArchive'];

    workspaceFiles = dir(archiveFolder);
    workspaceFiles = workspaceFiles(3:end);
%     ind            = [workspaceFiles.datenum] == max([workspaceFiles.datenum]);
    
    decompInputs_tbl = [];
    for i=1:length(workspaceFiles)
        load([archiveFolder '\' workspaceFiles(i).name]);

        for n=1:length(DecompFileInput)
            inputFiles(n,1)    = DecompFileInput(n);
            Channels(n,1) = {DecompFileHeader{n}.DecompChIdx}; 
        end
        tbl_inputs = table(inputFiles,Channels,'VariableNames',{'InputFiles','Channels'});

        files = unique(inputFiles);
        for n=1:length(files)
            ind = tbl_inputs.InputFiles == categorical(files(n));
            ind = find(ind);
            for j=1:length(ind)
               fileChannels(n,j) = tbl_inputs.Channels(ind(j));
            end
        end

        tbl_out = table(files,fileChannels,'VariableNames',{'InputFiles','DecompChannels'});
        decompInputs_tbl = [decompInputs_tbl;tbl_out];
        
        clear files fileChannels
        clear inputFiles
        clear Channels
    end
        
end
