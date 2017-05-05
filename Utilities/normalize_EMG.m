
function SEMG = normalize_EMG(SEMG,ch)

    subjs = unique(SEMG.SID);
    armType = unique(SEMG.ArmType);
    for n=1:length(subjs)
        i_s = SEMG.SID == subjs(n);
        for i=1:length(armType)
            i_a = SEMG.ArmType == armType(i);
            i_m = SEMG.TargetForce == '100%MVC';
            MVC = max(SEMG{i_s&i_a&i_m,ch});
            nRows = sum(i_s&i_a);
            SEMG{i_s&i_a,ch} = SEMG{i_s&i_a,ch}./repmat(MVC,nRows,1);
        end 
    end

end