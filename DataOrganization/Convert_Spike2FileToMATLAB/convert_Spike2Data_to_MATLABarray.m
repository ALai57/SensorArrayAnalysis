
function data = convert_Spike2Data_to_MATLABarray(spikeFile,options)

    spike2Channels  = options.Segmentation.Channels;

    N  = get_ChannelDataLength(spikeFile,spike2Channels);
    dt = spikeFile.(spike2Channels{1}).interval;
    
    time = ((1:N)*dt)';
    data = time;
    
    for n=1:length(spike2Channels)
        data(:,n+1) = spikeFile.(spike2Channels{n}).values(1:N);
    end
    
end    

function N = get_ChannelDataLength(spikeFile,spike2Channels)
    for i=1:length(spike2Channels)
        L(1,i) = length(spikeFile.(spike2Channels{i}).values);
    end
    N = max(L)-5;
end