
% % This function changes the Delsys decomposition file names.
% 
% % It should be used if the decomposition file names do not match the
% % current file names. For example, I used this function when I decomposed
% % my data very early, then later changed my file naming scheme. Files no
% % longer matched, so I needed to change the file names in the decomp
% % folder, rather than re-decomposing.
% 
% %EXAMPLE CODE
% % decompWorkspaceName = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AL\decomp\BicepsStroke_AL_Workspace';
% % oldString = 'AL_RBiceps_2Array';
% % newString = 'AL_CTR_R_2Array';

function change_FileName_InDecompWorkspace(decompWorkspaceName,oldString,newString)

    [files,dates] = get_AllFilesWithExtension(decompWorkspaceName,'.mat');
    decompWorkspaceFile = [decompWorkspaceName '\' files{1}];
    
    rename_WorkspaceFiles(decompWorkspaceFile,oldString,newString);
    rename_OLDEMD_and_OLDHPF(decompWorkspaceName,oldString,newString);
    rename_MUDataFileLookup(decompWorkspaceName,oldString,newString);
    rename_MUArchive(decompWorkspaceName,oldString,newString);
       
end

function rename_MUArchive(decompWorkspaceName,oldString,newString)
    
    archiveFolder = [decompWorkspaceName '\MUArchive'];

    workspaceFiles = dir(archiveFolder);
    workspaceFiles = workspaceFiles(3:end);
    
    for i=1:length(workspaceFiles)
        archiveFile = [archiveFolder '\' workspaceFiles(i).name];
        load(archiveFile);
        
        for n=1:length(DecompFileInput)
           DecompFileInput{n} = strrep(DecompFileInput{n},oldString,newString); 
        end

        save(archiveFile,'DecompFileFolderInput',...
                                 'DecompFileHeader',...
                                 'DecompFileInput',...
                                 'DecompFileStorageInput',...
                                 'EMDFileFolderInput',...
                                 'EMDFileInput',...
                                 'EMDFileStorageInput',...
                                 'GroupInfoInput',...
                                 'HPFFileFolderInput',...
                                 'HPFFileInput',...
                                 'HPFFileStorageInput',...
                                 'WorkspaceSetup');

        clear DecompFileFolderInput 
        clear DecompFileHeader                   
        clear DecompFileInput
        clear DecompFileStorageInput       
        clear EMDFileFolderInput    
        clear EMDFileInput                      
        clear EMDFileStorageInput
        clear GroupInfoInput                        
        clear HPFFileFolderInput
        clear HPFFileInput
        clear HPFFileStorageInput
        clear WorkspaceSetup

    end
end

function rename_MUDataFileLookup(decompWorkspaceName,oldString,newString)
    % Replace MU MATCH FILE
    muFile = [decompWorkspaceName '\MUDataFileLookup.txt'];
    fid = fopen(muFile);
    f = fread(fid,'*char')';
    fclose(fid);
    
    f=strrep(f,oldString,newString);
    
    fid_new = fopen(muFile,'wt');    
    fwrite(fid_new,f);
    fclose(fid_new);
    
    clear fid fid_new
end

function rename_OLDEMD_and_OLDHPF(decompWorkspaceName,oldString,newString)
    theDir = dir(decompWorkspaceName);
    theDir = theDir(3:end);
    
    for n=1:length(theDir)
       if isempty(strfind(theDir(n).name,'dEMG'))
          ind(n,1) = false; 
       else
          ind(n,1) = true;
       end
    end
        
    theDir = theDir(ind);
    
    for n=1:length(theDir)
        theFolder = [decompWorkspaceName '\' theDir(n).name]; 
        theContents = dir(theFolder);
        replace_OldEMDFiles(theFolder,theContents,newString,oldString);
        replace_OldHPFFiles(theFolder,theContents,newString,oldString);   
    end
end

function rename_WorkspaceFiles(decompWorkspaceFile,oldString,newString)
    load(decompWorkspaceFile);
    
    for n=1:length(EMDFileInput)
        EMDFileInput{n} = strrep(EMDFileInput{n},oldString,newString);
    end 
    for n=1:length(HPFFileInput)
       HPFFileInput{n} = strrep(HPFFileInput{n},oldString,newString); 
    end
    
    save(decompWorkspaceFile,'DecompFileFolderInput',...
                             'DecompFileHeader',...
                             'DecompFileInput',...
                             'DecompFileStorageInput',...
                             'EMDFileFolderInput',...
                             'EMDFileInput',...
                             'EMDFileStorageInput',...
                             'GroupInfoInput',...
                             'HPFFileFolderInput',...
                             'HPFFileInput',...
                             'HPFFileStorageInput',...
                             'WorkspaceSetup');
                         
end

function replace_OldEMDFiles(theFolder,theContents,newString,oldString)
    for i=1:length(theContents)
       if ~isempty(strfind(theContents(i).name,'OldEMD.mat'))
           theFile = [theFolder '\' theContents(i).name];
           load(theFile);
           OrigEMDIterName = strrep(OrigEMDIterName,oldString,newString);
           save(theFile,'OrigEMDIterName');
       end
    end
end

function replace_OldHPFFiles(theFolder,theContents,newString,oldString)
    for i=1:length(theContents)
       if ~isempty(strfind(theContents(i).name,'OldHPF.mat'))
           theFile = [theFolder '\' theContents(i).name];
           load(theFile);
           OrigHPFFileName = strrep(OrigHPFFileName,oldString,newString);
           save(theFile,'OrigHPFFileName');
       end
    end
end
