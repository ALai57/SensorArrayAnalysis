
% %Parse file name
% options.Decomp.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
% options.Decomp.FileID_Tag         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
% options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SensorArray.FileID_Tag         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
% subjDir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT';
% 


function tbl_match = validate_DecompInputs(subjDir,options)
    
    decompWorkspace = get_DecompWorkspace(subjDir);
    decompInput_tbl = get_DecompInputs_FromFolder(decompWorkspace);
    decompInput_tbl.Properties.VariableNames{1} = 'Files';
    decompInput_tbl = parse_FileNameTable(decompInput_tbl,options.Decomp);
    decompInput_tbl = append_FileID_Tag(decompInput_tbl,options.Decomp);

    sensorArray_tbl = get_SensorArrayFileInfo_FromSubjectFolder(subjDir,options);
    sensorArray_tbl = append_FileID_Tag(sensorArray_tbl,options.SensorArray);
    
    tbl_match = compare_SensorArrayFiles_AndDecompInputs(sensorArray_tbl, decompInput_tbl);    
    
end

function decompWorkspace = get_DecompWorkspace(subjDir)
    decompFolder = [subjDir '\decomp'];
    dContents = dir(decompFolder);
    dContents = dContents(3:end);
    ind = [dContents.isdir]';
    decompWorkspace = [decompFolder '\' dContents(ind).name];
end

function tbl_match = compare_SensorArrayFiles_AndDecompInputs(sensorArray_tbl, decompInput_tbl)

    IDs = unique(sensorArray_tbl.FileID_Tag);

    tbl_match = table(categorical({}),{},{},'VariableNames',{'SensorArray_FileID_Tag','DecompInputChannels_1','DecompInputChannels_2'});

    for n=1:length(IDs)

        ind        = decompInput_tbl.FileID_Tag == IDs(n);
        tbl_FileID = decompInput_tbl(ind,:);

        tmp = table(IDs(n),...
                    {'NoDecomp'},...
                    {'NoDecomp'},...
                            'VariableNames',...
                                    {'SensorArray_FileID_Tag',...
                                     'DecompInputChannels_1',...
                                     'DecompInputChannels_2'  }   );
    
        if ~isempty(tbl_FileID)
            if size(tbl_FileID,1)>1
                for i=1:size(tbl_FileID,1)
                    tmp.(['DecompInputChannels_' num2str(i)]) = tbl_FileID.DecompChannels(i);
                end
            else
                for i=1:size(tbl_FileID.DecompChannels,2)
                    tmp.(['DecompInputChannels_' num2str(i)]) = tbl_FileID.DecompChannels(i);
                end
            end
        end
        tbl_match = [tbl_match;tmp];
    end
end