


function segment_Spike2File_ByTrigger(theFile,options)
     
    check_FilesMatchWithTriggers(theFile,options) 
    save_Trials(theFile,options)
    
end

function save_Trials(theFile,options) 
    
    spikeFile = load(theFile);
    
    trialTimes      = spikeFile.Memory.times;  
    trialCondition  = extract_Information_FromFileName(theFile,options.Segmentation,'ArmType');
    trialNames      = get_allTrialNames(theFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials_ByCondition(trialNames,'ArmType',trialCondition);
    
    
    nTrials  = length(trialTimes);
    smrDir   = fileparts(theFile);
    
    data = convert_Spike2Data_to_MATLABarray(spikeFile,options);
    clear spikeFile
    
    for i=1:nTrials
        trial_start = trialTimes(i);
        tbl         = get_TrialData_FromFullSpike2File(trial_start,data,options); 
        fName       = [smrDir '\' trialNames.Files{i}(1:end-4) '_SingleDifferential.mat'];
        save(fName,'tbl')
        display(sprintf('Saved %s',[smrDir '\' trialNames.Files{i}(1:end-4) '.mat']))
    end
    display(sprintf('Segmentation complete! %i/%d',i,nTrials))
end

function check_FilesMatchWithTriggers(theFile,options)
    
    load(theFile,'Memory')
    
    trialTimes      = Memory.times;  
    trialCondition  = extract_Information_FromFileName(theFile,options.Segmentation,'ArmType');
    trialSID        = extract_Information_FromFileName(theFile,options.Segmentation,'SID');
    trialNames      = get_allTrialNames(theFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials_ByCondition(trialNames,'ArmType',trialCondition);
    
%     trialNames      = get_allTrialNames(theFile);
%     trialNames      = filter_Trials_ByCondition(trialNames,trialCondition);
    
    nFiles    = size(trialNames,1);
    nTriggers = length(trialTimes);
    
    display(sprintf('Subject ID = %s  ::: Subject Condition = %s',trialSID,trialCondition)); 
    display(sprintf('Number of Files/Triggers = %0.0f/%0.0f',nFiles,nTriggers)); 
    
    if nFiles~=nTriggers
        error('The number of files does not match the number of triggers')
    end
end

function trials = get_allTrialNames(theFile,options) 

    [pathstr,    ~, ~] = fileparts(theFile);
    hpfDir   = strrep(pathstr, 'smr','hpf');
%     trials = dir(hpfDir);
    options.Trial = options.HPF;
    trials = extract_FileInformation_FromFolder(hpfDir,'.hpf',options);
   
end

function trialNames_good = filter_Trials_ByCondition(trialNames,trialCondition,target) 
    
    trialNames.(trialCondition) = categorical(trialNames.(trialCondition));
    target = categorical({target});
    
    ind = trialNames.(trialCondition) == target; 

    trialNames_good = trialNames(ind,:);
end


% function trialNames_good = filter_Trials_ByCondition(trialNames,trialCondition) 
%     
%     for n=1:length(trialNames) 
%         tName = trialNames(n).name;
%         ind(n,1) = ~isempty(strfind(tName,trialCondition));  
%     end
%     
%     trialNames_good = trialNames(ind); 
%     
%     %Sort by date
%     for n=1:length(trialNames_good) 
%         dn(n) = trialNames_good(n).datenum;
%     end
%     [s,ind]=sort(dn);
%     
%     trialNames_good = trialNames_good(ind);
% end

function tbl = get_TrialData_FromFullSpike2File(trial_start,data,options) 
    
    window_t     = options.Segmentation.TrialTime;  %Length of each trial in seconds
    dt           = data(2,1)-data(1,1);             %sampling dt
    t_all        = [1:length(data)]*dt;             %Time vector for the entire EMG record
    t_trial      = dt:dt:window_t;                  %Time vector for the trial
    trial_length = length(t_trial);                 %Number of data points in the trial
    
    window = find_TrialTimeWindow(t_all,trial_start,trial_length);
    
    try
        tbl = array2table(data(window,:));
    catch
        tbl = array2table(data(window(1):end,:));
        ind = (size(tbl,1)+1):length(window);
        tbl{ind,:} = NaN;
    end
    
    tbl.Properties.VariableNames = [{'Time'},options.Segmentation.TableColumns];
    tbl.Time = tbl.Time-tbl.Time(1);
end

function window = find_TrialTimeWindow(t_all,t_start,trial_len)
    index = find(abs(t_all-t_start)==min(abs(t_all-t_start)));
    window = index:index+trial_len-1;
end