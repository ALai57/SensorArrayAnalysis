

%     options.STA.File                           = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_AllControl.mat';
%     options.STA_Window.File                    = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Analysis\DataTable_Window_Control_4_10_2017.mat';
%     options.STA_Window.Threshold.Type          = 'Amplitude';
%     options.STA_Window.Threshold.Statistic     = 'CV';
%     options.STA_Window.Threshold.Channels      = 'AllChannelsMeetThreshold';
%     options.STA_Window.Threshold.Value         = 0.6;
%     options.STA_Window.PtPAmplitude.Statistic  = 'CV';
%     options.STA_Window.PtPDuration.Statistic   = 'CV';
%     options.FileID_Tag                         = {'SensorArrayFile','ArrayNumber','MU'}; 

function MU_Data = append_STA_Window_Statistics_ToSTATable(MU_Data,options)

    PtP_Out = get_STA_Window_PtP(options);

    if isempty(MU_Data)
        load(options.STA.File,'MU_Data'); 
    end
    
    PtP_Out = append_FileID_Tag(PtP_Out,options);
    MU_Data = append_FileID_Tag(MU_Data,options);

    if isequal(PtP_Out.FileID_Tag,MU_Data.FileID_Tag)
       MU_Data = [MU_Data,PtP_Out(:,4:8)]; 
       clear PtP_Out
    end
    
    MU_Data.FileID_Tag = [];
end