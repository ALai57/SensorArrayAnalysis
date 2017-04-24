

function ind = threshold_NumberOfMUs(MU_Data,options)
    
    switch options.Threshold.Type
        
        case 'MinNumberUnits_PerForceLevel'
            
            SA = categorical(MU_Data.SensorArrayFile);
            nMUs = zeros(size(SA));
            for n=1:size(SA,1)
               theFile = SA(n);
               nMUs(n) = sum(SA == theFile);
            end
            ind = nMUs > options.Threshold.Value;
        case 'MinNumberUnits_PerTrial'
            
    end
    
    
end



            
%             d = varfun(@size,MU_Data,'InputVariables','MU','GroupingVariables',{'SID','ArmType','TargetForce_N','TargetForce'});