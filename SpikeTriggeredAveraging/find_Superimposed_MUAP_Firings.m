


function counts = find_Superimposed_MUAP_Firings(firingEvents)
 
    overlap_interval = 0.005; %seconds  

    nEvents=length(firingEvents); 
    
    counts=zeros(nEvents,1); 
    for n=1:nEvents
        dt = firingEvents-firingEvents(n);
        tmp0 = sum(abs(dt)<overlap_interval/2)-1;
        tmp1 = (1 / (tmp0 + 1) ); % Weightings for STA
        counts(n)= tmp1;
    end
end

