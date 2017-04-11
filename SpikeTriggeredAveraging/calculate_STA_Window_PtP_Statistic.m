
function [PtP_Stat] = calculate_STA_Window_PtP_Statistic(PtP,options)

   switch options.Statistic
       case 'CV'
            PtP_Stat = zeros(size(PtP,1),4);
            for n=1:size(PtP,1)
                PtP_Stat(n,:) = calculate_PtP_CV(PtP{n}); 
            end
   end

end

function [PtP_CV] = calculate_PtP_CV(PtP)
    
    if isempty(PtP)
        PtP_CV      = [-1,-1,-1,-1];
    else
        ind_empty = PtP(1,:)==0;
        PtP(:,ind_empty) = [];
        PtP_CV = std(PtP')./mean(PtP');
    end
    
end