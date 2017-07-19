%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Segments a raw data file recorded in Spike2 into trials
%   - Takes in long .mat file and segments into smaller .mat files
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw data in .smr format to .mat format using Spike2 script:
%       Spike2 script name = 'Convert_Spike2_To_MAT.s2s'
%   - Configure and run using "Step2_RUN_Segment_SMRMAT_To_MATLAB_Tables"   
%
%   INPUT: 
%   - theFile = The full path of the .mat file to be segmented
%   - segmentationType = The method used to identify segment start (usually TTL trigger signal)
%   - options =  information on how to name the segments, trial time, etc
%    
%   OUTPUT: 
%   - One .mat file per segment containing:
%       (1) tbl (a table that has channel values and timestamps)
%
%   TO EDIT:
%   - Change target mat files
%   - Change naming conventions if necessary
%
%   VARIABLES:
%   - options
%       .Segmentation
%         .Channels       = The names of the Spike2 Channels I want to keep
%         .TableColumns   = The names I want the Spike2 Channels to have after I segment them
%         .FileNameConvention = The naming convention for my .smr file (separated by underscore _ )
%         .Condition      = The condition: for stroke experiment conditions = {AFF, UNAFF, or CTR}
%         .TrialTime      = Length of each trial (s)
%       .HPF
%         .FileNameConvention = Naming convention for my .hpf files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function segment_Spike2File_IntoTrials(theFile,segmentationType,options)
    
    switch segmentationType
        case 'ByTrigger'
            segment_Spike2File_ByTrigger(theFile,options)
    end

end


