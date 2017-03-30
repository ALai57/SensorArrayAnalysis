
% VERIFY FORCE MATCH FROM ARRY AND SINGLE DIFF
% ADD DECOMP CHANNELS

function dataTbl = build_2Array_DataTable(arrayFile,singlediffFile,trial_Information,MVC,options)

    load(char(arrayFile.FullFile));

    dataTbl = [];
    for k=1:length(Array) %Loop through each array
        
        if isempty(Array(k).Decomp)
            tmp = get_BasicTrialInformation(arrayFile,singlediffFile);
            tmp = append_No_DecompositionResults(tmp,k,Array(k).DecompChannels);
            tmp = repmat(tmp,size(trial_Information,1),1);
            tmp = [tmp, get_ForceTrace_Info(trial_Information,MVC)];
            dataTbl = [dataTbl;tmp]; 
        else
        
            Array(k).EMGfile = arrayFile.FullFile;

    %         profile on
            trialInfo_tbl    = get_BasicTrialInformation(arrayFile,singlediffFile);
            Decomp_tbl       = get_Decomposition_Info(Array(k));
            STA_tbl          = get_STA_Info(Array(k));
            ForceTrace_tbl   = get_ForceTrace_Info(trial_Information,MVC);
    %         profile viewer

            trialInfo_tbl    = repmat(trialInfo_tbl,size(Decomp_tbl,1),1);
            ForceTrace_tbl   = repmat(ForceTrace_tbl,size(Decomp_tbl,1),1);

            tmp = [trialInfo_tbl,Decomp_tbl,STA_tbl(:,4),ForceTrace_tbl];
            dataTbl = [dataTbl; tmp];
        end
    end
    
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
        MVC_Force = norm(MVC{ind_MVC,:},2);
        ForceTrace_tbl.TargetForce_MVC(ind)  = targetForce.Force(ind);
        ForceTrace_tbl.TargetForce_N(ind)    = targetForce.Force(ind)*MVC_Force/100;
        ForceTrace_tbl.TargetForce_N(~ind)   = targetForce.Force(~ind);
        ForceTrace_tbl.TargetForce_MVC(~ind) = targetForce.Force(~ind)/MVC_Force*100;
 
    end
    ForceTrace_tbl.RampStart    = trial_Information.RampStart;
    ForceTrace_tbl.PlateauStart = trial_Information.PlateauStart;
    
end

function dataTbl = append_No_DecompositionResults(dataTbl,arrayNumber,decompChannels)

        %Decomp info
        dataTbl.ArrayNumber     = categorical({num2str(arrayNumber)});
        dataTbl.DecompChannels  = {decompChannels};
        dataTbl.MU              = NaN;
        dataTbl.FiringTimes     = {[]};
        dataTbl.Delsys_Template = {[]};
        
        %STA info
        dataTbl.STA_Template    = {[]};

end

function trialInfo_tbl = get_BasicTrialInformation(arrayFile,singlediffFile)
    trialInfo_tbl             = table(arrayFile.SID,'VariableNames',{'SID'});
    trialInfo_tbl.ArmType     = arrayFile.ArmType;
    trialInfo_tbl.ArmSide     = arrayFile.ArmSide;
    trialInfo_tbl.Experiment  = arrayFile.Experiment;
    trialInfo_tbl.TargetForce = arrayFile.TargetForce;
    trialInfo_tbl.ID          = arrayFile.ID;
    trialInfo_tbl.TrialName   = {[arrayFile.TargetForce{1} '_Rep_' arrayFile.ID{1}]};
    trialInfo_tbl.SensorArrayFile         = arrayFile.Files;
    trialInfo_tbl.SingleDifferentialFile  = singlediffFile.Files;
end

function MU_tbl = get_Decomposition_Info(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    DecompChannels = Array.DecompChannels;
    
    c = cell(nMU,1);
    z = zeros(nMU,1);
    MU_tbl = table([1:nMU]',c,c,'VariableNames',{'MU','FiringTimes','Delsys_Template'});
    for n=1:nMU
        MU_tbl.FiringTimes{n,1}      = Array.Decomp(n).FiringTimes;
        MU_tbl.Delsys_Template{n,1}  = Array.Decomp(n).Templates;
    end 
    
    temp = table(repmat(ArrayNum,nMU,1),repmat(DecompChannels,nMU,1),'VariableNames',{'ArrayNumber','DecompChannels'});
    
    MU_tbl = [temp,MU_tbl];
end

function STA_tbl = get_STA_Info(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    
    EMG = load(char(Array.EMGfile),'tbl');
   
    c = cell(nMU,1);
    z = zeros(nMU,1);
    STA_tbl = table([1:nMU]',c,c,'VariableNames',{'MU','FiringTimes','STA_Template'});
    for n=1:nMU
        tic;
        STA_tbl.FiringTimes{n,1}      = Array.Decomp(n).FiringTimes;
        STA_tbl.STA_Template{n,1}     = get_STA(Array.Decomp(n), EMG.tbl, Array.Number);
        toc;
    end 
    
    temp = table(repmat(ArrayNum,nMU,1),'VariableNames',{'ArrayNumber'});
    
    STA_tbl = [temp,STA_tbl];
end

function STA = get_STA(Decomp,EMG,arrayNumber)

    [t_New,MUAPs_20k] = downSample(Decomp.Templates.Time, Decomp.Templates{:,2:5}, 1/20000);
    
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

    if arrayNumber == categorical({'1'})
       columnInd = [1,2:5];
    elseif arrayNumber == categorical({'2'})
       columnInd = [1,8:11]; 
    end

    [STA, ~, ~] = calculate_STA(Decomp.FiringTimes, EMG(:,columnInd), Delsys_Template_20k);

end