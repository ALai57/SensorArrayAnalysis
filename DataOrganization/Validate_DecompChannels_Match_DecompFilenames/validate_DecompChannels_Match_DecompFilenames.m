

% Validation check of MU decomp matchups

% analysisDirs{1} = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';
% analysisDirs{1} = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke';

function tbl = validate_DecompChannels_Match_DecompFilenames(analysisDirs)

    tbl = [];  
    for n=1:length(analysisDirs) % Loop over all analysis directories
        
        fid = create_Log(analysisDirs{n});
        print_DirectoryName_ToLog(fid,analysisDirs{n});
        contents = get_DirectoryContents(analysisDirs{n});
        
        for i=3:length(contents)  
            tbl = [tbl; validate_ChannelAndFilenameMatch_ForSubject(contents(i),fid)];
        end
        
        fclose(fid);
    end
    
   
    %Make output table: Number of files, number with given ending, number
    %correct. Index of incorrect.
end

function fid = create_Log(analysisDirs)

    fid = fopen([analysisDirs '\Validation_DecompChannels_Match_DecompFilenames.txt'],'wt');
    fprintf(fid,'Report: Delsys sensor array decomposition \n\n%s\n',date());
    fprintf(fid,'Description: Checking to make sure that file naming is consistent. (For multiple arrays, the file name should reflects the channels that were decomposed)\n');
    fprintf(fid,'Before moving to further analysis it is important to check that decomposition results were named properly\n\n\n');
  
end

function fid = print_DirectoryName_ToLog(fid,analysisDir)
    fprintf(fid,'Analysis directory: %s\n\n',analysisDir);
end

function contents = get_DirectoryContents(analysisDir)
    contents = dir(analysisDir);
end

function tbl = validate_ChannelAndFilenameMatch_ForSubject(contents,fid)
    
    if length(contents.name)>8
        tbl = [];
        return;
    end

    decompWorkspace = get_DecompWorkspaceName(contents);
    
    try   
%         tbl = get_DecompFileInfo_FromFolder(decompWorkspace);
        tbl = get_DecompOutputs_FromFolder(decompWorkspace);
        
        fprintf(fid,'SID: %s. ',contents.name); 
        check_decompLabel_Matches_DecompFilename(tbl,fid)
    catch
        fprintf(fid,'SID: %s. Subject decomp not found \n',contents.name) 
        tbl = [];
    end
    
end

function decompWorkspace = get_DecompWorkspaceName(contents)
    decompDir = [contents.folder '\' contents.name '\decomp'];

    files = dir(decompDir);
    folders = files([files.isdir]);
    decompWorkspace = [decompDir '\' folders(end).name];
end

function check_decompLabel_Matches_DecompFilename(tbl,fid)

    tbl.decompLabel = categorical(tbl.decompLabel);
    decompLabels    = unique(tbl.decompLabel);

    for n=1:length(decompLabels)
       ind_label = tbl.decompLabel    == decompLabels(n);
       i         = find(ind_label,1,'first');
       
       for j=1:size(tbl,1)
            ind_ch(j,1) = isequal(tbl.decompChannels(j), tbl.decompChannels(i));
       end

       if isequal(ind_label,ind_ch)
          matchText   = sprintf('Rep ID last digit ''%s'' matched with channels [%d,%d,%d,%d]. ',char(decompLabels(n)),tbl.decompChannels{i});
          fprintf(fid,matchText);   
       else
          matchText   = sprintf('Rep ID last digit ''%s'' NOT matched with channels .',char(decompLabels(n)));
          fprintf(fid, matchText); 
       end
    end
    fprintf(fid,'\n');
    
end