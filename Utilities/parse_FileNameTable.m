
function tbl_out = parse_FileNameTable(tbl_in,options)

    for i=1:length(options.FileNameConvention) 
        for n=1:size(tbl_in,1)
            cellArray{n,i} = extract_Information_FromFileName(tbl_in.Files{n},...
                                                               options,...
                                                               options.FileNameConvention{i});
        end
    end
    
    tmp = array2table(cellArray);
    tmp.Properties.VariableNames = options.FileNameConvention;
    
    tbl_out = [tbl_in,tmp];
end