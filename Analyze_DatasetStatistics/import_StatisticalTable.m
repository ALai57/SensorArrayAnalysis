

function stats = import_StatisticalTable(options)
    
    theFile      = options.FileName;
    theWorksheet = options.Worksheet; 
    
    [~, ~, statTable] = xlsread(theFile,theWorksheet,'A1:AS128');
    statTable         = replace_Empties(statTable);
    

    celltype   = categorical(statTable(:,2));
    colNames   = statTable(5,3:end)';
    
    Ftest_p    = cell2table(statTable(celltype=='Ftest_p',3:end));
    Ttest2_p   = cell2table(statTable(celltype=='Ttest2_p',3:end));
    Ttest2_DF  = cell2table(statTable(celltype=='Ttest2_DF',3:end));
    AFF        = cell2table(statTable(celltype=='AFF',3:end));
    UNAFF      = cell2table(statTable(celltype=='UNAFF',3:end));
    AFF_p      = cell2table(statTable(celltype=='AFF_p',3:end));
    UNAFF_p    = cell2table(statTable(celltype=='UNAFF_p',3:end));
    VAF_AFF    = cell2table(statTable(celltype=='VAF_AFF',3:end));
    VAF_UNAFF  = cell2table(statTable(celltype=='VAF_UNAFF',3:end));
    Difference = cell2table(statTable(celltype=='Difference',3:end));
    Ratio      = cell2table(statTable(celltype=='Ratio',3:end));

    for n=1:length(colNames)
       colNames{n} = strrep(colNames{n},' ','_');
    end

    Ftest_p.Properties.VariableNames = colNames';
    Ttest2_p.Properties.VariableNames = colNames;
    Ttest2_DF.Properties.VariableNames = colNames;
    AFF.Properties.VariableNames = colNames;
    UNAFF.Properties.VariableNames = colNames;
    AFF_p.Properties.VariableNames = colNames;
    UNAFF_p.Properties.VariableNames = colNames;
    VAF_AFF.Properties.VariableNames = colNames;
    VAF_UNAFF.Properties.VariableNames = colNames;
    Difference.Properties.VariableNames = colNames;
    Ratio.Properties.VariableNames = colNames;

    SID = statTable(celltype=='Ftest_p',1);

    stats.Ftest_p = Ftest_p;
    stats.Ttest2_p = Ttest2_p;
    stats.Ttest2_DF = Ttest2_DF;
    stats.AFF = AFF;
    stats.UNAFF = UNAFF;
    stats.AFF_p = AFF_p;
    stats.UNAFF_p = UNAFF_p;
    stats.VAF_AFF = VAF_AFF;
    stats.VAF_UNAFF = VAF_UNAFF;
    stats.Difference = Difference;
    stats.Ratio = Ratio;
    stats.SID = SID;
end

function statTable = replace_Empties(statTable)
   
    statTable(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),statTable)) = {''};

    for n=1:size(statTable,1)
       if isempty(statTable{n,2}) || statTable{n,2} == ""
          statTable(n,2)= {'Empty'}; 
       end
    end
end

