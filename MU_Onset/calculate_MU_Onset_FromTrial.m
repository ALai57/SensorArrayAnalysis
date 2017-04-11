
% options.MU_Onset.Type = 'SteadyFiring';
% options.MU_Onset.SteadyFiring.Number = 2;
% options.MU_Onset.SteadyFiring.MaxInterval = 0.2;

function MU_Onset = calculate_MU_Onset_FromTrial(trialData,options)

    EMG     = load_SensorArray_Data(trialData,options);
    MU_Onset = initialize_OutputArray(trialData,options);
     
    for i=1:size(trialData,1)
        
    
        FT = trialData.FiringTimes{i};
        
        Onset_Time{i,1}  = calculate_MU_OnsetTime(FT,options);
        Onset_Force{i,1} = calculate_MU_OnsetForce(Onset_Time{i},EMG.tbl,options);
       
        
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
    
    MU_Onset.(options.Trial.OutputVariable{1}) = Onset_Time;
    MU_Onset.(options.Trial.OutputVariable{2}) = Onset_Force;
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

function EMG = load_SensorArray_Data(trial,options)
    SID      = char(trial.SID(1));
    fullFile = [options.BaseDirectory '\' SID '\array\' char(trial.SensorArrayFile(1))];
    EMG = load(fullFile,'tbl');
end


