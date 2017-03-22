   

function print_Subject_FileSummary(selection,subjFolder)

    options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','DataType'};
    options.Trial.Reporting.Stat = 'TargetForce';
    options.Trial.Reporting.Grouping = 'ArmType';
    options.Trial.Reporting.DefaultTable = @(groupingVariable)create_DefaultForceTable_2Array(groupingVariable);
    
    %Report all force traces - sensor array
    sensorArrayFolder = [subjFolder '\array'];
    sensorArrayFiles = get_AllFilesWithExtension(sensorArrayFolder,'.mat'); 
    tbl_SensorArray = get_TrialsSummary(sensorArrayFiles,options);
    tbl_SensorArray = add_toVariableNames(tbl_SensorArray,'_Array');
    
    %Report all force traces - single differential
    singleDifferentialFolder = [subjFolder '\singlediff'];
    singleDifferentialFiles = get_AllFilesWithExtension(singleDifferentialFolder,'.mat'); 
    tbl_SingleDifferential = get_TrialsSummary(singleDifferentialFiles,options);
    tbl_SingleDifferential = add_toVariableNames(tbl_SingleDifferential,'_SD');
    
    tbl_Out = [tbl_SensorArray tbl_SingleDifferential];
    
    print_TableToWord(selection,tbl_Out);
    selection.TypeText(['Array = Sensor Array. SD = Single Differential. ' char(13)]); 
end


function tbl = get_TrialsSummary(fileArray,options)
    
    reportStat = options.Trial.Reporting.Stat;
    reportBy   = options.Trial.Reporting.Grouping;
    
    reportingVar = []; groupingVar = [];
    for n=1:length(fileArray)
        reportingVar{n,1} = extract_Information_FromFileName(fileArray{n},options.Trial,reportStat);
        groupingVar{n,1}  = extract_Information_FromFileName(fileArray{n},options.Trial,reportBy);
    end
    

%     tbl = create_DefaultForceTable_2Array(groupingVar);
    if isempty(groupingVar)
       groupingVar{1,1} = 'None'; 
       reportingVar{1,1} = 'None';  
    end
    tbl = options.Trial.Reporting.DefaultTable(groupingVar);
    tbl = fill_TrialsSummaryTable(tbl,groupingVar,reportingVar);
    
end

function tbl = fill_TrialsSummaryTable(tbl,groupingVar,reportingVar)

    trialTypes      = tbl.Properties.RowNames;
    trialConditions = tbl.Properties.VariableNames;
    
    %Loop over each arm type here
    for i=1:length(reportingVar)
        r = find(ismember(trialTypes     ,reportingVar{i}));
        c = find(ismember(trialConditions, groupingVar{i}));
        
        if ~r 
            tbl{end-1,c}=tbl{r,c}+1;
        end
        tbl{r,c}=tbl{r,c}+1;
    end  
    
    for i=1:length(trialConditions)
        tbl{end,i}=sum(tbl{:,i});
    end
end

function tbl = add_toVariableNames(tbl,theString)

    varNames = tbl.Properties.VariableNames;
    
    for n=1:length(varNames)
       varNames{n} = [varNames{n} theString]; 
    end

    tbl.Properties.VariableNames = varNames;
end

function tbl = create_DefaultForceTable_2Array(groupingVar)

    conditions  = unique(groupingVar);
    nConditions = length(conditions);
    
    forceLevels = {'100%MVC',...
                   '20%MVC',...
                   '30%MVC',...
                   '40%MVC',...
                   '50%MVC',...
                   '60%MVC',...
                   '10Newtons',...
                   '15Newtons',...
                   '20Newtons',...
                   '25Newtons',...
                   '30Newtons',...
                   'Other',...
                   'Total'};

    z=zeros(length(forceLevels),nConditions);
    tbl = array2table(z);
    tbl.Properties.RowNames = forceLevels;
    tbl.Properties.VariableNames = conditions;
end