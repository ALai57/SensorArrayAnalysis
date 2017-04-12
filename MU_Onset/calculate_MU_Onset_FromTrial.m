
% options.MU_Onset.Type = 'SteadyFiring';
% options.MU_Onset.SteadyFiring.Number = 2;
% options.MU_Onset.SteadyFiring.MaxInterval = 0.2;


%%%%%%%%% CONSOLIDATE INTO ONE FUNCTION
function MU_Onset = calculate_MU_Onset_FromTrial(trialData,options)

    EMG     = load_SensorArray_Data(trialData,options);
    MU_Onset = initialize_OutputArray(trialData,options);
     
    for i=1:size(trialData,1)
        
    
        FT = trialData.FiringTimes{i};
        
        Onset_Time{i,1}  = calculate_MU_OnsetTime(FT,options);
        Onset_Force{i,1} = calculate_MU_OnsetForce(Onset_Time{i},EMG.tbl,options);
       
        
%         figure;
%         F = calculate_ForceMagnitude_FromTable(EMG.tbl);
%         plot(EMG.tbl.Time,F,'k'); hold on;
%         if ~isempty(FT)
%             stem(FT,0.8*max(F)*ones(length(FT),1),'marker','none');
%             xL = get(gca,'XLim');
%             yL = get(gca,'YLim');
%             plot([Onset_Time(i) Onset_Time(i)],[yL(1) yL(2)],'r','linewidth',2)
%             plot([xL(1) xL(2)],[Onset_Force(i) Onset_Force(i)],'r','linewidth',2)
%         end
%         xlabel('Time')
%         ylabel('Force')
%         title('Calculated onset time and force')
        
    end
    
    MU_Onset.(options.Trial.OutputVariable{1}) = Onset_Time;
    MU_Onset.(options.Trial.OutputVariable{2}) = Onset_Force;
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

function EMG = load_SensorArray_Data(trial,options)
    SID      = char(trial.SID(1));
    fullFile = [options.BaseDirectory '\' SID '\array\' char(trial.SensorArrayFile(1))];
    EMG = load(fullFile,'tbl');
end



function Onset_Force  = calculate_MU_OnsetForce(onset_Time,EMG,options)

    time = EMG.Time;
    tmp  = abs(time-onset_Time);
    ind  = find(tmp == min(tmp));
    
    dt = time(2)-time(1);
    
    i_Prior = ind-options.MU_Onset.ForcePrior/dt;
    i_Post  = ind+options.MU_Onset.ForcePost/dt;
    
    F = calculate_ForceMagnitude_FromTable(EMG);
    
    if i_Prior < 1
        i_Prior = 1; 
    end
    if i_Post > length(EMG.Time)
        i_Post = length(EMG.Time); 
    end
    
    Onset_Force = mean(F(i_Prior:i_Post));
    
end



function Onset_Time  = calculate_MU_OnsetTime(FT,options)

    switch options.MU_Onset.Type
        case 'SteadyFiring'
            Onset_Time = find_Onset_SteadyFiring(FT);
    end
    
end

function Onset_Time = find_Onset_SteadyFiring(FT)
    
    if isempty(FT)
        Onset_Time = NaN;
    else
        ISI = diff(FT);

        n = 1;
        while (ISI (n) >= 0.2 || ISI (n+1) >= 0.2)
            n = n +1;
        end
        Onset_Time = FT(n);
    end
    
end
