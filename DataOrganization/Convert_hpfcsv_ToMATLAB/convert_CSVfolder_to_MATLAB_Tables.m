 


function convert_CSVfolder_to_MATLAB_Tables(directoryName)

    if ~exist(directoryName)
        directoryName = uigetdir('Q:\Andrew\DelsysArray - Copy\Data','Choose folder of CSV files to convert');
    end
    
    display('Converting .csv files to .mat tables');
    
    csvFiles = get_AllFilesWithExtension(directoryName,'.csv');
    fid      = create_Log(directoryName,length(csvFiles));
    
    for n=1:length(csvFiles)
        fName = [csvFiles{n}];
        sName = strrep(csvFiles{n},'.hpf','');
        sName = strrep(sName,'.csv','_SensorArray.mat');
        
        convert_CSVfile_to_MATLAB_Table(directoryName,fName, sName)
        fprintf(fid, '%-50s  -->   to  -->   %-50s\n',fName, sName);
        fprintf('Converted %d/%d. New file name = %s\n', n,length(csvFiles),sName);
    end
    
    fclose(fid);
    fprintf('Conversion complete\n')
end



function fid = create_Log(directoryName,nFiles)
    fid = fopen([directoryName '\CSV_to_MATLABTable_ConversionLog.txt'],'wt');
    fprintf(fid, 'File conversion log\n%s \n\n\n',datestr(now));
    fprintf(fid, 'Base folder = %s \n',directoryName);
    fprintf(fid, '%d ''.csv'' files found \n',nFiles);
end

function convert_CSVfile_to_MATLAB_Table(directoryName,fName,sName)
    
    Newtons_Per_Volt = 66*2;

    fName = [directoryName '\' fName];
    sName = [directoryName '\' sName];

    %Load data
    data = csvread(fName,1,0);
    fid = fopen(fName);
    variableNames = textscan(fid,'%s',size(data,2),'delimiter',',');
    fclose(fid);
    
    %Remove unnecessary columns
    variableNames = variableNames{1};
    if size(data,2)>12
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
    elseif size(data,2)==2
        variableNames = {'Time',...
                         'Fx_N'};
                     
         data(:,2) = data(:,2)*Newtons_Per_Volt;
    else
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
    
    %Save and report result
    save(sName,'tbl');
end