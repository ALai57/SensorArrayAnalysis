

%%%% RUN TEST LOOP FOR BUILDING TABLE
dataDirs(1)  =  {'C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\Data\Stroke'};

options.SensorArray.FileNameConvention         = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 
options.SingleDifferential.FileNameConvention  = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID','FileType'}; 

options.Subject_Analyses{1}                    = @(subj_Dir, options)loop_Over_Trials(subj_Dir,options);
options.Trial_Analyses{1}                      = @(arrayFile,singlediffFile,trial_Information,MVC,options)build_2Array_DataTable(arrayFile,...
                                                                                                                                      singlediffFile,...
                                                                                                                                      trial_Information,...
                                                                                                                                      MVC,...
                                                                                                                                      options );
                                                                                                                                  
analysis  = loop_Over_SubjectType(dataDirs,options); 
MU_Data = convert_Build_2Array_DataTable_StructToTable(analysis);