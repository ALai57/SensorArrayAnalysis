%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Searching through a folder, converts all .csv files with raw sensor array data into .mat files
%   - .mat format saves memory
%
%   BEFORE RUNNING, SETUP:
%   - Convert .hpf files to .csv using 'Delsys File Utility'
%   - Place .csv files in a target folder  
%   - Configure and run with "Step1_RUN_Convert_CSVfiles_To_MATLAB_Tables"
%   
%   INPUT: 
%   - directoryName = Folder containing all the .csv files 
%    
%   OUTPUT: 
%   - One .mat file per .csv file with all sensor array EMG and force data
%
%   TO EDIT:
%   - Change target folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convertFolder_hpfcsv_to_MatlabTable(directoryName)
    
    %Default behavior
    if ~exist(directoryName)
        directoryName = get_NewDirectory();
    end
    
    printStartingMessage_ToConsole();
    
    csvFiles = get_AllFilesWithExtension(directoryName,'.csv');
    nFiles   = length(csvFiles);
    
    fid = create_LogFile(directoryName);
    printNumFilesFound_ToLog(fid, nFiles)
    
    for n=1:nFiles
        fName = csvFiles{n};
        sName = get_SaveName(fName);
        
        convertFile_hpfcsv_to_MatlabTable(directoryName, fName, sName)
        printIteration_ToLog(fName,sName)
        printIteration_ToConsole(n, nFiles, sName)
    end
    
    fclose(fid);
    fprintf('Conversion complete\n')
end

function directoryName = get_NewDirectory()
    default_dir = 'Q:\Andrew\DelsysArray - Copy\Data';
    default_msg = 'Choose folder of CSV files to convert';
    directoryName = uigetdir(default_dir, default_msg);
end

function printStartingMessage_ToConsole()
    disp('Converting .csv files to .mat tables');
end

function printNumFilesFound_ToLog(fid, nFiles)
    fprintf(fid, '%d ''.csv'' files found \n',nFiles);
end

function printIteration_ToConsole(n, nFiles, sName)
    fprintf('Converted %d/%d. New file name = %s\n', n, nFiles, sName);
end

function printIteration_ToLog(fName,sName)
    fprintf(fid, '%-50s  -->   to  -->   %-50s\n', fName, sName);
end

function sName = get_SaveName(fName)
    sName = strrep(fName,'.hpf','');
    sName = strrep(sName,'.csv','_SensorArray.mat');
end

function fid = create_LogFile(directoryName)
    fid = fopen([directoryName '\CSV_to_MATLABTable_ConversionLog.txt'],'wt');
    fprintf(fid, 'File conversion log\n%s \n\n\n',datestr(now));
    fprintf(fid, 'Base folder = %s \n',directoryName);
end
