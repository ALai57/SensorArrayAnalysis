
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

function report_BySubject_Table(selection, MU_Data, analyses, options)

%     [serverHandle, selection] = open_ConnectionToWord();
    
    subjs = unique(MU_Data.SID);

    for n=1:length(subjs)   %Loop over all subjects

        selection.TypeText(['Data from subject : ' char(subjs(n)) char(13)]); 

        ind = MU_Data.SID == subjs(n);
        subj_MU_Data = MU_Data(ind,:);

        for i=1:length(analyses) % Perform each analysis requested
           analyses{i}(selection,subj_MU_Data,options); 
        end

    end
    display('Done analyzing subjects.')

end




























