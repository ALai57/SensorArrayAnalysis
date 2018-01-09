%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Segments a raw data file recorded in Spike2 into trials, using a TTL trigger signal
%   - Takes in long .mat file and segments into smaller .mat files
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw data in .smr format to .mat format using Spike2 script:
%       Spike2 script name = 'Convert_Spike2_To_MAT.s2s'
%   - Configure and run using "Step2_RUN_Segment_SMRMAT_To_MATLAB_Tables"   
%
%   INPUT: 
%   - theFile = The full path of the .mat file to be segmented
%   - options =  information on how to name the segments, trial time, etc
%    
%   OUTPUT: 
%   - One .mat file per segment containing:
%       (1) tbl (a table that has channel values and timestamps)
%
%   TO EDIT:
%   - Change target mat files
%   - Change naming conventions if necessary
%
%   VARIABLES:
%   - options
%       .Segmentation
%         .Channels       = The names of the Spike2 Channels I want to keep
%         .TableColumns   = The names I want the Spike2 Channels to have after I segment them
%         .FileNameConvention = The naming convention for my .smr file (separated by underscore _ )
%         .Condition      = The condition: for stroke experiment conditions = {AFF, UNAFF, or CTR}
%         .TrialTime      = Length of each trial (s)
%       .HPF
%         .FileNameConvention = Naming convention for my .hpf files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function segment_smrmat_Into_Trials(smrmatFile,options)
     
    validate_EqualNumber_hpfcsvFiles_And_Triggers(smrmatFile,options) 
    split_smrmat_Into_Trials(smrmatFile,options)
    
end

function split_smrmat_Into_Trials(theFile,options) 
    
    spikeFile = load(theFile);
    
    %Get arm type of smrmat file and corresponding hpfcsv files
    trialStartTimes = spikeFile.Memory.times;  
    trialCondition  = parse_FileName(theFile,...
                                     options.Segmentation.FileNameConvention,...
                                     'ArmType');
    trialNames      = get_Corresponding_hpfcsvFiles(theFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials(trialNames,'ArmType',trialCondition);
    
    
    nTrials  = length(trialStartTimes);
    smrDir   = fileparts(theFile);
    
    %Convert the full dataset into matlab array
    data = convert_smrmat_To_MATLABarray(spikeFile,options);
    clear spikeFile
    
    %Parse the full matlab array into trials and save
    for i=1:nTrials
        trial_name  = trialNames.Files{i}(1:end-4);
        start_time  = trialStartTimes(i);
        tbl         = extract_Trial_From_smrmat(start_time, data, options); 
        saveName    = [smrDir '\' trial_name '_SingleDifferential.mat'];
        
        save(saveName,'tbl')
        fprintf('Saved %s\n', saveName)
    end
    fprintf('Segmentation complete! %i/%d\n',i,nTrials)
end

function validate_EqualNumber_hpfcsvFiles_And_Triggers(smrmatFile,options)
    
    %Get the number of triggers
    load(smrmatFile,'Memory')
    trialStartTimes = Memory.times;  
    
    %Parse smrmat file name to get: arm type, SID
    trialArmType  = parse_FileName(smrmatFile,...
                                    options.Segmentation.FileNameConvention,...
                                    'ArmType');
    trialSID      = parse_FileName(smrmatFile,...
                                    options.Segmentation.FileNameConvention,...
                                    'SID');
                                
    %Get # of hpfcsvfiles for the [SID and arm type] in the smrmat file                                               
    trialNames      = get_Corresponding_hpfcsvFiles(smrmatFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials(trialNames,'ArmType',trialArmType);
    
    nFiles    = size(trialNames,1);
    nTriggers = length(trialStartTimes);
    
    print_NumFilesAndTriggers_ToConsole(trialSID, trialArmType, nFiles, nTriggers)
    
    %If number of files doesn't match number of triggers, throw error
    if nFiles~=nTriggers
        error('The number of files does not match the number of triggers')
    end
end

function print_NumFilesAndTriggers_ToConsole(SID, condition, nFiles, nTriggers)
    fprintf('Subject ID = %s  ::: Subject Condition = %s\n', SID, condition); 
    fprintf('Number of Files/Triggers = %0.0f/%0.0f\n', nFiles, nTriggers); 
end

function trials = get_Corresponding_hpfcsvFiles(theFile,options) 

    [pathstr,    ~, ~] = fileparts(theFile);
    hpfDir   = strrep(pathstr, 'smr','hpf');
    trials = parse_FileNames_In_Folder(hpfDir,'.hpf',options.HPF);
   
end

function trialNames_good = filter_Trials(trialNames,targetField,targetValue) 
    %Return all trials where targetField == targetValue
    
    trialNames.(targetField) = categorical(trialNames.(targetField));
    targetValue = categorical({targetValue});
    
    ind = trialNames.(targetField) == targetValue; 

    trialNames_good = trialNames(ind,:);
end

function tbl = extract_Trial_From_smrmat(trial_start,data,options) 
    
    window_t     = options.Segmentation.TrialTime;  %Length of each trial in seconds
    dt           = data(2,1)-data(1,1);             %sampling dt
    t_all        = [1:length(data)]*dt;             %Time vector for the entire EMG record
    t_trial      = dt:dt:window_t;                  %Time vector for the trial
    trial_length = length(t_trial);                 %Number of data points in the trial
    
    %Get index where trial is ongoing
    idx = find_TrialTimeWindow(t_all,trial_start,trial_length);
    
    try
        tbl = array2table(data(idx,:));
    catch
        tbl = array2table(data(idx(1):end,:));
        ind = (size(tbl,1)+1):length(idx);
        tbl{ind,:} = NaN;
    end
    
    tbl.Properties.VariableNames = [{'Time'},options.Segmentation.TableColumns];
    tbl.Time = tbl.Time-tbl.Time(1);
end

function window = find_TrialTimeWindow(t_all,t_start,trial_len)
    %Return indices where the trial time best matches the trial window
    index = find(abs(t_all-t_start)==min(abs(t_all-t_start)));
    window = index:index+trial_len-1;
end
