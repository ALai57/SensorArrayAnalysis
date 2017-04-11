


function PtP_Out = get_Threshold_STA_PtP(options)

    load(options.STA_Window.File,'STA_Window');

    [PtP_Amp  , PtP_Duration] = calculate_STA_Window_PtP(STA_Window);
    [PtP_Valid, PtP_Amp_Stat] = threshold_STA_Window_PtP(PtP_Amp, options.STA_Window);

    PtP_Out = table(PtP_Amp,PtP_Valid,PtP_Amp_Stat,PtP_Duration,...
        'VariableNames',...
        {'PtP_Amplitude','PtP_Valid','PtP_CV','PtP_Duration'});
    
    PtP_Out = [STA_Window(:,[1:3,5]),PtP_Out];
end