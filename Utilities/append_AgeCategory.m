

function MU_Data = append_AgeCategory(MU_Data,options)

    ageRanges = options.AgeRange.Threshold;
    nRanges   = size(ageRanges,1);
    
    r = cell(size(MU_Data,1),1);
    for n=1:nRanges
        lowEnd = ageRanges(n,1);
        hiEnd  = ageRanges(n,2);
        
        ind(:,n) = MU_Data.Age>lowEnd & MU_Data.Age<=hiEnd;
    end
    
    for n=1:nRanges
        r(ind(:,n),1) = options.AgeRange.Names(n);
    end
    
    MU_Data.AgeCategory = categorical(r);
end