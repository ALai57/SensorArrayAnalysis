

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
