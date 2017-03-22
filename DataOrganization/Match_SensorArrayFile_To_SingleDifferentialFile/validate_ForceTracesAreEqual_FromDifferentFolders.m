
% directoryName = 'Q:\Andrew\DelsysArray - Copy\Data\Control\AC\csv'
% options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
% options.Trial.Plot.GroupingVariable = 'ArmType';
% input_var = fName{n}

function fEqual = validate_ForceTracesAreEqual_FromDifferentFolders(directoryName,options)
    
    theFiles = find_MatchingFilesInDifferentFolders(directoryName,options);

    for n=1:size(theFiles(1).tbl,1)
        for i=1:length(directoryName)
            fName{n,i} = [directoryName{i} '\' theFiles(i).tbl.Files{n}];
        end
        [avgError(n,1),stdError(n,1)] = validate_EqualForces(fName(n,:));
    end
    
    ePass = abs(avgError)<2;
    sPass = stdError<1;
    
    fEqual = ePass & sPass;
    
end

function [avgError,stdError] = validate_EqualForces(fName)
    
    for n=1:length(fName)
        load(fName{n})
        t{n} = tbl.Time;
        F{n} = tbl.Fz_N;
%         F{n} = calculate_ForceMagnitude_FromTable(tbl);
        
        Force(n).tbl = table(t{n},F{n},'VariableNames',{'Time','Force'});
    end
   
    for n=1:length(Force)
       sz(n) = size(Force(n).tbl,1); 
    end
    
    ind = find(sz == min(sz));
    
    for n=1:length(Force)
        Force(n).tbl{Force(n).tbl.Force==0,:} = NaN;
    end
    
    for n=1:length(fName)
       if n==ind
          F_Downsampled(n) = Force(n);
          continue;
       end

%        tic;
       [t_New, F_New] = downSample(t{n}, F{n}, t{ind}(3)-t{ind}(2));
%        toc;
       
       F_Downsampled(n).tbl = table(t_New,F_New,'VariableNames',{'Time','Force'});
    end
    
    for n=1:length(F_Downsampled)
       sz(n) = size(F_Downsampled(n).tbl,1); 
    end
    sz = min(sz);
    
    F_Diff = F_Downsampled(1).tbl.Force(1:sz)-F_Downsampled(2).tbl.Force(1:sz);
    F_Diff(isnan(F_Diff)) = [];
    avgError = mean(F_Diff);
    stdError = std(F_Diff); 
    
%     figure;  hold on;
%     plot(F_Downsampled(1).tbl.Time,F_Downsampled(1).tbl.Force);
%     plot(F_Downsampled(2).tbl.Time,F_Downsampled(2).tbl.Force);
end

