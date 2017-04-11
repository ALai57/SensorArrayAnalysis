
% options.STA_Window.Threshold.Type       = 'PeakToPeakCV';
% options.STA_Window.Threshold.Channels   = 'AllChannelsMeetThreshold';
% options.STA_Window.Threshold.Value       = 0.2;

function valid_Units = threshold_STA_Window_PtP(PtP,options)

    valid_Units = false(size(PtP,1),1);

    type = options.Type;
    stat = options.Statistic;
    
    variableName = ['PtP_' type '_' stat];
    theStat      = PtP.(variableName);
    
    for n=1:size(PtP,1)
        valid_Units(n) = validate_Unit(theStat(n,:),options); 
    end


end

function v = validate_Unit(quantity,options)
    
    switch options.Channels
        case 'AllChannelsMeetThreshold'
            q = quantity > options.Value;
            if sum(q)
                v=false;
            else
                v=true;
            end
        case 'OneChannelMeetThreshold'
            
    end
end