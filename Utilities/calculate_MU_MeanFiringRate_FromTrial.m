

%%%%%%%% ADD IN CODE TO MAKE SURE THAT FIRING TIEMS ARE CORRECT. SWITCH
%%%%%%%% STATMENT / take in options and calculate FT based on a window.
%%%%%%%% Prewindow = 2 after ramp.... etc.

function MU_MFR = calculate_MU_MeanFiringRate_FromTrial(trialData,options)

    MU_MFR = initialize_OutputArray(trialData,options);
     
    tStart = trialData.PlateauStart(1) + options.MFR.StartAfterPlateau(1);
    tEnd   = tStart + options.MFR.Duration;
    
    for i=1:size(trialData,1)
        
    
        FT = trialData.FiringTimes{i};
        ind = FT > tStart & FT < tEnd;
        MFR{i,1}  = sum(ind)/(tEnd-tStart);

%         figure;
%         F = calculate_ForceMagnitude_FromTable(EMG.tbl);
%         plot(EMG.tbl.Time,F,'k'); hold on;
%         if ~isempty(FT)
%             stem(FT,0.8*max(F)*ones(length(FT),1),'marker','none');
%             xL = get(gca,'XLim');
%             yL = get(gca,'YLim');
%             plot([Onset_Time(i) Onset_Time(i)],[yL(1) yL(2)],'r','linewidth',2)
%             plot([xL(1) xL(2)],[Onset_Force(i) Onset_Force(i)],'r','linewidth',2)
%         end
%         xlabel('Time')
%         ylabel('Force')
%         title('Calculated onset time and force')
        
    end
    
    MU_MFR.(options.Trial.OutputVariable{1}) = MFR;
end

function STA_Out = initialize_OutputArray(trialData,options)
    c         = cell(size(trialData,1),1);
    emptyCell = [];
    
    for n=1:length(options.Trial.OutputVariable) 
        tmp       = table(c,'VariableNames',{options.Trial.OutputVariable{n}});
        emptyCell = [emptyCell,tmp];
    end
    
    STA_Out   = [trialData(:,[8,10,13]),emptyCell]; 
end
