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
%   - directory to switch Fx and Fz forces in (SWITCHES ALL FILES)
%    
%   OUTPUT: 
%   - Sensor array files with Fx and Fz switched
%
%   TO EDIT:
%   - Change target folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preprocessing - the Fx and Fz cables were switched - this code switches
% the forces back to their correct positions.
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\DW\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\ED\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JA\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JC\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\JF\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\PT\array')
switch_Fx_Fz_AllFilesInFolder('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control\WT\array')