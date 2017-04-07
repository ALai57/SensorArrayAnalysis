

% Loop over all trials in the MU structure and perform windowed STA



options.BaseDirectory     = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray';

options.Trial.Analysis{1} = @(trial_Data,options)calculate_STA_Window_FromTrial(trial_Data,options);
options.Trial.OutputVariable = {'STA_Window_PtP','STA_Window_nObs'};

options.STA.WindowStep   = 1; % window moving step (seconds)
options.STA.WindowLength = 2;   % window length (seconds)
options.STA.WindowStart  = 7;    
options.STA.WindowEnd    = 15;


[analysis, ind_f] = loop_Over_Trials_FromTable(MU_Data,options);