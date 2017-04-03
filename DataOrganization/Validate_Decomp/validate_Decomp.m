
% % This function validates that the decomposition was done correctly
%  
%  % The file checks that
%     % 1) All trials were set up for decomposition
%     % 2) The correct EMG channels were decomposed
%     % 3) Decomposition outputs were obtained from Delsys dEMG
%     % 4) Decompositions were exported
    
    
function decompValidation = validate_Decomp(subjDir,options)
        
    decompInput_tbl = get_DecompInputs_FromSubjectFolder(subjDir,options.DecompInput);
    decompInput_tbl = append_FileID_Tag(decompInput_tbl,options.DecompInput);
    
    decompOutput_tbl = get_DecompOutputs_FromSubjectFolder(subjDir,options);
    decompOutput_tbl = append_FileID_Tag(decompOutput_tbl,options.DecompOutput);
 
    decompExport_tbl = get_DecompExports_FromSubjectFolder(subjDir,options);
    decompExport_tbl = append_FileID_Tag(decompExport_tbl,options.DecompExport);
    
    sensorArray_tbl = get_SensorArrayFileInfo_FromSubjectFolder(subjDir,options);
    sensorArray_tbl = append_FileID_Tag(sensorArray_tbl,options.SensorArray);
    
    matchInput  = assemble_ValidationTable(sensorArray_tbl,decompInput_tbl ,'NoDecompInput' ,'DecompInputChannels','DecompChannels',options);    
    matchOutput = assemble_ValidationTable(sensorArray_tbl,decompOutput_tbl,'NoDecompOutput','DecompOutputFiles'  ,'OutputFiles'   ,options); 
    matchExport = assemble_ValidationTable(sensorArray_tbl,decompExport_tbl,'NoDecompExport','DecompExportFiles'  ,'ExportFiles'   ,options); 
    
    decompValidation = [matchInput(:,1), matchInput(:,2), matchOutput(:,2), matchExport(:,2), matchInput(:,3), matchOutput(:,3), matchExport(:,3)];
end


function tbl_match = assemble_ValidationTable(sensorArray_tbl, target_tbl,emptyCellName,varName,targetName,options)

    
    tbl_match = initialize_ValidationTable([],[],varName);
    
    IDs = unique(sensorArray_tbl.FileID_Tag);
    for n=1:length(IDs)
        
        tmp = initialize_ValidationTable(IDs(n),emptyCellName,varName);
        
        tbl_FileID = find_FilesMatchingIDTag(target_tbl,IDs(n));
        if ~isempty(tbl_FileID)
            tmp = process_DecomposedFiles(tbl_FileID,targetName,varName,tmp,options);
        end
        tbl_match = [tbl_match;tmp];
    end
end


function tmp = process_DecomposedFiles(tbl_FileID,targetName,varName,tmp,options)

    nFiles = size(tbl_FileID,1);

    
    if sum(ismember(tbl_FileID.Properties.VariableNames,{'Array'}))
        nArrays = options.NumberOfArrays;
        arrayData = cell(1,nArrays);
        for i=1:nFiles
            array = str2double(tbl_FileID.Array{i});
            arrayData(array) = {[arrayData{array}, tbl_FileID.(targetName)(i)]};
        end
        
        for i=1:nArrays
            if ~isempty(arrayData{i})
                tmp.([varName '_' num2str(i)]) = arrayData(i);
            end
        end
    elseif size(tbl_FileID,1)>1
        for i=1:size(tbl_FileID.(targetName),1)
            tmp.([varName '_' num2str(i)]) = tbl_FileID.(targetName)(i);
        end
    else
        for i=1:size(tbl_FileID.(targetName),2)
            tmp.([varName '_' num2str(i)]) = tbl_FileID.(targetName)(i);
        end
    end
    
end


