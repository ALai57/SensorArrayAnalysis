
function [STA_Template,Amp,Duration] = calculate_STA_Fast(FiringTimes, EMG4, EMGtime,Templates)
    
    DelTime = Templates.Time;
    
    delsys_dt = DelTime(2)-DelTime(1);
    EMG_dt    = EMGtime(2)-EMGtime(1);
    
    %Remove NaNs
    DelTime(isnan(Templates.Ch1)) = [];

    options.Window.Prior  = (length(DelTime)-1)*(delsys_dt/2)/1000; 
    options.Window.Post   = (length(DelTime)-1)*(delsys_dt/2)/1000-EMG_dt;
    
    MU_Weights = find_Superimposed_MUAP_Firings(FiringTimes);
    
    [STA_Template,Amp,Duration] = STAmuWH(FiringTimes, EMGtime, EMG4, MU_Weights, options);
end