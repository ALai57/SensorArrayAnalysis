
function MU_Data = append_ForceCategory(MU_Data,options)

    forceRanges = options.ForceRange.Threshold;
    nRanges   = size(forceRanges,1);
    
    r = cell(size(MU_Data,1),1);
    for n=1:nRanges
        lowEnd = forceRanges(n,1);
        hiEnd  = forceRanges(n,2);
        
        ind(:,n) = MU_Data.TargetForce_N>lowEnd & MU_Data.TargetForce_N<=hiEnd;
    end
    
    for n=1:nRanges
        r(ind(:,n),1) = options.ForceRange.Names(n);
    end
    
    MU_Data.ForceCategory = categorical(r);
end