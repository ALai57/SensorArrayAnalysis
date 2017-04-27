

function print_OptionsAndAnalyses(selection, options, report)

    if options.STA_Window.Threshold.On 
        selection.TypeText(['Thresholding and STA Windowing options.' char(13)])  
        STA_Window_options = load(options.STA_Window.File,'options');
        print_StructToWord(selection,STA_Window_options.options)
        print_StructToWord(selection,options.STA_Window)   
    end
    options = rmfield(options,'STA_Window');
    
    if options.STA_CrossCorrelation.Threshold.On
        selection.TypeText(['Delsys Template/ STA template thresholding options.' char(13)])  
        print_StructToWord(selection,options.STA_CrossCorrelation)     
    end
    options = rmfield(options,'STA_CrossCorrelation'); 
    
    if options.MUs.Threshold.On
        selection.TypeText(['Number of MU threshold.' char(13)])  
        print_StructToWord(selection,options.MUs);
    end
    options = rmfield(options,'MUs'); 
        
    selection.TypeText(['Analysis options.' char(13)]) 
    print_StructToWord(selection,options)
    
    selection.TypeText(['Reporting functions performed.' char(13)]) 
    print_StructToWord(selection,report);
    
    selection.InsertBreak;
end