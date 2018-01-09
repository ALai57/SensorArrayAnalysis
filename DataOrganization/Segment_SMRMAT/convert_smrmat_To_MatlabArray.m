%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Converts long .mat file composed of structs into segmented .mat file,
%     outputs a table form, instead of multiple structs
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw data in .smr format to .mat format using Spike2 script:
%       Spike2 script name = 'Convert_Spike2_To_MAT.s2s'
%   - Configure and run using "Step2_RUN_Segment_SMRMAT_To_MATLAB_Tables"   
%
%   INPUT: 
%   - spikeFile = The .mat file to be segmented
%   - options   =  information on how to name the segments, trial time, etc
%    
%   OUTPUT: 
%   - One .mat file per segment containing:
%       (1) tbl (a table that has channel values and timestamps)
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options
%       .Segmentation
%         .Channels       = The names of the Spike2 Channels I want to keep
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = convert_smrmat_To_MatlabArray(spikeFile,options)

    spike2Channels  = options.Segmentation.Channels;

    N  = get_Channel_DataLength(spikeFile,spike2Channels);
    dt = get_Channel_dt(spikeFile,spike2Channels);
    
    time_vec = ((1:N)*dt)';
    data     = time_vec;
    
    for n=1:length(spike2Channels)
        data(:,n+1) = spikeFile.(spike2Channels{n}).values(1:N);
    end
    
end    

function dt = get_Channel_dt(spikeFile,spike2Channels)
    dt = spikeFile.(spike2Channels{1}).interval;
end

function N = get_Channel_DataLength(spikeFile,spike2Channels)
    for i=1:length(spike2Channels)
        L(1,i) = length(spikeFile.(spike2Channels{i}).values);
    end
    N = max(L)-5;
end