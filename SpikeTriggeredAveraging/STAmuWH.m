

function [STA_Template, STA_Amplitude, STA_Duration] = STAmuWH(FiringTimes, EMGtime, EMG4, weights, options)
   
    % Initial setup
    WinPrior = options.Window.Prior;
    WinPost  = options.Window.Post;
    dt       = EMGtime(2)-EMGtime(1);
    
    IndPrior = round(abs(WinPrior) / dt); % points prior to time of firing
    IndPost  = round(abs(WinPost)  / dt);
    
    if isempty(FiringTimes) % If there are no firing events, exit
%         STA_Template  = zeros(1 + round((abs(WinPrior) + abs(WinPost))/dt), 4); 
        STA_Template  = zeros(IndPrior + IndPost + 1, 4);
        STA_Amplitude = zeros(4,1);
        STA_Duration  = zeros(4,1); 
        PeakN = zeros(4,1);
        return;
    end

    MinISI   = 1/60; % usually minimum ISI=16.7 ms. or MFR = 60 Hz.
    nChannels = size(EMG4, 2);

    FiringTimes = remove_Low_ISI(FiringTimes, MinISI, weights, dt);
    
    % do STA
%     IndPrior = round(abs(WinPrior) / dt); % points prior to time of firing
%     IndPost  = round(abs(WinPost)  / dt); % points post time of firing
    STA_Template = zeros(IndPrior + IndPost + 1, nChannels);

    for j=1:length(FiringTimes) % Loop over all valid MU events 
        try
            ind = find_FiringTimeIndex(FiringTimes(j),EMGtime);
            STAwindow = [(ind - IndPrior) : (ind + IndPost)];
            STA_Template = STA_Template + EMG4(STAwindow,:) * weights(j);
        catch
            continue 
        end
    end
    
    STA_Template = STA_Template ./ sum(weights);
    
    %Apply hanning window to smooth the edge.
    HannW = hann(length(STA_Template));
    STA_Template = STA_Template .* [HannW, HannW, HannW, HannW]; 

    STA_Amplitude = calc_Amplitude(STA_Template);
    STA_Duration  = calc_Duration(STA_Template,dt);
    
    
end

function ind = find_FiringTimeIndex(FiringTimes,time)

    dt = time(2)-time(1);
    ind = FiringTimes/(dt) - time(1)/dt + 1; %Factor of 1000 because delsys reports in ms

end

function FiringTimes = remove_Low_ISI(FiringTimes, MinISI, weights, dt)
    % check constraints: FR < min ISI
    % the firings prior and post to the current firing has to be larger than 20ms. if not, ignore the firing that causes the short interval
    ind_LowISI =1;
    while (~isempty(ind_LowISI))
        ISI = diff(FiringTimes);
        ind_LowISI = find(ISI < MinISI); % index of lower ISI than minmum ISI threshold.
        
        if ~isempty(ind_LowISI)
            ind_AdjacentLowISI = find(diff(ind_LowISI) == 1);
            if isempty(ind_AdjacentLowISI) 
                ind_Remove = ind_LowISI + 1; %Remove later firing event
            else
                ind_Remove = ind_LowISI(ind_AdjacentLowISI + 1); % remove the middle firing instance if there are 2 adjacent short ISI.
            end
            FiringTimes(ind_Remove) = []; 
            weights(ind_Remove)     = []; 
            
            ind_LowISI = find(diff(FiringTimes) * dt < MinISI); % index of lower ISI than minmum ISI threshold.
        end
    end

end

function STA_Amplitude = calc_Amplitude(STA_Template)
    mx = max(STA_Template);
    mn = min(STA_Template);
    
    STA_Amplitude = mx-mn;
end

function STA_Duration = calc_Duration(STA_Template,dt)

    STA_Duration = zeros(4,1);
    sW = 100;
    if length(STA_Template)<=200
       sW = length(STA_Template)/2-10; 
    end
    searchWindow=ceil(length(STA_Template)/2-sW):ceil(length(STA_Template)/2+sW);
    for k = 1:4 
        STA_Duration(k) = abs(find(STA_Template(searchWindow,k)==max(STA_Template(searchWindow,k)), 1, 'first') - find(STA_Template(searchWindow,k)==min(STA_Template(searchWindow,k)), 1, 'first')) * dt;
    end
end



 %% plot templates
%     if PlotFig
%         PtP = [min(Rang1(:,1)), max(Rang1(:,2))]; % find the largest P-P
%         h=tight_subplot(2,2,[.02 .04],[.1 .1],[.05 .01]);
%         for m = 1:size(EMG4, 2)
%             axes(h(m))
% %             subplot(2,2,m); hold on
%             if WinPrior < 0
%                plot(WinPrior:dt:WinPost, Temp4(:,m), 'LineWidth',1.5)
%             else
%     %            plot((-1 * WinPrior:dt:WinPost) + WinPrior/2, Temp4(:,m), 'LineWidth',1.5)
%                 plot((-1 * WinPrior:dt:WinPost), Temp4(:,m), 'LineWidth',1.5)
%             end
%             grid on; ylim(PtP * 1.2);
%         end
%     end
