

function tbl_SensorArray = get_SensorArrayFileInfo_FromSubjectFolder(subjFolder,options)
    arrayFolder   = [subjFolder '\array'];
    options.Trial = options.SensorArray;
    tbl_SensorArray = extract_FileInformation_FromFolder(arrayFolder,'.mat',options);
end