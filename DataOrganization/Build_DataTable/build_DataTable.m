%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Assembles data from a single trial into a data table 
%
%   BEFORE RUNNING, SETUP:
%   - Configure and run using "Step5_RUN_Build_2Array_DataTable.m"
%
%   INPUT: 
%   - arrayFile = table with all sensor array data
%   - singlediffFile = table with all single differential data
%   - trial_Information = .mat file with MVC data and sensor array timing data
%                           For example, ramp start and plateau start times
%   - MVC = MVC data
%   - options  =  currently unused
%    
%   OUTPUT: 
%   - dataTbl = table containing ALL data
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - options - currently unused
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% VERIFY FORCE MATCH FROM ARRY AND SINGLE DIFF
% ADD DECOMP CHANNELS

function dataTbl = build_DataTable(arrayFile,singlediffFile,trial_Information,MVC,options)

    load(char(arrayFile.FullFile));

    dataTbl = [];
    for k=1:length(Array) %Loop through each array
         
        if isempty(Array(k).Decomp) % If no decomposition data
            tmp = get_BasicTrialInformation(arrayFile,singlediffFile);
            tmp = append_No_DecompositionResults(tmp,Array(k));
            tmp = repmat(tmp,size(trial_Information,1),1);
            tmp = [tmp, get_ForceTrace_Info(trial_Information,MVC)];
            dataTbl = [dataTbl;tmp]; 
        else
        
            Array(k).EMGfile = arrayFile.FullFile;

            %Get all relevant information to assemble into one big table 
            % trial 
            % decomposition
            % spike triggered averages
            % force trace
            trialInfo_tbl    = get_BasicTrialInformation(arrayFile,singlediffFile);
            Decomp_tbl       = get_Decomposition_Info(Array(k));
%             STA_tbl          = get_STA_Info(Array(k));
            STA_tbl          = get_STA_FromArrayStruct(Array(k));
            ForceTrace_tbl   = get_ForceTrace_Info(trial_Information,MVC);

            trialInfo_tbl    = repmat(trialInfo_tbl,size(Decomp_tbl,1),1);
            ForceTrace_tbl   = repmat(ForceTrace_tbl,size(Decomp_tbl,1),1);

            tmp = [trialInfo_tbl,Decomp_tbl,STA_tbl(:,4),ForceTrace_tbl];
            dataTbl = [dataTbl; tmp];
        end
    end
    
    
    dataTbl.SID           = categorical(dataTbl.SID);
    dataTbl.ArmType       = categorical(dataTbl.ArmType);
    dataTbl.ArmSide       = categorical(dataTbl.ArmSide);
    dataTbl.Experiment    = categorical(dataTbl.Experiment);
    dataTbl.TargetForce   = categorical(dataTbl.TargetForce);
    dataTbl.ArrayLocation = categorical(dataTbl.ArrayLocation);
    dataTbl.ID            = categorical(dataTbl.ID);
    dataTbl.TrialName     = categorical(dataTbl.TrialName);
    
end

