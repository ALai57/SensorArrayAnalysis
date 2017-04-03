
% options.TableOutput = {'SID',...
%                        'ArmType',...
%                        'ArmSide',...
%                        'Experiment',...
%                        'TargetForce',...
%                        'ID',...
%                        'TrialName',...
%                        'SensorArrayFile',...
%                        'SingleDifferentialFile',...
%                        'ArrayNumber',...
%                        'ArrayLocation',...
%                        'DecompChannels',...
%                        'TargetForce_MVC',...
%                        'TargetForce_N'};

function trialData_Out = get_Data_FromTrial(data,trialInfo,options)

    nArrays = options.nArrays;
    
    [trials,IA,trialNumber] = unique(data.SensorArrayFile);

    trialData_Out = [];
    for n=1:length(trials)
        trialData = data(trialNumber==n,:);
        
        for a=1:nArrays
            arrayData = get_ArrayData(trialData,a);

            tmp = [];
            for i=1:size(trialInfo,1) 
                tmp = [tmp, trialInfo{i}(arrayData,options)];
            end
                  
            trialData_Out = [trialData_Out;[arrayData(1,:),tmp]];
        end
    end
    
    trialData_Out = get_RequestedVariables(trialData_Out,options);
    
end

function arrayData_Out = get_RequestedVariables(arrayData,options)
    
    tmp           = [];
    arrayData_Out = [];
    
    tblNames = categorical(arrayData.Properties.VariableNames);
    findName = [categorical(options.TableVariables),categorical(options.NewVariableNames)]; 
    for n=1:length(findName)
       tmp    = tblNames == findName(n);
       ind(n) = find(tmp);
    end
    arrayData_Out = arrayData(:,ind);
end

function trialData = get_TrialData(data,trialName)
    ind       = data.SensorArrayFile == trialName;      
    trialData = data(ind,:);
end

function arrayData = get_ArrayData(data,array)
    ind       = data.ArrayNumber == categorical(array);      
    arrayData = data(ind,:);
end

