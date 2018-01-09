%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Converts a single .csv file with raw sensor array data into .mat file
%   - .mat format saves memory
%
%   BEFORE RUNNING, SETUP:
%   - Convert .hpf files to .csv using 'Delsys File Utility'
%   - Place .csv files in a target folder  
%   - Configure and run with "Step1_RUN_Convert_CSVfiles_To_MATLAB_Tables"
%   
%   INPUT: 
%   - directoryName = Folder containing the .csv file
%   - fName = Name for the old hpf.csv file
%   - sName = Name to save the newly converted file under
%    
%   OUTPUT: 
%   - One .mat file with all sensor array EMG and force data
%
%   TO EDIT:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function convertFile_hpfcsv_to_MatlabTable(directoryName,fName,sName)
    
    %Conversion for load cell
    Newtons_Per_Volt = 66*2;

    %File name and new save name
    fName = [directoryName '\' fName];
    sName = [directoryName '\' sName];

    %Load data
    data = csvread(fName,1,0);
    fid = fopen(fName);
    variableNames = textscan(fid,'%s',size(data,2),'delimiter',',');
    fclose(fid);
    
    %Remove unnecessary columns
    variableNames = variableNames{1};
    
    
    if size(data,2)>12 %Data is in V3 format
        ind_delete = 3:2:19;
        data(:,ind_delete) = [];
        variableNames = {'Time',...
                         'ArrayMedial_Ch1',...
                         'ArrayMedial_Ch2',...
                         'ArrayMedial_Ch3',...
                         'ArrayMedial_Ch4',...
                         'Fx_N',...
                         'Fz_N',...
                         'ArrayLateral_Ch1',...
                         'ArrayLateral_Ch2',...
                         'ArrayLateral_Ch3',...
                         'ArrayLateral_Ch4',...
                         'TargetForce_Time',...
                         'TargetForce'};
         data(:,[6,7]) = data(:,[6,7])*Newtons_Per_Volt;
    elseif size(data,2)==2 %Data is in V2 format
        variableNames = {'Time',...
                         'Fx_N'};
                     
         data(:,2) = data(:,2)*Newtons_Per_Volt;
    else  % Data is in V1 format
        variableNames = {'Time',...
                         'ArrayMedial_Ch1',...
                         'ArrayMedial_Ch2',...
                         'ArrayMedial_Ch3',...
                         'ArrayMedial_Ch4',...
                         'Fx_N',...
                         'Fz_N',...
                         'ArrayLateral_Ch1',...
                         'ArrayLateral_Ch2',...
                         'ArrayLateral_Ch3',...
                         'ArrayLateral_Ch4',...
                         'TargetForce'};
                     
         data(:,[6,7]) = data(:,[6,7])*Newtons_Per_Volt;
    end
    
    %Convert to table
    tbl = array2table(data);
    clear data;
    tbl.Properties.VariableNames = variableNames;
    
    %Save result
    save(sName,'tbl');
end