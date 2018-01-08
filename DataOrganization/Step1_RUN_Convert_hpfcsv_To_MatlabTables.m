%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Converts .csv files with raw sensor array data into .mat files
%   - .mat format saves memory
%
%   BEFORE RUNNING, SETUP:
%   - Convert .hpf files to .csv using 'Delsys File Utility'
%   - Place .csv files in a target folder  
%   
%   INPUT: 
%   - Folder containing all the .csv files 
%    
%   OUTPUT: 
%   - One .mat file per .csv file with all sensor array EMG and force data
%
%   TO EDIT:
%   - Change target folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Project folder
projectFolder = 'C:\Users\Andrew\Box Sync\BicepsSensorArray';

%Control subjects
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\AC\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\AL\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\BA\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\DW\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\ED\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\GR\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\HS\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\JA\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\JC\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\JF\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\MS\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\PT\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\WT\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Control\ZR\array'])

%Stroke survivors
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\EW\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\JD\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\JL\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\JR\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\KB\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\KP\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\MM\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\NG\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\NT\array'])
convertFolder_hpfcsv_to_MatlabTable([projectFolder '\Data\Stroke\WS\array'])

