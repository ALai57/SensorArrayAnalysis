function PtP_EMG = calculate_PtP_Amplitude(EMG4,PeakN)
    %SNR1 calculate the SNR of 4Chs of EMG (actually can be any #s of Chs).
    %input:
    %EMG4 (Nx4): Emg data, one column for one ch.
    %winbaseline(1x1): # of data points for baseline noise (60000 for 3s in 20kHz sample) 
    %PeakN (1x1): # of data points used to calculate p-p amplitude of signal and noise
    %output:
    %snr4(1x4): snr of 4 chs.
    % Xiaogang Hu, SMU@RIC, 10/12/2011

    elimpeak=0;   % For manual editing
    if elimpeak
        a=find(EMG4(:,1)==max(EMG4(:,1)));
        EMG4(a-20000:end,:)=[];
    end

    rankEMG = sort(EMG4,'descend'); %ranked EMG data
    mxPk = mean( rankEMG(1:PeakN, :) );
    mnPk = mean( rankEMG(end-PeakN:end, :) );
    PtP_EMG = mxPk-mnPk; % P-P amplitude of EMG

    plotfig=0; % For manual editing
    if plotfig
        figure; 
        dt=1/20000;
        n=length(EMG4);
        subplot(2,2,1); plot(rankEMG); title('Signal');
        subplot(2,2,2); plot(rankEMG(1:PeakN, :)); 
        subplot(2,2,3); plot(rankEMGbase); title('Noise')
        subplot(2,2,4); plot([1:n]*dt,EMG4(:,1)); hold on; 
        plot([dt n*dt], [PtP_EMG(1) PtP_EMG(1)]/2); title('EMG w/ SNR')
        plot([dt n*dt],-[PtP_EMG(1) PtP_EMG(1)]/2);
    end
end