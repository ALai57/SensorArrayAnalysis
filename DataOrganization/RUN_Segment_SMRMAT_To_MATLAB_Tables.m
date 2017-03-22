
% Segment a long .mat file into separate trials
    % Takes long .mat file recorded on Spike2 and segments it
    % The segments are saved using the names from the .hpf files

% INPUTS:
    % 1) The name of the long .mat file to be segmented
    % 2) The method for deciding where segments start (usually by the trigger signal)
    % 3) Options, regarding how to name the segments, trial time, etc
    
% OUTPUTS = one .mat file per segment containing a table called tbl
    % The tbl variable has:
        % One column for each channel in 'options.Segmentation.Channels'
        % One column for a time vector
        % The length of each trial is equal to 'options.Segmentation.TrialTime'
    
options.Segmentation.Channels           = {'BM'  ,'BL'  ,'T'  ,'Brad','Braq','Fx'  ,'Fz'  };                    % Channels in the Spike2 file
options.Segmentation.TableColumns       = {'BICM','BICL','TRI','BRD' ,'BRA' ,'Fx_N','Fz_N'};                    % The names I want the Spike2 Channels to have after I segment them
options.Segmentation.FileNameConvention = {'SID','ArmType','ArmSide','Experiment'};                             % The naming convention for my .smr file
options.Segmentation.Condition          = {'ArmType'};                                                          % The condition - for me this is the arm type which can be AFF, UNAFF, or CTR
options.Segmentation.TrialTime          = 26.5;                                                                 % How long is each trial?
options.HPF.FileNameConvention          = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};    % Naming convention for my .hpf files
segmentationType = 'ByTrigger';                                                                                 % How will I decide where to start my segments?

drive = 'C:\Users\Andrew\Box Sync\BicepsSensorArray';

segment_Spike2File_IntoTrials([drive '\Data\Control\AC\smr\AC_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\AL\smr\AL_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\BA\smr\BA_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\DW\smr\DW_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\ED\smr\ED_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\GR\smr\GR_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\HS\smr\HS_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\JA\smr\JA_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\JC\smr\JC_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\JF\smr\JF_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\MS\smr\MS_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\PT\smr\PT_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\WT\smr\WT_CTR_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Control\ZR\smr\ZR_CTR_R_2Array.mat'],segmentationType,options)

segment_Spike2File_IntoTrials([drive '\Data\Stroke\EW\smr\EW_AFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\EW\smr\EW_UNAFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JD\smr\JD_AFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JD\smr\JD_UNAFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JL\smr\JL_AFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JL\smr\JL_UNAFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JR\smr\JR_AFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\JR\smr\JR_UNAFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\KB\smr\KB_AFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\KB\smr\KB_UNAFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\KP\smr\KP_AFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\KP\smr\KP_UNAFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\MM\smr\MM_AFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\MM\smr\MM_UNAFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\NG\smr\NG_AFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\NG\smr\NG_UNAFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\NT\smr\NT_AFF_R_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\NT\smr\NT_UNAFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\WS\smr\WS_AFF_L_2Array.mat'],segmentationType,options)
segment_Spike2File_IntoTrials([drive '\Data\Stroke\WS\smr\WS_UNAFF_R_2Array.mat'],segmentationType,options)

