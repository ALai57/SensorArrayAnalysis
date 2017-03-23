

function tbl = split_FileID_FromSensorArrayDecomp(tbl)
    
    for n=1:size(tbl,1)
       ID = tbl.ID{n}; 
       i = strfind(ID,'.');
       Arrays{n,1} = ID(i(end)+1:end);
       IDs{n,1}    = ID(1:i(end)-1);
    end
    
    tbl.ID = IDs;
    
    tmp = table(Arrays,'VariableNames',{'Array'});
    
    tbl = [tbl,tmp];
end