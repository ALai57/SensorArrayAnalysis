
% dataFolder = 'W:\Andrew\DelsysArray - Copy\Data\Control';
% fileArray = sensorArrayFiles;

% analyses{1} = @(selection,subjFolder)print_Subject_FileSummary(selection,subjFolder);
% analyses{2} = @(selection,subjFolder)print_Subject_ForceSummary(selection,subjFolder);
% analyses{3} = @(selection,subjFolder)print_Subject_EMGSummary(selection,subjFolder);

function report_BySubject(dataFolder, reportDescription, analyses)

    [serverHandle, selection] = open_ConnectionToWord();
    
    try
        subjs = dir(dataFolder);
        subjs = subjs(3:end);

        if ~isempty(reportDescription)
            reportDescription(selection)
        end
            
        for n=1:length(subjs)   %Loop over all subjects
            subjFolder = [dataFolder '\' subjs(n).name];
            
            selection.TypeText(['Data from subject folder: ' subjFolder char(13)]); 
            
            for i=1:length(analyses)
               analyses{i}(selection,subjFolder); 
            end
            
            %Show "F vs. time figures" by arm type 

        end
        display('Done creating report.')
    catch
        delete(serverHandle)
    end
end


% print_Subject_FileSummary(selection,subjFolder);          
% print_Subject_ForceSummary(selection,subjFolder);
% print_Subject_EMGSummary(selection,subjFolder);



























