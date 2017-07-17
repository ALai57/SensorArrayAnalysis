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

