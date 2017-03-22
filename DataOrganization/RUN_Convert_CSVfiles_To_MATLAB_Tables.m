
% Convert .csv files into .mat files
    % Run this after converting .hpf files to .csv files using the Delsys File Utility
    % First, place the .csv files in a folder called 'array'
    % Then run this code to convert into .mat format (which also saves memory)
    % If desired, delete the CSV files, since they are easily recoverable and take up a lot of memory
    
    
% INPUT = folder containing all the .csv files 
    
% OUTPUT = One .mat file per .csv file
    % Each .mat file has a single table, called tbl
    % The table has a column for raw data:
        % 4 channels per sensor array sensor
        % Channels for Force traces
    
    
baseDirectory = 'C:\Users\Andrew\Box Sync\BicepsSensorArray';

%Control
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\AC\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\AL\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\BA\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\DW\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\ED\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\GR\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\HS\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\JA\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\JC\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\JF\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\MS\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\PT\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\WT\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Control\ZR\array'])

%Stroke
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\EW\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\JD\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\JL\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\JR\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\KB\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\KP\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\MM\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\NG\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\NT\array'])
convert_CSVfolder_to_MATLAB_Tables([baseDirectory '\Data\Stroke\WS\array'])

