
% options.SensorArray.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

% dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control'};
% dataDirs(2)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke'};

% infoModule{1} = @(Array)process_Array_Decomposition(Array);
% infoModule{2} = @(array_Dir,Array,arrayFile)process_Array_STA(array_Dir,Array,arrayFile);
% infoModule{3} = @()process_Array_ForceTraceInfo();                                       % RampStart, PlateauStart, MaxForce_N,TargetForce_N,TargetForce_MVC



function tbl = build_SensorArrayDataTable(dataDirs,options)

    tbl = initialize_SensorArrayDataTable();

    for status=1:length(dataDirs)
        
        SIDs = get_subFolders(dataDirs{status});

        for subj=1:length(SIDs) %Loop through each subject

            SID            = SIDs{subj};
            subj_Dir       = [dataDirs{status} '\' SID];
           
            tic;
            process_Subject(subj_Dir,options)      
            elapsed = toc;
            fprintf('Subject: %-5s  | Elapsed time: %-8.2f secs\n',SID,elapsed); 
            
        end
    end

    tbl.SID = categorical(tbl.SID);
    tbl.ArmType = categorical(tbl.ArmType);
    tbl.ArmSide = categorical(tbl.Side);
    tbl.TrialName = categorical(tbl.Trial);

    clearvars -except tbl AnalysisDir subjStatus
end

function process_Subject(subj_Dir, options)

    array_Dir      = [subj_Dir '\array'];
    singlediff_Dir = [subj_Dir '\singlediff'];

    options.Trial   = options.SensorArray;
    arrayFiles      = extract_FileInformation_FromFolder(array_Dir,'.mat',options);
    options.Trial   = options.SingleDifferential;
    singlediffFiles = extract_FileInformation_FromFolder(singlediff_Dir,'.mat',options);
    
    c = 1; % c represents each sucessful decomposition.
    for i=1:size(arrayFiles,1) % Loop through each trial 
        process_Trial(arrayFiles(i,:),singlediffFiles(i,:))
    end

end

function dataTbl = process_Trial(arrayFile,singlediffFile)

    matObj = matfile(char(arrayFile.FullFile));
    fileInfo = whos(matObj,'Array');
    
    %%%%%%%%%%%%%%%%% CHECK THAT SINGLE DIFF FILES ARE EQUAL TO ARRAY FILES%%%%%%%%%%%%%
    
    if isempty(fileInfo)
        dataTbl = get_BasicTrialInformation(arrayFile,singlediffFile);
        %Decomp info
        dataTbl.ArrayNum        = {[]};
        dataTbl.nMU             = {[]};
        dataTbl.FiringTimes     = {[]};
        dataTbl.Delsys_Template = {[]};
        %STA info
        dataTbl.STA_Template    = {[]};
        %Force info
        dataTbl.RampStart       = {[]};
        dataTbl.PlateauStart    = {[]};
        dataTbl.MaxForce_N      = {[]};
        dataTbl.TargetForce_N   = {[]};
        dataTbl.TargetForce_MVC = {[]};
        return;
    end

    load(char(arrayFile.FullFile));

    dataTbl = [];
    for k=1:length(Array) %Loop through each array
        Array(k).EMGfile = arrayFile.FullFile;
        
        
        trialInfo_tbl    = get_BasicTrialInformation(arrayFile,singlediffFile);
        Decomp_tbl       = get_Decomposition_Info(Array(k));
        STA_tbl          = get_STA_Info(Array(k));
        ForceTrace_tbl   = process_Array_ForceTraceInfo(); % RampStart, PlateauStart, MaxForce_N,TargetForce_N,TargetForce_MVC
    
        trialInfo_tbl    = repmat(trialInfo_tbl,size(Decomp_tbl,1),1);
        
        tmp = [trialInfo_tbl,Decomp_tbl,STA_tbl];
        dataTbl = [dataTbl; tmp];
    end
        
%     TargetForce_N   = sqrt(MVC*MVC')*TargetForce_MVC/100;
%     MaxForce_N      = MVC;
    
end

function trialInfo_tbl = get_BasicTrialInformation(arrayFile,singlediffFile)
    trialInfo_tbl             = table(arrayFile.SID,'VariableNames',{'SID'});
    trialInfo_tbl.ArmType     = arrayFile.ArmType;
    trialInfo_tbl.ArmSide     = arrayFile.ArmSide;
    trialInfo_tbl.Experiment  = arrayFile.Experiment;
    trialInfo_tbl.TargetForce = arrayFile.TargetForce;
    trialInfo_tbl.ID          = arrayFile.ID;
    trialInfo_tbl.TrialName   = arrayFile.Experiment;
    trialInfo_tbl.SensorArrayFile         = arrayFile.Files;
    trialInfo_tbl.SingleDifferentialFile  = singlediffFile.Files;
end

function MU_tbl = get_Decomposition_Info(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    
    MU_tbl = table([],{},{},'VariableNames',{'MU','FiringTimes','Delsys_Template'});
    for n=1:nMU %Loop through each MU
        MU_tbl.MU(n,1)               = n;
        MU_tbl.FiringTimes{n,1}      = Array.Decomp(n).FiringTimes;
        MU_tbl.Delsys_Template{n,1}  = Array.Decomp(n).Templates;
    end 
    
    temp = table(repmat(ArrayNum,nMU,1),'VariableNames',{'ArrayNumber'});
    
    MU_tbl = [temp,MU_tbl];
end

function STA_tbl = get_STA_Info(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    
    EMG = load(char(Array.EMGfile),'tbl');
    
    STA_tbl = table([],{},{},'VariableNames',{'MU','FiringTimes','STA_Template'});
    for n=1:nMU %Loop through each MU
        tic;
        STA_tbl.MU(n,1)               = n;
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

function subFolders = get_subFolders(dataDirs)
    contents = dir(dataDirs);
    
    dirFlag        = false(length(contents),1);
    subFolders = {};
    for n=3:length(contents)
       if isdir([contents(n).folder '\' contents(n).name])
           dirFlag(n) = true;
           subFolders(end+1,1) = {contents(n).name};
       end
    end
    
end

function tbl = initialize_SensorArrayDataTable()

    tbl = table([],[],[],[],[], [],[],[],[],[],...
                [],[],[],[],[], [],[],[],[],...
                'VariableNames',...
                    {'SID',...
                     'ArmType',...
                     'ArmSide',...
                     'Experiment',...
                     'TargetForce',...
                     'ID',...
                     'TrialName',...
                     'SensorArrayFile',...
                     'SingleDifferentialFile',...
                     'Array',...
                     'MU',...
                     'FiringTimes',...
                     'Delsys_Template',...
                     'STA_Template',...
                     'RampStart',...  
                     'PlateauStart'...
                     'MaxForce_N',...
                     'TargetForce_N',...
                     'TargetForce_MVC'}   );

    %              'ThresholdForce_N','ThresholdForce_MVC',
end