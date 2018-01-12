
function MU_Data = append_XC_ToSTATable(MU_Data,options)

    dTemps = convert_DelsysTemplate_SamplingRate(MU_Data.Delsys_Template);
    display('Changed Delsys Sampling Rate');
    sTemps = pad_STA(MU_Data.STA_Template);
    display('Zero padded STA Templates');
    
    xc = zeros(size(MU_Data,1),4);
    for n=1:size(dTemps)
        if isempty(dTemps{n})
            continue;
        end
        for i=1:4
            xc(n,i) = max(xcorr(dTemps{n}(:,i),sTemps{n}(:,i),'coeff'));
        end
    end
    display('Finished calculating Delsys/STA cross-correlation');
    MU_Data.XC = xc;
    
    stat = options.STA_CrossCorrelation.XC.Statistic;
    switch stat
        case 'Mean_XC'
            MU_Data.(stat) = mean(xc,2);
        case 'Max_XC'
            MU_Data.(stat) = max(xc')';
        case 'Min_XC'
            MU_Data.(stat) = min(xc')';
        
    end
end


function Delsys_Template = convert_DelsysTemplate_SamplingRate(Delsys_Template)

    for n=1:size(Delsys_Template)
        if isempty(Delsys_Template{n})
            continue;
        end
        tmp = Delsys_Template{n}{:,[2:5]};
        Delsys_Template{n} = resample(tmp,2,5)/1000;
    end
    
end

function STA_Template = pad_STA(STA_Template)

    for n=1:size(STA_Template)
        if isempty(STA_Template{n})
            continue;
        end
        tmp = STA_Template{n};
        STA_Template{n} = padarray(tmp,[410-size(tmp,1)],'post');
    end
    
end