%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - This function validates that the decomposition was done correctly by
%     checking if:
%       1) All trials were set up for decomposition
%       2) The correct EMG channels were decomposed
%       3) Decomposition outputs were obtained from Delsys dEMG
%       4) Decompositions were exported
%
%   BEFORE RUNNING, SETUP:
%   - Configure using "Utility_RUN_Create_DecompValidationTable.m"
%   
%   INPUT: 
%   - options including
%       File naming conventions 
%       Sensor array location information
%   - masterFolder = the directory (usu subj folder) that has subfolders for
%        array
%        decomp
%        hpf
%        singlediff
%        smr
%        trial_information
%    
%   OUTPUT: 
%   - Appends extra 'Array' struct to each SensorArray.mat file
%          Array struct contains: 
%           MUFiringTimes 
%           MUAPs
%           Array info
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .DecompInput
%      .DecompOutput
%      .DecompExport
%      .SensorArray
%         Each with
%          .FileNameConvention = the naming convention used for each file type
%          .FileID_Tag = the way to identify files that come from the same trial
%
%      .Array = Information about the sensor arrays used in the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
function decompValidation = create_DecompValidationTable(masterFolder,options)
    
    %Parse file names and append File ID Tag to identify files
    decompInput = get_DecompInputs_FromSubjectFolder(masterFolder,options.DecompInput);
    decompInput = append_FileID_Tag(decompInput,options.DecompInput);
    
    decompOutput = get_DecompOutputs_FromMasterFolder(masterFolder,options);
    decompOutput = append_FileID_Tag(decompOutput,options.DecompOutput);
 
    decompExport = get_DecompExports_FromMasterFolder(masterFolder,options);
    decompExport = append_FileID_Tag(decompExport,options.DecompExport);
    
    sensorArray = get_SensorArrayFileInfo_FromMasterFolder(masterFolder,options);
    sensorArray = append_FileID_Tag(sensorArray,options.SensorArray);
    
    %Check that Decomp Input, Decomp Output, and Decomp Exports all match
    %the Sensor Array files. IE, for each sensor array file, was the file
    %added to decomp? Did decomp happen? Was decomp exported?
    matchInput  = assemble_ValidationTable(sensorArray,decompInput ,'NoDecompInput' ,'DecompInputChannels','DecompChannels',options);    
    matchOutput = assemble_ValidationTable(sensorArray,decompOutput,'NoDecompOutput','DecompOutputFiles'  ,'OutputFiles'   ,options); 
    matchExport = assemble_ValidationTable(sensorArray,decompExport,'NoDecompExport','DecompExportFiles'  ,'ExportFiles'   ,options); 
    
    decompValidation = [matchInput(:,1),...
                        matchInput(:,2),...
                        matchOutput(:,2),...
                        matchExport(:,2),...
                        matchInput(:,3),...
                        matchOutput(:,3),...
                        matchExport(:,3)];
end


function tbl_match = assemble_ValidationTable(sensorArray_tbl, target_tbl, emptyCellName, varName, targetName, options)

    
    tbl_match = initialize_ValidationTable([],[],varName);
    
    %Loop over Sensor Array files - check that ID Tags in the target table
    %match ID tags in the sensor array table
    IDs = unique(sensorArray_tbl.FileID_Tag);
    for n=1:length(IDs)
        
        tmp = initialize_ValidationTable(IDs(n),emptyCellName,varName);
        
        tbl_FileID = find_FilesMatchingIDTag(target_tbl,IDs(n));
        if ~isempty(tbl_FileID) %If id tags match sensor array, further parse decomp files
            tmp = process_DecomposedFiles(tbl_FileID,targetName,varName,tmp,options);
        end
        tbl_match = [tbl_match;tmp];
    end
end


function tmp = process_DecomposedFiles(tbl_FileID, targetName, varName, tmp, options)

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








