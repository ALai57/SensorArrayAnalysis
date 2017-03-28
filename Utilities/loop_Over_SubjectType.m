

% dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control'};

% options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

% options.Subject_Analyses{1}                    = @(subj_Dir, options)loop_Over_Trials(subj_Dir,options);
% options.Trial_Analyses{1}                      = @(arrayFile,singlediffFile,trial_Information,MVC,options)build_2Array_DataTable(arrayFile,...
%                                                                                                                                       singlediffFile,...
%                                                                                                                                       trial_Information,...
%                                                                                                                                       MVC,...
%                                                                                                                                       options );

function analysis = loop_Over_SubjectType(dataDirs,options)

    analysis = cell(length(options.Subject_Analyses),1);
    for status=1:length(dataDirs)
        
        SIDs = get_subFolders(dataDirs{status});

        for subj=1:length(SIDs) %Loop through each subject

            SID            = SIDs{subj};
            subj_Dir       = [dataDirs{status} '\' SID];
           
            tic;
            for a=1:length(options.Subject_Analyses)
                analysis{a} = [analysis{a}; options.Subject_Analyses{a}(subj_Dir,options)];
            end     
            elapsed = toc;
            fprintf('Subject: %-5s  | Elapsed time: %-8.2f secs\n',SID,elapsed); 
            
        end
    end

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