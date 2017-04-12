
% This function performs analyses on data from each subject.
% The function reports the analysis in a word document

    % INPUTS:
        % 1) The folder where all the subject data is stored
        % 2) A brief header describing the contents of the report. The
        % header must be a function that only takes a handle to the word
        % document as an input
        % 3) The analyses to be performed. This must be a function handle.
        
    % OUTPUTS = A repot in .docx format containing all the analyses.
        


% dataFolder = 'W:\Andrew\DelsysArray - Copy\Data\Control';
% fileArray = sensorArrayFiles;

% analyses{1} = @(selection,subjFolder)print_Subject_FileSummary(selection,subjFolder);
% analyses{2} = @(selection,subjFolder)print_Subject_ForceSummary(selection,subjFolder);
% analyses{3} = @(selection,subjFolder)print_Subject_EMGSummary(selection,subjFolder);

function print_Analysis_LoopOverSubjectDataFolders(dataFolder, analyses)

%     [serverHandle, selection] = open_ConnectionToWord();

    subjs = dir(dataFolder);
    subjs = subjs(3:end);

    if ~isempty(reportDescription)

    end

    for n=1:length(subjs)   %Loop over all subjects
        subjFolder = [dataFolder '\' subjs(n).name];

        if ~isdir(subjFolder); continue; end

        selection.TypeText(['Data from subject folder: ' subjFolder char(13)]); 

        for i=1:length(analyses) % Perform each analysis requested
           analyses{i}(selection,subjFolder); 
        end

    end
    display('Done creating report.')

end




























