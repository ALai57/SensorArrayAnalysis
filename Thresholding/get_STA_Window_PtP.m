


function PtP_out = get_STA_Window_PtP(options)

    load(options.STA_Window.File,'STA_Window');

    options.STA.Amplitude.Statistic = 'All';
    options.STA.Duration.Statistic = 'All';
    [PtP_Amp  , PtP_Duration] = calculate_STA_AmplitudeAndDuration(STA_Window.STA_Window, options);
    PtP_Amp_Stat              = calculate_STA_Window_PtP_Statistic(PtP_Amp     , options.STA_Window.PtPAmplitude);
    PtP_Duration_Stat         = calculate_STA_Window_PtP_Statistic(PtP_Duration, options.STA_Window.PtPDuration);

    ampStatistic              = options.STA_Window.PtPAmplitude.Statistic;
    durationStatistic         = options.STA_Window.PtPDuration.Statistic;
    
    PtP_tbl = table(PtP_Amp,...
                    PtP_Amp_Stat,...
                    PtP_Duration,...
                    PtP_Duration_Stat,...
                        'VariableNames',...
                                {'PtP_Amplitude',...
                                 ['PtP_Amplitude_' ampStatistic],...
                                 'PtP_Duration',...
                                 ['PtP_Duration_' durationStatistic]});
                            
    PtP_out = [STA_Window(:,[1:3,5]),PtP_tbl];
end

%     PtP_Valid = threshold_STA_Window_PtP(PtP_tbl, options.STA_Window.Threshold);
%     
%     type         = options.STA_Window.Threshold.Type;
%     stat         = options.STA_Window.Threshold.Statistic; 
%     variableName = ['PtP_' type '_' stat];
%     PtP_tbl  	 = [PtP_tbl, table(PtP_Valid,'VariableNames',{['Valid_' variableName]})];