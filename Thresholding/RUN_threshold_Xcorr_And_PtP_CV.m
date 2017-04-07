

%% Thresholding using PtP amplitude CV

load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_All_Window_4_6_2017.mat')

options.STA_Window.Threshold.Type       = 'PeakToPeakCV';
options.STA_Window.Threshold.Channels   = 'AllChannelsMeetThreshold';
options.STA_Window.Threshold.Value       = 0.9;

% PtP Amplitude CV threshold
PtP         = calculate_STA_Window_PtP(STA_Out);
valid_PtP   = threshold_STA_Window_PtP(PtP, options.STA_Window);

clear STA_Out;

%% Thresholding using cross correlation between Delsys and STA

load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_All_Window_4_6_2017.mat')

options.Delsys_STA_Similarity.Threshold.Type       = 'Xcorr';
options.Delsys_STA_Similarity.Threshold.Channels   = 'AllChannelsMeetThreshold';
options.Delsys_STA_Similarity.Threshold.Value       = 0.8;

% Delsys/STA XCorrelation threshold
Xcorr       = calculate_STA_Xcorr()
valid_Xcorr = threshold_STA_Xcorr()