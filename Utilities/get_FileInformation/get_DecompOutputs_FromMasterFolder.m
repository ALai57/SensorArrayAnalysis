%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Fetches information from files in decomp workspace folder ("decomp/workspace name) 
%     by parsing file names
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%   
%   INPUT: 
%   - masterFolder = the directory (usu subj folder) that has subfolders for
%        array
%        decomp
%        hpf
%        singlediff
%        smr
%        trial_information
%   - options including
%       File naming conventions
%    
%   OUTPUT: 
%   - DO_FileInfo = table with information from each file (eg. SID,... etc)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .DecompOutput
%       .FileNameConvention = the naming convention used for each file 
%                               (Fields must be separated by underscores)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% decompWorkspace = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\BA\decomp\BicepsStroke_BA_Workspace';

function DO_FileInfo = get_DecompOutputs_FromMasterFolder(masterFolder,options)

    decompWorkspace  = get_SubjectDecompWorkspace(masterFolder);
    
    DO_FileInfo = get_Basic_DecompOutputInfo(decompWorkspace);
    DO_FileInfo = parse_FileNameTable(DO_FileInfo,options.DecompOutput);
    DO_FileInfo = split_Decomp_RepID(DO_FileInfo);
%     decompOutput_tbl = append_DecompLabels(decompOutput_tbl);
%     decompOutput_tbl = append_DecompChannels(decompOutput_tbl,decompWorkspace);
    
    DO_FileInfo.Properties.VariableNames{1} = 'OutputFiles';
end

function tbl = get_Basic_DecompOutputInfo(decompWorkspace)

    x=tdfread([decompWorkspace '\MUDataFileLookup.txt']);
    
    for j=1:size(x.FileLabel,1)
        FileLabel(j,1)        = {strtrim(x.FileLabel(j,:))};
        StoredFileName(j,1)   = {strtrim(x.StoredFileName(j,:))}; 
        StoredFileFolder(j,1) = {strtrim(x.StoredFileFolder(j,:))}; 
    end
    
    tbl = table(FileLabel,...
                StoredFileName,...
                StoredFileFolder,...
                    'VariableNames',...
                        {'Files',...
                         'StoredFileName',...
                         'StoredFileFolder'});
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
        specsFile = [decompWorkspace '\' ...
                     tbl.StoredFileFolder{j} '\' ...
                     tbl.StoredFileFolder{j} '.' ...
                     tbl.decompLabel{j} '_MUSpecs.mat'];
        
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
