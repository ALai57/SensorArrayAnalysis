

function STA_Out = calculate_STA_Window_FromTrial(trialData,options)

    EMG     = load_SensorArray_Data(trialData,options);
    STA_Out = initialize_OutputArray(trialData,options);
    
    arrays = unique(trialData.ArrayNumber); %For each array
    for i=1:length(arrays)
        [arrayData,ind_a] = get_ArrayData(trialData,arrays(i));
        columnInd         = get_Array_DataChannels(arrays(i));

        EMGtime = EMG.tbl{:,1};
        try
            EMG4    = EMG.tbl{:,columnInd};
        catch
            continue;
        end

        nMU = size(arrayData,1);
        ind = find(ind_a);  

        for j=1:nMU     
            if isnan(arrayData.MU(1))
                STA_Out.STA_Window{ind(j)}  = [];
                STA_Out.STA_Window_nObs{ind(j)} = [];
            else   
                try
                    [STA,nObs] = calc_STA_Window_PtP(arrayData(j,:),EMG4,EMGtime,options);
                    STA_Out.STA_Window{ind(j)}  = STA; 
                    STA_Out.STA_Window_nObs{ind(j)} = nObs;
                catch 
                    p=1;
                end
            end    
        end

    end
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
    fullFile = [options.BaseDirectory '\Data\Control\' SID '\array\' char(trial.SensorArrayFile(1))];
    EMG = load(fullFile,'tbl');
end


function [array_Data,ind_a] = get_ArrayData(MU_Data,array)      
    ind_a      = MU_Data.ArrayNumber == array;
    array_Data = MU_Data(ind_a,:);      
end

function columnInd = get_Array_DataChannels(array)
    if array == categorical({'1'})
       columnInd = 2:5;
    elseif array == categorical({'2'})
       columnInd = 8:11; 
    end
end


function [STA, nObs] = calc_STA_Window_PtP(MU_Data,EMG4,EMGtime,options)

    [t_New,MUAPs_20k] = downSample(MU_Data.Delsys_Template{1}.Time, MU_Data.Delsys_Template{1}{:,2:5}, 1/20000);
    
    Delsys_Template_20k = table(t_New,...
                                MUAPs_20k(:,1),...
                                MUAPs_20k(:,2),...
                                MUAPs_20k(:,3),...
                                MUAPs_20k(:,4),...
                                    'VariableNames',...
                                            {'Time',...
                                             'Ch1',...
                                             'Ch2',...
                                             'Ch3',...
                                             'Ch4'} );

    
    FT = MU_Data.FiringTimes{1};
    
    w_step  = options.STA.WindowStep;
    w_len   = options.STA.WindowLength;
    w_start = options.STA.WindowStart;    
    w_end   = options.STA.WindowEnd;
    
    w_ctr = w_start:w_step:w_end;
    
    flag = zeros(length(w_ctr),1);
    for n=1:length(w_ctr)
        lowerbound(n) = w_ctr(n)-w_len/2;
        upperbound(n) = w_ctr(n)+w_len/2;
        ind_FT        = FT>lowerbound(n) & FT<upperbound(n);
        nObs(n)       = sum(ind_FT);
        
        if nObs(n)==0
           flag(n)=1; 
        end
        [STA(:,:,n), ~, ~] = calculate_STA_Fast(FT(ind_FT), EMG4, EMGtime, Delsys_Template_20k);
    end
    
%     if sum(flag) % For viewing MU spike train, and epochs with no firing detected
%        figure; stem(FT,ones(length(FT),1));
%        hold on;
%        stem(w_ctr(logical(flag)),2*ones(sum(flag),1),'marker','none');
%        
%        ind_f = find(flag);
%        
%        for j=1:length(ind_f)
%             ph=patch([lowerbound(ind_f(j)),lowerbound(ind_f(j)),upperbound(ind_f(j)),upperbound(ind_f(j))],...
%                 [0,2,2,0],[0 1 0]);
%             set(ph,'facecolor',.85*[1 1 1]);
%             set(ph,'edgecolor',.95*[1 1 1]);
%             set(ph,'FaceAlpha',0.5);
%        end
%        xlabel('Time')
%        ylabel('Firing Instances')
%        title('Missing firing instances in window')
%        waitforbuttonpress;
%        close(gcf);
%     end
end
