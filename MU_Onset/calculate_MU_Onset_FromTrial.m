
% options.MU_Onset.Type = 'SteadyFiring';
% options.MU_Onset.SteadyFiring.Number = 2;
% options.MU_Onset.SteadyFiring.MaxInterval = 0.2;


%%%%%%%%% CONSOLIDATE INTO ONE FUNCTION
function MU_Onset = calculate_MU_Onset_FromTrial(trialData,options)

    try
        EMG_DataType = options.MU_Onset.EMG_DataType;
        calcEMGFlag = 1;
    catch
        EMG_DataType = 'SensorArray';
        calcEMGFlag = 0;
    end
    
    if strcmp(EMG_DataType, 'SensorArray')
        EMG = load_SensorArray_Data(trialData,options);
    elseif strcmp(EMG_DataType,'SingleDifferential')
        EMG = load_SingleDifferential_Data(trialData,options);
    end
    MU_Onset = initialize_OutputArray(trialData,options);
     
    if calcEMGFlag
        X = calc_EMG(EMG.tbl,options);
    end
    
    for i=1:size(trialData,1)
        
    
        FT = trialData.FiringTimes{i};
        
        Onset_Time{i,1}  = calculate_MU_OnsetTime(FT,options);
        Onset_Force{i,1} = calculate_MU_OnsetForce(Onset_Time{i},...
                                                   EMG.tbl,...
                                                   options);
       if calcEMGFlag
        Onset_EMG{i,1}   = find_MU_OnsetEMG(Onset_Time{i},...
                                            X,...
                                            trialData.ArrayLocation(i),...
                                            EMG_DataType);
       end
       
        

%         figure;
%         subplot(2,1,1)
%         F = calculate_ForceMagnitude_FromTable(EMG.tbl);
%         plot(EMG.tbl.Time,F,'k'); hold on;
%         if ~isempty(FT)
%             stem(FT,0.8*max(F)*ones(length(FT),1),'marker','none');
%             xL = get(gca,'XLim');
%             yL = get(gca,'YLim');
%             plot([Onset_Time{i} Onset_Time{i}],[yL(1) yL(2)],'r','linewidth',2)
%             plot([xL(1) xL(2)],[Onset_Force{i} Onset_Force{i}],'r','linewidth',2)
%         end
%         xlabel('Time')
%         ylabel('Force')
%         title('Calculated onset time and force')
% 
%         subplot(2,1,2)
%         plot(EMG.tbl.Time,EMG.tbl.BICM,'b'); hold on;
%         plot(X(:,1),X(:,2),'k');
%         xlabel('Time')
%         ylabel('EMG')
%         title('Calculated onset time and EMG')
        
    end
    
    MU_Onset.(options.Trial.OutputVariable{1}) = Onset_Time;
    MU_Onset.(options.Trial.OutputVariable{2}) = Onset_Force;
    try
        MU_Onset.(options.Trial.OutputVariable{3}) = Onset_EMG;
    end
%     figure; 
%     plot(cell2mat(MU_Onset.MU_Onset_Force_N),...
%          cell2mat(MU_Onset.MU_Onset_EMG),...
%          'o')
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

function EMG = load_SingleDifferential_Data(trial,options)
    SID      = char(trial.SID(1));
    fullFile = [options.BaseDirectory '\' SID '\singlediff\' char(trial.SingleDifferentialFile(1))];
    EMG = load(fullFile,'tbl');
end



function Onset_Force  = calculate_MU_OnsetForce(onset_Time,EMG,options)

    time = EMG.Time;
    tmp  = abs(time-onset_Time);
    ind  = find(tmp == min(tmp));
    
    dt = time(2)-time(1);
    
    i_Prior = ind-round(options.MU_Onset.ForcePrior/dt);
    i_Post  = ind+round(options.MU_Onset.ForcePost/dt);
    
    F = calculate_ForceMagnitude_FromTable(EMG);
    
    if i_Prior < 1
        i_Prior = 1; 
    end
    if i_Post > length(EMG.Time)
        i_Post = length(EMG.Time); 
    end
    
    Onset_Force = mean(F(i_Prior:i_Post));
    
end

function X = calc_EMG(EMG,options)

    time = EMG.Time;
    
    dt = time(2)-time(1);
    
    fLen = options.MU_Onset.MAF.Length;
    fLen = round(fLen/dt);
    E = EMG{:,2:end};
    
    switch options.MU_Onset.EMGtype
        case 'MAF'
            coeff = ones(1, fLen)/fLen;
            EMG{:,2:end} = filter(coeff, 1, EMG{:,2:end});
        case 'RMS'
            c=1;
            while c<length(EMG.Time)/100
                x=c*100;
                if x<=fLen
                    X(c,:) = [time(x) ,rms( E(1:x+fLen,:) )];
                elseif length(EMG.Time)-x<fLen
                    X(c,:) = [time(x) ,rms( E(x-fLen:end,:) )];
                else
                    X(c,:) = [time(x) ,rms( E(x-fLen:x+fLen,:) )];
                end
                c=c+1;
            end
            
    end
%     figure; plot(time,E(:,1:4)); hold on;
%     plot(X(:,1),X(:,2:5));

end


function Onset_EMG  = find_MU_OnsetEMG(onset_Time,X,arr,EMG_DataType)

    tmp  = abs(X(:,1)-onset_Time);
    ind  = find(tmp == min(tmp));
    
    if strcmp(EMG_DataType,'SensorArray')
        switch arr
            case 'Medial'    
                Onset_EMG = mean( X(ind(1),[2:5]) );
            case 'Lateral'
                Onset_EMG = mean( X(ind(1),[8:11]) );
        end
    elseif strcmp(EMG_DataType,'SingleDifferential')
        Onset_EMG = X(ind(1),[2]);
    end
end


function Onset_Time  = calculate_MU_OnsetTime(FT,options)

    switch options.MU_Onset.Type
        case 'SteadyFiring'
            Onset_Time = find_Onset_SteadyFiring(FT);
    end
    
end

function Onset_Time = find_Onset_SteadyFiring(FT)
    
    if isempty(FT)
        Onset_Time = NaN;
    else
        ISI = diff(FT);

        n = 1;
        while (ISI (n) >= 0.2 || ISI (n+1) >= 0.2)
            n = n +1;
        end
        Onset_Time = FT(n);
    end
    
end
