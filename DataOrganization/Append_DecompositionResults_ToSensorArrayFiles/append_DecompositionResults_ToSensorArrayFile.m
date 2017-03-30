
%Select subject folder
%     subjFolder = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\AC';
% 
%     options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
%     options.Decomp.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
%     options.FileID_Tag = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
   
function append_DecompositionResults_ToSensorArrayFile(subjFolder,options)
    
    fid = open_LogFile([subjFolder '\array']);
    
    tbl_SensorArray = get_SensorArrayFileInfo_FromSubjectFolder(subjFolder,options);
    tbl_SensorArray = append_FileID_Tag(tbl_SensorArray,options);
    
    tbl_DecompExports      = get_DecompExports_FromSubjectFolder(subjFolder,options); 
    tbl_DecompExports      = append_FileID_Tag(tbl_DecompExports,options);
    
    tbl_DecompOutputs      = get_DecompOutputs_FromSubjectFolder(subjFolder,options); 
    tbl_DecompOutputs      = append_FileID_Tag(tbl_DecompOutputs,options);
    
    tbl_DecompValidation = validate_Decomp(subjFolder,options);
    
    if ~isequal(tbl_DecompValidation.SensorArray_FileID_Tag,tbl_SensorArray.FileID_Tag)
        error('Decompositions not valid - Sensor Array File IDs not the same as validation File IDs')    
    end
        
    fprintf(fid,'%d Sensor Array files found.\n',size(tbl_SensorArray,1));
    fprintf(fid,'%d Decomposition files found.\n\n\n',size(tbl_DecompExports,1));
    
    for i=1:size(tbl_SensorArray,1)
        
        fName_Array = [subjFolder '\array\' tbl_SensorArray.Files{i}];
        ind = tbl_DecompExports.FileID_Tag == tbl_SensorArray.FileID_Tag(i);
        ind = find(ind);
        
        ind2 = tbl_DecompValidation.SensorArray_FileID_Tag == tbl_SensorArray.FileID_Tag(i);
        if isempty(ind) 
            Array = create_DefaultArray(tbl_DecompValidation(ind2,:),options);
            fprintf(fid,'No decomposition files found for %s. Saving empty file.\n',fName_Array);     
        else
            Array = get_DecompositionInfo(tbl_DecompExports(ind,:),tbl_DecompValidation(ind2,:),subjFolder,options);
        end
        
        %Resave
%         save(fName_Array,'Array','-append');
        load(fName_Array,'tbl');
        save(fName_Array,'tbl','Array');
        fprintf(fid,'Saving complete. %d decomposition files combined with %s.\n',length(ind),fName_Array);
        
    end
    fclose(fid);
    fprintf('Subject folder complete: %s.\n',subjFolder);
end

function Array = create_DefaultArray(decompValidation,options)
    
    nArrays = length(options.Array.Number);
    
    for n=1:nArrays
       Array(n).Decomp         = {};
       Array(n).DecompChannels = decompValidation.(['DecompInputChannels_' num2str(n)]);
       Array(n).Number         = categorical(options.Array.Number(n));
       Array(n).Location       = options.Array.Names{n}; 
    end
end

function fid = open_LogFile(subjArrayFolder)
    fid = fopen([subjArrayFolder '\Combine_SensorArrayFile_And_Decomposition.txt'],'wt');
    fprintf(fid,'LOG\n\n%s\n\n',date());
    fprintf(fid,'Because Delsys Decomposition only outputs Firing times and MU Templates, it is necessary to re-combine the decomposition with Force and EMG data\n');
    fprintf(fid,'This log details which files were combined\n\n\n');
end

function Array = get_DecompositionInfo(tbl_Decomp,tbl_DecompValidation,subjFolder,options)
        
    tbl_Decomp.Array    = categorical(tbl_Decomp.Array);
    tbl_Decomp.FileType = categorical(tbl_Decomp.FileType);
    
    arrays = unique(options.Array.Number); % GET THIS FROM OPTIONS %%%%%%%%%%%%%%%%%%% ARRAY 1 and 2....
    arrays = categorical(arrays);
    
    ind_firings = tbl_Decomp.FileType == 'MUFiringTimes';
    ind_MUAPs   = tbl_Decomp.FileType == 'MUAPs';
    
    Array = create_DefaultArray(tbl_DecompValidation,options);
    
    for j=1:length(arrays)
        
        ind_array = tbl_Decomp.Array == arrays(j);
        
        i_f = ind_array & ind_firings; %Index of the MU_FiringTimes.txt file
        i_m = ind_array & ind_MUAPs;   %Index of the MUAPs.txt file
%         
%         Array(j).DecompChannels = tbl_DecompValidation.(['DecompInputChannels_' num2str(j)]);
        
        if ~sum(i_f) || ~sum(i_m)
           continue; 
        end
        
        fName_MUAPs = [subjFolder '\decomp\' tbl_Decomp.ExportFiles{i_m}];
        x=importdata(fName_MUAPs);

        fName_Firings = [subjFolder '\decomp\' tbl_Decomp.ExportFiles{i_f}];
        y=importdata(fName_Firings);
        
        for k=1:max(x.data(:,1))
            ind_MU = x.data(:,1)==k;

            Array(j).Decomp(k).Templates = table(x.data(ind_MU,2),...
                                        x.data(ind_MU,3),...
                                        x.data(ind_MU,4),...
                                        x.data(ind_MU,5),...
                                        x.data(ind_MU,6),...
                                        'VariableNames',...
                                            {'Time',...
                                             'Ch1',...
                                             'Ch2',...
                                             'Ch3',...
                                             'Ch4'}   );
        end

        for k=1:size(y.data,2)
            theData = y.data(:,k);
            theData(isnan(theData))=[];
            Array(j).Decomp(k).FiringTimes = theData;
        end

    end
end
        



%     tbl_Decomp      = get_DecompFileInfo_FromSubjectFolder(subjFolder,options);
%     decompWorkspace = get_SubjectDecompWorkspace(subjFolder);
%     tbl_Decomp      = get_DecompOutputs_FromFolder(decompWorkspace);
%     tbl_Decomp.Properties.VariableNames{1} = 'Files';
%     tbl_Decomp      = parse_FileNameTable(tbl_Decomp,options.Decomp); 
%     tbl_Decomp      = append_FileID_Tag(tbl_Decomp,options);

