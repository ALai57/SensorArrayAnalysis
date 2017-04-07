
% options.STA_Window.Threshold.Type       = 'PeakToPeakCV';
% options.STA_Window.Threshold.Channels   = 'AllChannelsMeetThreshold';
% options.STA_Window.Threshold.Value       = 0.2;

function valid_PtP = threshold_STA_Window_PtP(PtP,options)

    valid_PtP = false(size(PtP,1),1);
    
    for n=1:size(PtP,1)

       switch options.Threshold.Type
           case 'PeakToPeakCV'
               valid_PtP(n) = PtP_CV_Threshold(PtP{n},options); 
       end
    end

end


function v = PtP_CV_Threshold(PtP,options)
    
    if isempty(PtP)
        v = false;
    else
        ind_empty = PtP(1,:)==0;
        PtP(:,ind_empty) = [];
        PtP_CV = std(PtP')./mean(PtP');
        v = validate_Unit(PtP_CV,options);
    end
    
end

function v = validate_Unit(quantity,options)
    
    switch options.Threshold.Channels
        case 'AllChannelsMeetThreshold'
            q = quantity>options.Threshold.Value;
            if sum(q)
                v=false;
            else
                v=true;
            end
        case 'OneChannelMeetThreshold'
            
    end
end