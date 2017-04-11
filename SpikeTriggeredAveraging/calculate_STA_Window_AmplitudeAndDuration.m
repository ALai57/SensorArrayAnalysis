

% load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_All_Window_4_6_2017.mat')

function [PtP_Amp, PtP_Duration] = calculate_STA_Window_AmplitudeAndDuration(STA_Out)

    samplingRate = 20000;

    PtP_Amp      = cell(size(STA_Out,1),1);
    PtP_Duration = cell(size(STA_Out,1),1);
    for n=1:size(STA_Out,1)
        try
           STA = STA_Out.STA_Window{n};
           PtP_Amp{n} = squeeze(max(STA)-min(STA));
           
           for j=1:size(STA,3)
               for i=1:4
                   ind1 = find( STA(:,1,j)== max(STA(:,1,j)) );
                   ind2 = find (STA(:,1,j)== min(STA(:,1,j)) );
                   PtP_Duration{n,1}(i,j) = abs(ind1-ind2)/samplingRate;
               end
           end

        catch
            continue;
        end
    end   
    
end


% 
% % Visualizing
% maxSTA = max(STA);
% minSTA = min(STA);
% timeWindow = 3;
% figure; plot(STA(:,:,timeWindow)*1000);
% hold on;
% plot([0 length(STA)],[maxSTA(1,1,timeWindow),maxSTA(1,1,timeWindow)]*1000,'k');
% plot([0 length(STA)],[minSTA(1,1,timeWindow),minSTA(1,1,timeWindow)]*1000,'k');
% xlabel('Time');
% ylabel('Potential (mV)')
% title(['STA in time window' num2str(timeWindow)])
% 
% figure; 
% subplot(2,2,1);
% plot(squeeze(STA(:,1,:)*1000));
% title('STA: All time periods, CH1');
% subplot(2,2,2);
% plot(squeeze(STA(:,2,:)*1000));
% title('STA: All time periods, CH2');
% subplot(2,2,3);
% plot(squeeze(STA(:,3,:)*1000));
% title('STA: All time periods, CH3');
% xlabel('Time')
% ylabel('Potential (mV)')
% subplot(2,2,4);
% plot(squeeze(STA(:,4,:)*1000));
% title('STA: All time periods, CH4');