

%% Thresholding using PtP amplitude CV

options.STA_Window.File                 = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Control_Window_4_8_2017.mat';
options.STA_Window.Threshold.Type       = 'PeakToPeakCV';
options.STA_Window.Threshold.Channels   = 'AllChannelsMeetThreshold';
options.STA_Window.Threshold.Value      = 0.2;
options.STA.File                        = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl.mat';
options.FileID_Tag                      = {'SensorArrayFile','ArrayNumber','MU'}; 

%calculate
PtP_Out = get_Threshold_STA_PtP(options);

load(options.STA.File,'MU_Data')
PtP_Out = append_FileID_Tag(PtP_Out,options);
MU_Data = append_FileID_Tag(MU_Data,options);

if isequal(PtP_Out.FileID_Tag,MU_Data.FileID_Tag)
   MU_Data = [MU_Data,PtP_Out(:,4:7)]; 
   clear PtP_Out
end


% PLOT STA AMPLITUDE OVER TIME
























%% Thresholding using cross correlation between Delsys and STA

load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_All_Window_4_6_2017.mat')

options.Delsys_STA_Similarity.Threshold.Type       = 'Xcorr';
options.Delsys_STA_Similarity.Threshold.Channels   = 'AllChannelsMeetThreshold';
options.Delsys_STA_Similarity.Threshold.Value       = 0.8;

% Delsys/STA XCorrelation threshold
Xcorr       = calculate_STA_Xcorr()
valid_Xcorr = threshold_STA_Xcorr()