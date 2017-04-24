

function MU_Data = threshold_MUs(options)

    if options.STA_Window.Threshold.On
        MU_Data    = append_STA_Window_Statistics_ToSTATable([],options);  %ONLY FOR THRESHOLDING
        theField   = options.STA_Window.Threshold.Statistic;
        ind_Window = options.STA_Window.Threshold.Function{1}(MU_Data.(theField),options.STA_Window.Threshold.Value);
        % PRINT/REPORTING
    else 
        load(options.STA.File,'MU_Data');
        ind_Window = true(size(MU_Data,1),1);
    end
    
    if options.STA_CrossCorrelation.Threshold.On 
        MU_Data = append_XC_ToSTATable(MU_Data,options);
        theField = options.STA_CrossCorrelation.Threshold.Statistic;
        ind_XC = options.STA_CrossCorrelation.Threshold.Function{1}(MU_Data.(theField),options.STA_CrossCorrelation.Threshold.Value);
        % PRINT/REPORTING
    else
        ind_XC = true(size(MU_Data,1),1);
    end
    
    if options.MUs.Threshold.On 
        ind_MU = options.MUs.Threshold.Function{1}(MU_Data,options.MUs);
    else
        ind_MU = true(size(MU_Data,1),1);
    end
    
    MU_Data = MU_Data(ind_Window & ind_XC & ind_MU,:);
end