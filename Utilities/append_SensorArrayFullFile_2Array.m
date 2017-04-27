

function MU_Data = append_SensorArrayFullFile_2Array(MU_Data, base)

    for n=1:size(MU_Data,1)
        
        switch MU_Data.ArmType(n)
            case 'CTR'
                condition{n} = 'Control'; 
            case 'AFF'
                condition{n} = 'Stroke';
            case 'UNAFF'
                condition{n} = 'Stroke';
        end
    
        SID     = char(MU_Data.SID(n));
        theFile = MU_Data.SensorArrayFile{n};
        SensorArrayFile{n,1} = [base '\' condition{n} '\' SID '\array\' theFile];
        
    end
    
    MU_Data.SensorArrayFullFile = SensorArrayFile;
end