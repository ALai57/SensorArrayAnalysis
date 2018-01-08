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



function segment_Spike2File_IntoTrials(theFile,options)
     
    validate_hpfcsvFilesMatchWithTriggers(theFile,options) 
    splitFile_IntoTrials(theFile,options)
    
end

function splitFile_IntoTrials(theFile,options) 
    
    spikeFile = load(theFile);
    
    trialStartTimes = spikeFile.Memory.times;  
    trialCondition  = extract_Information_FromFileName(theFile,...
                                                       options.Segmentation.FileNameConvention,...
                                                       'ArmType');
    trialNames      = get_allTrialNames(theFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials_ByCondition(trialNames,'ArmType',trialCondition);
    
    
    nTrials  = length(trialStartTimes);
    smrDir   = fileparts(theFile);
    
    data = convert_Spike2Struct_to_MATLABarray(spikeFile,options);
    clear spikeFile
    
    for i=1:nTrials
        trial_name  = trialNames.Files{i}(1:end-4);
        start_time  = trialStartTimes(i);
        tbl         = extract_Trial_FromFullSpike2File(start_time, data, options); 
        saveName    = [smrDir '\' trial_name '_SingleDifferential.mat'];
        
        save(saveName,'tbl')
        fprintf('Saved %s\n', saveName)
    end
    fprintf('Segmentation complete! %i/%d\n',i,nTrials)
end

function validate_hpfcsvFilesMatchWithTriggers(theFile,options)
    
    load(theFile,'Memory')
    
    trialStartTimes = Memory.times;  
    trialCondition  = extract_Information_FromFileName(theFile,...
                                                       options.Segmentation.FileNameConvention,...
                                                       'ArmType');
    trialSID        = extract_Information_FromFileName(theFile,...
                                                       options.Segmentation.FileNameConvention,...
                                                       'SID');
                                                   
    trialNames      = get_allTrialNames(theFile,options);
    trialNames      = sortrows(trialNames,'Datenum');  
    trialNames      = filter_Trials_ByCondition(trialNames,'ArmType',trialCondition);
    
    nFiles    = size(trialNames,1);
    nTriggers = length(trialStartTimes);
    
    print_FileAndTriggerMatch_ToConsole(trialSID, trialCondition, nFiles, nTriggers)
    
    if nFiles~=nTriggers
        error('The number of files does not match the number of triggers')
    end
end

function print_FileAndTriggerMatch_ToConsole(SID, condition, nFiles, nTriggers)
    fprintf('Subject ID = %s  ::: Subject Condition = %s\n', SID, condition); 
    fprintf('Number of Files/Triggers = %0.0f/%0.0f\n', nFiles, nTriggers); 
end

function trials = get_allTrialNames(theFile,options) 

    [pathstr,    ~, ~] = fileparts(theFile);
    hpfDir   = strrep(pathstr, 'smr','hpf');
    trials = extract_FileInformation_FromFolder(hpfDir,'.hpf',options.HPF);
   
end

function trialNames_good = filter_Trials_ByCondition(trialNames,trialCondition,target) 
    
    trialNames.(trialCondition) = categorical(trialNames.(trialCondition));
    target = categorical({target});
    
    ind = trialNames.(trialCondition) == target; 

    trialNames_good = trialNames(ind,:);
end

function tbl = extract_Trial_FromFullSpike2File(trial_start,data,options) 
    
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
