

function Forces = calculate_ForceTrace_FromTrial(trial_Data,options)

%     profile on;
    ch = [1,7,8];
    Forces = initialize_OutputArray(trial_Data,options);
    
    % ERROR CHECK HERE
    try
        F     = load(trial_Data.SingleDifferentialFullFile{1});
        Ftime = table2array(F.tbl(:,1));
        F     = table2array(F.tbl(:,ch));
    catch
        for n=1:length(options.Trial.OutputVariable)
            Forces.(options.Trial.OutputVariable{n}) = repmat({[0 0 0 0]},size(trial_Data,1),1);
        end
        return;
    end
    

    switch options.ForceTrace.Method
        case 'FullTrace'
            Time = F(:,1);
            Fx = F(:,2);
            Fz = F(:,3);
        case 'Plateau'
            if isempty(options.ForceTrace.Start)
               options.SEMG.Start = Ftime(1); 
            end
            tStart = options.SEMG.Start; 
            tEnd   = tStart + options.SEMG.Window;
            dt     = options.SEMG.SlideStep;
    end
    
    Forces.(options.Trial.OutputVariable{1}) = {Time};
    Forces.(options.Trial.OutputVariable{2}) = {Fx};
    Forces.(options.Trial.OutputVariable{3}) = {Fz};
    
    %     profile viewer;
    plotFlag = 0;
    MVCFlag = 0;
    if plotFlag
        figure; 
        for n=1:5
            subplot(1,5,n)
            plot(Ftime,F(:,n)); hold on;
            plot(tMid,Time(:,n),'linewidth',3)
            xL = [0 max(Ftime)];
            set(gca,'xlim',xL);
            plot(xL,[SEMG_stat(n) SEMG_stat(n)])
            if ~MVCFlag
                ylim([-0.05 0.05])
            end
            if n==1
               title([char(trial_Data.SID(1)) '-' char(trial_Data.ArmType(1)) ' ' char(trial_Data.TrialName(1))],'interpreter','none') 
            end
        end
    end
    
end

function STA_Out = initialize_OutputArray(trialData,options)
    c         = {''};
    emptyCell = [];
    
    for n=1:length(options.Trial.OutputVariable) 
        tmp       = table(c,'VariableNames',{options.Trial.OutputVariable{n}});
        emptyCell = [emptyCell,tmp];
    end
    
    STA_Out   = [trialData(1,[8,10,13]),emptyCell]; 
end