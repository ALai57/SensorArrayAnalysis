
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
%     tbl_Decomp      = get_DecompFileInfo_FromSubjectFolder(subjFolder,options);
    decompWorkspace = get_SubjectDecompWorkspace(subjFolder);
    tbl_Decomp      = get_DecompOutputs_FromFolder(decompWorkspace);
    tbl_Decomp.Properties.VariableNames{1} = 'Files';
    tbl_Decomp      = parse_FileNameTable(tbl_Decomp,options.Decomp); 
    tbl_Decomp      = append_FileID_Tag(tbl_Decomp,options);
    
    fprintf(fid,'%d Sensor Array files found.\n',size(tbl_SensorArray,1));
    fprintf(fid,'%d Decomposition files found.\n\n\n',size(tbl_Decomp,1));
    
    for i=1:size(tbl_SensorArray,1)
        
        fName_Array = [subjFolder '\array\' tbl_SensorArray.Files{i}];
        ind = tbl_Decomp.FileID_Tag == tbl_SensorArray.FileID_Tag(i);
        ind = find(ind);
        
        if isempty(ind) 
            fprintf(fid,'Skipped %s. No decomposition files found.\n',fName_Array);
            continue; 
        end

        Array = get_DecompositionInfo(tbl_Decomp(ind,:),subjFolder);
          
        %Resave
%         save(fName_Array,'Array','-append');
        load(fName_Array,'tbl');
        save(fName_Array,'tbl','Array');
        fprintf(fid,'Saving complete. %d decomposition files combined with %s.\n',length(ind),fName_Array);
        
    end
    fclose(fid);
    fprintf('Subject folder complete: %s.\n',subjFolder);
end

function fid = open_LogFile(subjArrayFolder)
    fid = fopen([subjArrayFolder '\Combine_SensorArrayFile_And_Decomposition.txt'],'wt');
    fprintf(fid,'LOG\n\n%s\n\n',date());
    fprintf(fid,'Because Delsys Decomposition only outputs Firing times and MU Templates, it is necessary to re-combine the decomposition with Force and EMG data\n');
    fprintf(fid,'This log details which files were combined\n\n\n');
end

function Array = get_DecompositionInfo(tbl_Decomp,subjFolder)
        
    tbl_Decomp.Array    = categorical(tbl_Decomp.Array);
    tbl_Decomp.FileType = categorical(tbl_Decomp.FileType);
    
    arrays = unique(tbl_Decomp.Array);
    arrays = categorical(arrays);
    
    ind_firings = tbl_Decomp.FileType == 'MUFiringTimes';
    ind_MUAPs   = tbl_Decomp.FileType == 'MUAPs';
    
    for j=1:length(arrays)
        
        ind_array = tbl_Decomp.Array == arrays(j);
        
        i_f = ind_array & ind_firings; %Index of the MU_FiringTimes.txt file
        i_m = ind_array & ind_MUAPs;   %Index of the MUAPs.txt file
        
        fName_MUAPs = [subjFolder '\decomp\' tbl_Decomp.Files{i_m}];
        x=importdata(fName_MUAPs);

        fName_Firings = [subjFolder '\decomp\' tbl_Decomp.Files{i_f}];
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

        Array(j).Number = arrays(j);
        if arrays(j)==categorical({'1'})
            Array(j).Location = 'Medial';
        elseif arrays(j)==categorical({'2'})
            Array(j).Location = 'Lateral';
        end
        % ADD IN ARRAY CHANNELS>.....
    end
end
        
% function  tbl_Decomp = get_DecompFileInfo_FromSubjectFolder(subjFolder,options)
%     decompFolder  = [subjFolder '\decomp'];
%     options.Trial = options.Decomp;
%     tbl_Decomp = extract_FileInformation_FromFolder(decompFolder,'.txt',options);
%     tbl_Decomp = split_FileID_FromSensorArrayDecomp(tbl_Decomp);
%     tbl_Decomp = append_File_MatchTag(tbl_Decomp,options);
% end
% 
% function tbl_SensorArray = get_SensorArrayFileInfo_FromSubjectFolder(subjFolder,options)
%     arrayFolder   = [subjFolder '\array'];
%     options.Trial = options.SensorArray;
%     tbl_SensorArray = extract_FileInformation_FromFolder(arrayFolder,'.mat',options);
%     tbl_SensorArray = append_File_MatchTag(tbl_SensorArray,options);
% end

% function tbl = append_File_MatchTag(tbl,options)
% 
%     cIndex = find_TableColumns(tbl,options.MatchFilesBy);
%     
%     for n=1:size(tbl,1)
%         cNames  = tbl(n,cIndex); 
%         cNames  = cNames{1,:};
%         cTag{n,1} = [cNames{:}];
%     end
%     
%     tmp = table(categorical(cTag),'VariableNames',{'File_MatchTag'});
%     tbl = [tbl,tmp];
%     
% end
% 
% function cIndex = find_TableColumns(tbl,target)
% 
%     tblColumns = categorical(tbl.Properties.VariableNames);
%     target     = categorical(target);
%     for n=1:length(target)
%         cIndex(n) = find(tblColumns==target(n));
%     end
% 
% end