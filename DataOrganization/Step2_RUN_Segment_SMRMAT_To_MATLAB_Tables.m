%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Segments a raw data file recorded in Spike2 into trials
%   - Takes in long .mat file and segments into smaller .mat files
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw data in .smr format to .mat format using Spike2 script:
%       Spike2 script name = 'Convert_Spike2_To_MAT.s2s'
%   
%   INPUT: 
%   - The name of the .mat file to be segmented
%   - The method used to identify segment start (usually TTL trigger signal)
%   - Options, regarding how to name the segments, trial time, etc
%    
%   OUTPUT: 
%   - One .mat file per segment containing:
%       (1) tbl (a table that has channel values and timestamps)
%
%   TO EDIT:
%   - Change target mat files
%   - Change naming conventions if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
options.Segmentation.Channels           = {'BM'  ,'BL'  ,'T'  ,'Brad','Braq','Fx'  ,'Fz'  };                    % The names of the Spike2 Channels I want to keep
options.Segmentation.TableColumns       = {'BICM','BICL','TRI','BRD' ,'BRA' ,'Fx_N','Fz_N'};                    % The names I want the Spike2 Channels to have after I segment them
options.Segmentation.FileNameConvention = {'SID','ArmType','ArmSide','Experiment'};                             % The naming convention for my .smr file (separated by underscore _ )
options.Segmentation.Condition          = {'ArmType'};                                                          % The condition: for stroke experiment conditions = {AFF, UNAFF, or CTR}
options.Segmentation.TrialTime          = 26.5;                                                                 % Length of each trial
options.HPF.FileNameConvention          = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};    % Naming convention for my .hpf files
segmentationType = 'ByTrigger';                                                                                 % Method for determining segment start

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

