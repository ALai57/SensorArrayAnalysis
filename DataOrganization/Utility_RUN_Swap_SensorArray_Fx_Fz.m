%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Switches Fx and Fz channels in sensor array files
%
%   BEFORE RUNNING, SETUP:
%   - Convert raw sensor array data (.csv format) into .mat files
%   - ONLY RUN IF Fx and Fz were SWITCHED in experiment (by mistake)
%
%   INPUT: 
%   - directory to swap Fx and Fz forces in (SWITCHES ALL FILES)
%    
%   OUTPUT: 
%   - Sensor array files with Fx and Fz swaped
%
%   TO EDIT:
%   - Change target folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preprocessing - the Fx and Fz cables were swaped - this code swapes
% the forces back to their correct positions.
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\DW\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\ED\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JA\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JC\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JF\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\PT\array')
swap_SensorArray_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\WT\array')