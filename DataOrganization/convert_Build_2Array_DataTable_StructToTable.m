

function dataTable = convert_Build_2Array_DataTable_StructToTable(analysis)
    
    dataTable = [];
    for i=1:length(analysis)
       for j=1:length(analysis{i})
           dataTable = [dataTable;analysis{i}{j}];
       end
    end

end