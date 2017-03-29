

function tbl = append_FileID_Tag(tbl,options)

    cIndex = find_TableColumns(tbl,options.FileID_Tag);
    
    for n=1:size(tbl,1)
        cNames  = tbl(n,cIndex); 
        cNames  = cNames{1,:};
        cTag{n,1} = [cNames{:}];
    end
    
    tmp = table(categorical(cTag),'VariableNames',{'FileID_Tag'});
    tbl = [tbl,tmp];
    
end

function cIndex = find_TableColumns(tbl,target)

    tblColumns = categorical(tbl.Properties.VariableNames);
    target     = categorical(target);
    for n=1:length(target)
        cIndex(n) = find(tblColumns==target(n));
    end

end