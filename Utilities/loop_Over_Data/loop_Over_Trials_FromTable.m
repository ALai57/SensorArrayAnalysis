

% options.STA.WindowStep   = 0.5; % window moving step (seconds)
% options.STA.WindowLength = 0.5;   % window length (seconds)
% options.STA.WindowStart  = 7;    
% options.STA.WindowEnd    = 11;
% options.Trial.Analysis{1} = @(trial_Data,options)calculate_STA_Window_FromTrial(trial_Data,options);
% options.Trial.OutputVariable = {'STA_Window_PtP'};
% options.BaseDirectory     = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray';

function [analysis_unwrap, ind_f] = loop_Over_Trials_FromTable(MU_Data,options)

    trialList = categorical(MU_Data.SensorArrayFile);
    trials    = unique(trialList);
    
    analysis         = cell(length(trials),1);
    analysis_unwrap  = initialize_OutputArray(MU_Data,options);
    
    
    fprintf(1,'%s \n',func2str(options.Trial.Function{1})); 
    fprintf(1,'Looping over trials: %6d/%6d',0,length(trials));
    for n=1:length(trials)
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b%6d/%6d',n,length(trials));
        [trialData,ind_f{n}] = get_TrialData(MU_Data,trials(n));
        analysis{n} = options.Trial.Function{1}(trialData,options); 
    end
    fprintf('\n')
    
    try
        if isequal(func2str(options.Trial.Function{1}), ...
               '@(trial_Data,options)calculate_ForceTrace_FromTrial(trial_Data,options)') || ...
           isequal(func2str(options.Trial.Function{1}), ...
               '@(trial_Data,options)calculate_OnionSkin(trial_Data,options)')
            tmp = [];
            for n=1:length(trials)
                tmp = [tmp;analysis{n}];
            end    
            analysis_unwrap = tmp;
        return;
        end
    end
    for n=1:length(trials)
        for i=1:length(options.Trial.OutputVariable)
            varname = options.Trial.OutputVariable{i};
            switch class(analysis{n})
                case 'table' 
                    analysis_unwrap.(varname)(ind_f{n}) = analysis{n}.(varname);
                case 'cell'
                    analysis_unwrap.(varname)(ind_f{n}) = analysis{n};
            end
        end
    end
    
end

function emptyAnalysis = initialize_OutputArray(MU_Data,options)
    c         = cell(size(MU_Data,1),1);
    emptyCell = [];
    
    for n=1:length(options.Trial.OutputVariable) 
        tmp       = table(c,'VariableNames',{options.Trial.OutputVariable{n}});
        emptyCell = [emptyCell,tmp];
    end
    
    emptyAnalysis   = [MU_Data(:,[8,10,13]),emptyCell]; 
end

function [trial_Data,ind_t] = get_TrialData(MU_Data,trialFile)
    ind_t      = categorical(MU_Data.SensorArrayFile) == trialFile;
    trial_Data = MU_Data(ind_t,:);
end








% function [analysis_unwrap, ind_f] = loop_Over_Trials_FromTable(MU_Data,options)
% 
%     trialList = categorical(MU_Data.SensorArrayFile);
%     trials    = unique(trialList);
%     
%     analysis         = cell(length(trials),1);
%     analysis_unwrap  = initialize_OutputArray(MU_Data,options);
%     
%     for n=1:length(trials)
%         
%         tic;
%         [trialData,ind_f{n}] = get_TrialData(MU_Data,trials(n));
%         
%         for k=1:length(options.Trial.Analysis)
%            analysis{n} = options.Trial.Analysis{k}(trialData,options); 
%         end
% 
%         toc;
%     end
%     
% 
%     for n=1:length(trials)
%         for i=1:length(options.Trial.OutputVariable)
%             varname = options.Trial.OutputVariable{i};
%             analysis_unwrap.(varname)(ind_f{n}) = analysis{n}.(varname);
%         end
%     end
%     
% end


















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% FOR PARALLEL COMPUTING TOOLBOX %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% function STA_Out = calculate_STA_Window_PtP(MU_Data,options)  
% 
%     base = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray';
%     filelist = categorical(MU_Data.SensorArrayFile);
%     files    = unique(filelist);
% 
%     c = cell(size(MU_Data,1),1);
%     emptyCell = table(c,c,'VariableNames',{'STA_Window_PtP','STA_XC'});
%     STA_Out = [MU_Data(:,[8,10]),emptyCell];
%     
%     file_STA_Window_PtP = cell(length(files),1);
%     
%     for n=1:length(files)
%         ind_f         = filelist == files(n);
%         trial{n,1}    = MU_Data(ind_f,:);
%         SID{n,1}      = char(trial{n}.SID(1));
%         fullFile{n,1} = [base '\Data\Control\' SID{n} '\array\' char(files(n))];
%     end
%     clear MU_Data;
%     
% %     ticBytes(gcp);
%     parfor n=1:length(files)
%         tic;
%         EMG                    = load(fullFile,'tbl');
%         file_STA_Window_PtP{n} = calc_FileSTA(trial,options); 
%         toc;
%     end
% %     tocBytes(gcp);
%     
% end
%  
% function STA_Out = calc_FileSTA(File_MU_Data,options)
%         
%         c = cell(size(File_MU_Data,1),1);
%         emptyCell = table(c,c,'VariableNames',{'STA_Window_PtP','STA_XC'});
%         STA_Out = [MU_Data(:,[8,10]),emptyCell];
% 
%         %For each array
%         arrays = unique(File_MU_Data.ArrayNumber);
%         
%         for i=1:length(arrays)
%             ind_a         = File_MU_Data.ArrayNumber == arrays(i);
%             array_MU_Data = File_MU_Data(ind_a,:);
%             
%             if arrays(i) == categorical({'1'})
%                columnInd = [2:5];
%             elseif arrays(i) == categorical({'2'})
%                columnInd = [8:11]; 
%             end
%             
%             EMGtime = EMG.tbl{:,1};
%             EMG4    = EMG.tbl{:,columnInd};
%             
%             nMU = size(array_MU_Data,1);
%             ind = find(ind_a); 
%             
%             for j=1:nMU     
%                 if isnan(array_MU_Data.MU(1))
%                     STA_Out.STA_Window_PtP{ind(j)} = [];
%                 else       
%                     STA_Out.STA_Window_PtP{ind(j)} = {calc_STA_Window_PtP(array_MU_Data(j,:),EMG4,EMGtime,options)}; 
%                 end      
%             end
%         end
% end