

%Input
% smr_matFile = = Relevant information needed to process the file 

% smr_matFile 
%           .Experiment
%           .FileName
%           .ArmType
%           .SID

function segment_Spike2File_IntoTrials(theFile,segmentationType,options)
    
    switch segmentationType
        case 'ByTrigger'
            segment_Spike2File_ByTrigger(theFile,options)
    end

end


