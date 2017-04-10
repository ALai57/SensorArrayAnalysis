


function PtP_Out = get_Threshold_STA_PtP(options)

    load(options.STA_Window.File,'STA_Window');

    PtP                     = calculate_STA_Window_PtP(STA_Window);
    [PtP_Valid, PtP_Stat]   = threshold_STA_Window_PtP(PtP, options.STA_Window);

    PtP_Out = table(PtP,PtP_Valid,PtP_Stat,'VariableNames',{'PtP_Amplitude','PtP_Valid','PtP_CV'});
    PtP_Out = [STA_Window(:,[1:3,5]),PtP_Out];
end