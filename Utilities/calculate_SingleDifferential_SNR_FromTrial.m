

function SNR = calculate_SingleDifferential_SNR_FromTrial(trial_Data,options)

%     profile on;
    ch = [2,3,4,5,6];
    SNR = initialize_OutputArray(trial_Data,options);
    
    try
        EMG     = load(trial_Data.SingleDifferentialFullFile{1});
        EMGtime = table2array(EMG.tbl(:,1));
        EMG     = table2array(EMG.tbl(:,ch));
    catch
        calculationError(SNR,options,trial_Data)
    end
    tStart = get_StartTime(options,EMGtime);
    tEnd   = max(EMGtime);
    bStart = options.Baseline.Start;
    bEnd   = options.Baseline.End;
    
    
    [Signal,tMid] = calc_EMG(tStart,tEnd,options.SEMG,EMGtime,EMG);
    Signal = eliminateEmptyColumns(Signal);
    
    [Noise, tMid] = calc_EMG(bStart,bEnd,options.Baseline,EMGtime,EMG);
    Noise = eliminateEmptyColumns(Noise);
    
    for n=1:length(options.Trial.OutputVariable)
        sVal = Signal(n)./Noise(n);
        SNR.(options.Trial.OutputVariable{n}) = repmat({sVal},size(trial_Data,1),1);
    end
    
%     profile viewer;
    plotFlag = 0;
    if plotFlag
        figure; 
        for n=1:8
            subplot(2,4,n)
            plot(EMGtime,EMG(:,n)); hold on;
            plot(tMid,SEMG_value(:,n),'linewidth',3)
            xL = [0 max(EMGtime)];
            set(gca,'xlim',xL);
            plot(xL,[Signal(n) Signal(n)])
            ylim([-0.05 0.05])
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

function calculationError(SNR,options,trial_Data)
    for n=1:length(options.Trial.OutputVariable)
        SNR.(options.Trial.OutputVariable{n}) = repmat({[0 0 0 0]},size(trial_Data,1),1);
    end
    return;
end

function tStart = get_StartTime(options,EMGtime)
    if isempty(options.SEMG.Start)
       options.SEMG.Start = EMGtime(1); 
    end
    tStart = options.SEMG.Start; 
end

function [EMGval,tMid] = calc_EMG(tStart,tEnd,options,EMGtime,EMG) 
    dt = options.SlideStep;
    c  = 1;
    wStart = tStart;
    wEnd   = wStart + options.Window;
    while wEnd <= tEnd
        ind = EMGtime>=wStart & EMGtime < wEnd;
        switch options.Method
            case 'RMS'
                SEMG_value(c,:) = rms(EMG(ind,:));
        end
        
        tMid(c) = (wEnd+wStart)/2;
        c=c+1;
        wEnd = wEnd+dt;
        wStart = wStart+dt;
    end
    
    switch options.Statistic
        case 'Max'
            EMGval = max(SEMG_value);
        case 'Min'
            EMGval = min(SEMG_value);
        case 'Raw'
            EMGval = SEMG_value;
    end
    
    plotFlag = 0;
    if plotFlag
        figure; 
        for n=1:5
            subplot(5,1,n)
            plot(EMGtime,EMG(:,n)); hold on;
            plot(tMid,SEMG_value(:,n),'linewidth',3)
            xL = [0 max(EMGtime)];
            set(gca,'xlim',xL);
            plot(xL,[EMGval(n) EMGval(n)])
            ylim([-0.15 0.15])
        end
    end
    
end

function SEMG = eliminateEmptyColumns(SEMG)
    z = zeros(size(SEMG,1),1);
    for c=1:size(SEMG,2)
        elim(c) = isequal(SEMG(:,c),z);
    end
    SEMG(:,elim) = [];
end