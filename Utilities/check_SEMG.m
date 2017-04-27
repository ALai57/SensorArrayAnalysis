

function SEMG_out = check_SEMG(SEMG_in)

    for n=1:size(SEMG_in,1)
        ind(n,1) = isequal(SEMG_in(n,:),SEMG_in(1,:));
    end
    
    if sum(ind) == length(ind)
       SEMG_out = SEMG_in(1,:);
    else
       SEMG_out = -1*ones(1,size(SEMG_in,2)); 
    end
end