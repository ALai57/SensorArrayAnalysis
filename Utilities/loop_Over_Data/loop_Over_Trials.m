
% 
% options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
% 
% options.Trial_Analyses{1}                      = @(arrayFile,singlediffFile,trial_Information,MVC,options)build_2Array_DataTable(arrayFile,...
%                                                                                                                                       singlediffFile,...
%                                                                                                                                       trial_Information,...
%                                                                                                                                       MVC,...
%                                                                                                                                       options );
% subj_Dir = 'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Control\WT';                                                                                                                                  
%                                                                                                                                   

function analysis = loop_Over_Trials(subj_Dir, options)

    [~,SID,~] = fileparts(subj_Dir);
    
    array_Dir      = [subj_Dir '\array'];
    singlediff_Dir = [subj_Dir '\singlediff'];
    info_Dir       = [subj_Dir '\trial_Information'];
    
    options.Trial   = options.SensorArray;
    arrayFiles      = extract_FileInformation_FromFolder(array_Dir,'.mat',options);
    options.Trial   = options.SingleDifferential;
    singlediffFiles = extract_FileInformation_FromFolder(singlediff_Dir,'.mat',options);
    
    load([info_Dir '\' SID '_Trial_Information.mat'])
    
    analysis = cell(length(options.Trial_Analyses),1);
    for i=1:size(arrayFiles,1) % Loop through each trial 
        for j=1:length(options.Trial_Analyses)
            analysis{j} = [analysis{j}; options.Trial_Analyses{j}(arrayFiles(i,:),...
                                                                  singlediffFiles(i,:),...
                                                                  forceMatching_Info(i,:),...
                                                                  MVC,...
                                                                  options )];
        end
    end

end