%             if size(tbl_FileID,1)>1
%                 
%                 
%                 for i=1:size(tbl_FileID,1)
%                     
%                 end
%                 
%                 for i=1:size(tbl_FileID,1)
%                     tmp.([varName '_' num2str(i)]) = tbl_FileID.(targetName)(i);
%                 end
%             else
%                 for i=1:size(tbl_FileID.(targetName),2)
%                     tmp.([varName '_' num2str(i)]) = tbl_FileID.(targetName)(i);
%                 end
%             end



function tbl = find_FilesMatchingIDTag(tbl,ID)

    ind = tbl.FileID_Tag == ID;
    tbl = tbl(ind,:);

end

function tmp = initialize_ValidationTable(ID,emptyCellName,varName)

    if ~isempty(emptyCellName)
        tmp = table(ID,...
                    {emptyCellName},...
                    {emptyCellName},...
                            'VariableNames',...
                                     {'SensorArray_FileID_Tag',...
                                      [varName '_1'],...
                                      [varName '_2']  } );
    else
        tmp = table([],{},{},'VariableNames',{'SensorArray_FileID_Tag',[varName '_1'],[varName '_2']} );
    end
end



















% 
% 
% 
% function tbl_match = assemble_ValidationTable(sensorArray_tbl, decompInput_tbl)
% 
%     IDs = unique(sensorArray_tbl.FileID_Tag);
% 
%     tbl_match      = blank_ValidationTable();
%     tbl_match(1,:) = [];
% 
%     for n=1:length(IDs)
% 
%         ind        = decompInput_tbl.FileID_Tag == IDs(n);
%         tbl_FileID = decompInput_tbl(ind,:);
% 
%         tmp = blank_ValidationTable();
%     
%         if ~isempty(tbl_FileID)
%             if size(tbl_FileID,1)>1
%                 for i=1:size(tbl_FileID,1)
%                     tmp.(['DecompInputChannels_' num2str(i)]) = tbl_FileID.DecompChannels(i);
%                 end
%             else
%                 for i=1:size(tbl_FileID.DecompChannels,2)
%                     tmp.(['DecompInputChannels_' num2str(i)]) = tbl_FileID.DecompChannels(i);
%                 end
%             end
%         end
%         tbl_match = [tbl_match;tmp];
%     end
% end





% function tmp = blank_ValidationTable()
%     tmp = table(IDs(n),...
%                     {'NoDecompInput'},...
%                     {'NoDecompInput'},...
%                     {'NoDecompOutput'},...
%                     {'NoDecompOutput'},...
%                     {'NoDecompExport'},...
%                     {'NoDecompExport'},...
%                             'VariableNames',...
%                                     {'SensorArray_FileID_Tag',...
%                                      'DecompInputChannels_1',...
%                                      'DecompInputChannels_2',...
%                                      'DecompOutput_1',...
%                                      'DecompOutput_2',...
%                                      'DecompExport_1',...
%                                      'DecompExport_2'  }   );
% end




% tbl_match = table(categorical({}),{},{},'VariableNames',...
%                                                 {'SensorArray_FileID_Tag',...
%                                                  'DecompInputChannels_1',...
%                                                  'DecompInputChannels_2',...
%                                                  'DecompOutput_1',...
%                                                  'DecompOutput_2',...
%                                                  'DecompExport_1',...
%                                                  'DecompExport_2'  }   );


%     decompOutput_tbl = get_DecompOutputs_FromFolder(decompWorkspace);
%     decompOutput_tbl.Properties.VariableNames{1} = 'Files';
%     decompOutput_tbl = parse_FileNameTable(decompOutput_tbl,options.DecompOutput);
%     decompOutput_tbl = split_Decomp_RepID(decompOutput_tbl);
%     decompOutput_tbl = append_FileID_Tag(decompOutput_tbl,options.DecompOutput);

%     decompOutput_tbl.Properties.VariableNames{1} = 'Files';
%     decompOutput_tbl = parse_FileNameTable(decompOutput_tbl,options.DecompOutput);
%     decompOutput_tbl = split_Decomp_RepID(decompOutput_tbl);
%     decompOutput_tbl = append_FileID_Tag(decompOutput_tbl,options.DecompOutput);