function ForceTrace_tbl = get_ForceTrace_Info(trial_Information,MVC) % RampStart, PlateauStart, MaxForce_N,TargetForce_N,TargetForce_MVC
    
    trial_Information.ArmType = categorical(trial_Information.ArmType);
    nFiles = size(trial_Information,1);
    z      = zeros(nFiles,1);
    
    ForceTrace_tbl = table(z,z,z,z,z,...
                                'VariableNames',...
                                        {'MVC',...
                                        'TargetForce_MVC',...
                                        'TargetForce_N',...
                                        'RampStart',...
                                        'PlateauStart' }  );
    
    arms = unique(trial_Information.ArmType);
    
    for n=1:length(arms)
        ind_arm = trial_Information.ArmType == arms(n);
        
        ind_MVC = categorical(MVC.Properties.RowNames) == arms(n);
        ForceTrace_tbl.MVC = repmat(MVC{ind_MVC,:},nFiles,1);

        targetForce = parse_TargetForce(trial_Information);
        ind_type = targetForce.ForceType == '%MVC';
        ind = ind_type & ind_arm;
        
        if arms(n)== categorical({'UNAFF'}) & ~isequal(trial_Information.TargetForce,{'100%MVC'})  % ADJUST FOR UNAFFECTED ARM TRIALS
            MVC_Force_Aff   = norm(MVC{~ind_MVC,:},2);
            MVC_Force_Unaff = norm(MVC{ind_MVC ,:},2);
            ForceTrace_tbl.TargetForce_MVC(ind)  = targetForce.Force(ind)*MVC_Force_Aff/MVC_Force_Unaff;
            ForceTrace_tbl.TargetForce_N(ind)    = targetForce.Force(ind)*MVC_Force_Aff/100;
            ForceTrace_tbl.TargetForce_N(~ind)   = targetForce.Force(~ind)*MVC_Force_Aff/MVC_Force_Unaff;
            ForceTrace_tbl.TargetForce_MVC(~ind) = targetForce.Force(~ind)*MVC_Force_Aff/100;
        else
            MVC_Force = norm(MVC{ind_MVC,:},2);
            ForceTrace_tbl.TargetForce_MVC(ind)  = targetForce.Force(ind);
            ForceTrace_tbl.TargetForce_N(ind)    = targetForce.Force(ind)*MVC_Force/100;
            ForceTrace_tbl.TargetForce_N(~ind)   = targetForce.Force(~ind);
            ForceTrace_tbl.TargetForce_MVC(~ind) = targetForce.Force(~ind)/MVC_Force*100;
        end
    end
    ForceTrace_tbl.RampStart    = trial_Information.RampStart;
    ForceTrace_tbl.PlateauStart = trial_Information.PlateauStart;
    
end

function dataTbl = append_No_DecompositionResults(dataTbl,Array)

        
    
        %Decomp info
        dataTbl.ArrayNumber     = Array.Number;
        dataTbl.ArrayLocation   = {Array.Location};
        dataTbl.DecompChannels  = Array.DecompChannels;
        dataTbl.MU              = NaN;
        dataTbl.FiringTimes     = {[]};
        dataTbl.Delsys_Template = {[]};
        
        %STA info
        dataTbl.STA_Template    = {[]};

end

function basicInfo = get_BasicTrialInformation(arrayFile,singlediffFile)
    basicInfo             = table(arrayFile.SID,'VariableNames',{'SID'});
    basicInfo.ArmType     = arrayFile.ArmType;
    basicInfo.ArmSide     = arrayFile.ArmSide;
    basicInfo.Experiment  = arrayFile.Experiment;
    basicInfo.TargetForce = arrayFile.TargetForce;
    basicInfo.ID          = arrayFile.ID;
    basicInfo.TrialName   = {[arrayFile.TargetForce{1} '_Rep_' arrayFile.ID{1}]};
    basicInfo.SensorArrayFile         = arrayFile.Files;
    basicInfo.SingleDifferentialFile  = singlediffFile.Files;
end

function MU_tbl = get_Decomposition_Info(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    ArrayLoc = {Array.Location};
    DecompChannels = Array.DecompChannels;
    
    
    c = cell(nMU,1);
    z = zeros(nMU,1);
    MU_tbl = table([1:nMU]',c,c,'VariableNames',{'MU','FiringTimes','Delsys_Template'});
    for n=1:nMU
        MU_tbl.FiringTimes{n,1}      = Array.Decomp(n).FiringTimes;
        MU_tbl.Delsys_Template{n,1}  = Array.Decomp(n).Templates;
    end 
    
    temp = table(repmat(ArrayNum,nMU,1),repmat(ArrayLoc,nMU,1),repmat(DecompChannels,nMU,1),...
        'VariableNames',{'ArrayNumber','ArrayLocation','DecompChannels'});
    
    MU_tbl = [temp,MU_tbl];
end
