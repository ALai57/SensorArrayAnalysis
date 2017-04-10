

function tbl = append_FileID_Tag(tbl,options)

%     profile on
    cIndex = find_TableColumns(tbl,options.FileID_Tag);

    tmp = convert_To_Char( tbl(:,cIndex) ); 
    tmp = tmp{:,:};
    
    for n=1:size(tbl,1)
        cTag{n,1} = strjoin(tmp(n,:),'_');
    end
    
    tmp = table(categorical(cTag),'VariableNames',{'FileID_Tag'});
    tbl = [tbl,tmp];
%     profile viewer
end



function cIndex = find_TableColumns(tbl,target)

    tblColumns = categorical(tbl.Properties.VariableNames);
    target     = categorical(target);
    for n=1:length(target)
        cIndex(n) = find(tblColumns==target(n));
    end

end

function dataOut = convert_To_Char(dataIn)

    for n=1:size(dataIn,2)
        if iscategorical(dataIn{:,n})
            
            dataOut(:,n) = cellstr( char(dataIn{:,n}) );
            
        elseif isnumeric(dataIn{:,n})
            
            dataOut(:,n) = cellstr( num2str(dataIn{:,n}) ); 
            
        else
            dataOut(:,n) = dataIn{:,n};
        end
    end
    
    dataOut = cell2table( dataOut );
    dataOut.Properties.VariableNames = dataIn.Properties.VariableNames;
end




%         cNames  = cNames{1,:};
%         cTag{n,1} = [cNames{:}]; 