
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