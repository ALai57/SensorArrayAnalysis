

%Validate that the decomposition channels match the given file names

analysisDirs{1} = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';

tbl = validate_DecompChannels_Match_DecompFilenames(analysisDirs);


%Parse file name
options.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
options.FileID_Tag         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'}; 
   
tbl.Properties.VariableNames{1} = 'Files';
tbl_out = parse_FileNameTable(tbl,options);
tbl_out = split_Decomp_RepID(tbl_out);
tbl_out = append_FileID_Tag(tbl_out,options);

IDs = unique(tbl_out.FileID_Tag);

tbl_decomp = table(categorical({}),{},{},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});
tmp = table(categorical({}),{},{},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});

for n=1:length(IDs)
    
    ind = tbl_out.FileID_Tag == IDs(n);
    
    tbl_FileID = tbl(ind,:);
    
    tmp = table(categorical({''}),{''},{''},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});

    tmp.FileID_Tag = IDs(n);
    
    for i=1:size(tbl_FileID,1)
        decompLabel = tbl_FileID.decompLabel{i};
        tmp.(['Decomp_' decompLabel '_Channels']) = tbl_FileID.decompChannels(i);
    end
    tbl_decomp = [tbl_decomp;tmp];
end

%Make Assign decomp ID

%Print output.



analysisDirs{1} = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke';

tbl = validate_DecompChannels_Match_DecompFilenames(analysisDirs);


%Parse file name
options.FileNameConvention = {'SID','ArmInfo','Experiment','TargetForce','Rep','ID'};
options.FileID_Tag         = {'SID','ArmInfo','Experiment','TargetForce','Rep','ID'};
   
tbl.Properties.VariableNames{1} = 'Files';
tbl_out = parse_FileNameTable(tbl,options);
tbl_out = split_Decomp_RepID(tbl_out);
tbl_out = append_FileID_Tag(tbl_out,options);

IDs = unique(tbl_out.FileID_Tag);

tbl_decomp = table(categorical({}),{},{},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});
tmp = table(categorical({}),{},{},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});

for n=1:length(IDs)
    
    ind = tbl_out.FileID_Tag == IDs(n);
    
    tbl_FileID = tbl(ind,:);
    
    tmp = table(categorical({''}),{''},{''},'VariableNames',{'FileID_Tag','Decomp_1_Channels','Decomp_2_Channels'});

    tmp.FileID_Tag = IDs(n);
    
    for i=1:size(tbl_FileID,1)
        decompLabel = tbl_FileID.decompLabel{i};
        tmp.(['Decomp_' decompLabel '_Channels']) = tbl_FileID.decompChannels(i);
    end
    tbl_decomp = [tbl_decomp;tmp];
end

