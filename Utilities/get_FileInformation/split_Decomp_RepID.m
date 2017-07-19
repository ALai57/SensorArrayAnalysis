%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Splits Decomposed file ID (X.Y.Z) into array number (X) and trial ID (Y.Z)
%
%   BEFORE RUNNING, SETUP:
%   - N/A
%   
%   INPUT: 
%   - FID_tbl = table with field containing file IDs 
%    
%   OUTPUT: 
%   - FID_tbl = table with field containing trial ID and array number
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - N/A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function FID_tbl = split_Decomp_RepID(FID_tbl)
    
    for n=1:size(FID_tbl,1)
       ID = FID_tbl.ID{n}; 
       i  = strfind(ID,'.'); 
       
       Arrays{n,1} = ID(i(end)+1:end);
       IDs{n,1}    = ID(1:i(end)-1);
    end
    
    FID_tbl.ID = IDs;
    
    tmp = table(Arrays,'VariableNames',{'Array'});
    
    FID_tbl = [FID_tbl,tmp];
end