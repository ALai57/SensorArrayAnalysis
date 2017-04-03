
function tbl = get_NumberOfMUsDecomposed(arrayData,options)

    if size(arrayData,1)==1 && isnan(arrayData.MU)
        nMU = 0;
    else
        nMU = size(arrayData,1);
    end

    tbl = table(nMU,'VariableNames',{'nMU'});
    
end