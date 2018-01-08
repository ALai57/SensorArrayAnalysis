%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Converts the output of "Step5_RUN_Build_2Array_DataTable" to table
%
%   BEFORE RUNNING, SETUP:
%   - Build 2Array Data Table using "Step5_RUN_Build_2Array_DataTable"
%   
%   INPUT: 
%   - analysis = structure containing a cell for each subject
%    
%   OUTPUT: 
%   - dataTable = a single table containing ALL data
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - N/A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dataTable = convert_DataStruct_ToTable(dataStruct)
    
    dataTable = [];
    for i=1:length(dataStruct)
       for j=1:length(dataStruct{i})
           dataTable = [dataTable;dataStruct{i}{j}];
       end
    end

end