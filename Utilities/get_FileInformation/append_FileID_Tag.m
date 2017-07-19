%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Appends a File Identifier Tag to an existing table of data
%     Used to identify unique combinations of variables 
%    For example, could be used to ID unique combos of(SID, Trial, Arm)
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%   
%   INPUT: 
%   - data_tbl = table of data used to create ID tags
%   - options including
%       File ID naming convention 
%    
%   OUTPUT: 
%   - data_tbl = data table with ID tags appended
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%      .FileID_Tag = has variables used to create unique ID 
%                    (eg. SID, ArmType and Age)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data_tbl = append_FileID_Tag(data_tbl,options)

%     profile on
    cIndex = find_TableColumns(data_tbl,options.FileID_Tag);

    tmp = convert_To_Char( data_tbl(:,cIndex) ); 
    tmp = tmp{:,:};
    
    for n=1:size(data_tbl,1)
        cTag{n,1} = strjoin(tmp(n,:),'_');
    end
    
    tmp = table(categorical(cTag),'VariableNames',{'FileID_Tag'});
    data_tbl = [data_tbl,tmp];
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