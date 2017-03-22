
function F = calculate_ForceMagnitude_FromTable(tbl)

    varNames = tbl.Properties.VariableNames;

    tmp = zeros(size(tbl,1),3);
    
    if sum(ismember(varNames,'Fx_N')) 
        tmp(:,1) = tbl.Fx_N.*tbl.Fx_N;
    end

    if sum(ismember(varNames,'Fy_N'))
        tmp(:,2) = tbl.Fy_N.*tbl.Fy_N;
    end
 
    if sum(ismember(varNames,'Fz_N'))
        tmp(:,3) = tbl.Fz_N.*tbl.Fz_N;
    end

    F = sqrt(sum(tmp,2));
end