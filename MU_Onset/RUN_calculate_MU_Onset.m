
%APPLY FUNCTIONS - TAKE ONLY FUNCTION AS INPUT, SEPARATE OPTIONS?


options.BaseDirectory     = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray';
options.BaseDirectory     = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control';

theFcn = @(trial_Data,options)calculate_MU_Onset_FromTrial(trial_Data,options);

options.Trial.OutputVariable(1) = {'MU_Onset_Time'};
options.Trial.OutputVariable(2) = {'MU_Onset_Force_N'};

options.MU_Onset.Type = 'SteadyFiring';
options.MU_Onset.SteadyFiring.Number = 2;
options.MU_Onset.SteadyFiring.MaxInterval = 0.2;
options.MU_Onset.ForcePrior = 0.05;
options.MU_Onset.ForcePost  = 0.15;

[analysis, ind_f] = apply_To_Trials_In_DataTable(MU_Data, theFcn, options);