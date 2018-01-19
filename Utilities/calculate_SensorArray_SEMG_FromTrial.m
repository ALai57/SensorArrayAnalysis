

function SEMG = calculate_SensorArray_SEMG_FromTrial(trial_Data,options)

%     profile on;
    ch = [2,3,4,5,8,9,10,11];
    SEMG = initialize_OutputArray(trial_Data,options);
    
    try
        EMG     = load(trial_Data.SensorArrayFullFile{1});
        EMGtime = table2array(EMG.tbl(:,1));
        EMG     = table2array(EMG.tbl(:,ch));
    catch
        for n=1:length(options.Trial.OutputVariable)
            SEMG.(options.Trial.OutputVariable{n}) = repmat({[0 0 0 0]},size(trial_Data,1),1);
        end
        return;
    end
    if isempty(options.SEMG.Start)
       options.SEMG.Start = EMGtime(1); 
    end
    tStart = options.SEMG.Start; 
    
    tEnd   = tStart + options.SEMG.Window;
    dt     = options.SEMG.SlideStep;
    c=1;
    while tEnd < max(EMGtime)
        ind = EMGtime>=tStart & EMGtime < tEnd;
        switch options.SEMG.Method
            case 'RMS'
                SEMG_value(c,:) = rms(EMG(ind,:));
        end
        
        tMid(c) = (tEnd+tStart)/2;
        c=c+1;
        tEnd = tEnd+dt;
        tStart = tStart+dt;
    end
    
    switch options.SEMG.Statistic
        case 'Max'
            if isfield(options.SEMG, 'MaxT')
                ind_t = tMid <options.SEMG.MaxT;
            else
                ind_t = true(size(tMid));
            end
            SEMG_stat = max(SEMG_value(ind_t,:));
    end
    
    z = zeros(size(SEMG_stat,1),1);
    
    for c=1:size(SEMG_stat,2)
        elim(c) = isequal(SEMG_stat(:,c),z);
    end
    SEMG_stat(:,elim) = [];
    for n=1:length(options.Trial.OutputVariable)
        sVal = SEMG_stat([1:4]+4*(n-1));
        SEMG.(options.Trial.OutputVariable{n}) = repmat({sVal},size(trial_Data,1),1);
    end
%     profile viewer;
    plotFlag = 0;
    MVCFlag  = 0;
    if plotFlag
        figure; 
        for n=1:8
            subplot(2,4,n)
           
            plot(EMGtime,EMG(:,n)); hold on;
            plot(tMid,SEMG_value(:,n),'linewidth',3)
            xL = [0 max(EMGtime)];
            set(gca,'xlim',xL);
            plot(xL,[SEMG_stat(n) SEMG_stat(n)])
            if ~MVCFlag
                ylim([-0.05 0.05])
            end
            if n==1
               title([char(trial_Data.SID(1)) '-' char(trial_Data.ArmType(1)) ' ' char(trial_Data.TrialName(1))],'interpreter','none') 
            end
        end
    end
    
end

function STA_Out = initialize_OutputArray(trialData,options)
    c         = cell(size(trialData,1),1);
    emptyCell = [];
    
    for n=1:length(options.Trial.OutputVariable) 
        tmp       = table(c,'VariableNames',{options.Trial.OutputVariable{n}});
        emptyCell = [emptyCell,tmp];
    end
    
    STA_Out   = [trialData(:,[8,10,13]),emptyCell]; 
end