
% directoryName = 'Q:\Andrew\DelsysArray - Copy\Data\Control\AC\csv'
% options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
% options.Trial.Plot.GroupingVariable = 'ArmType';
% input_var = fName{n}

function matchedFiles = find_MatchingFilesInDifferentFolders(directoryName,options)

    for i=1:length(directoryName)
        Files(i).tbl          = extract_FileInformation_FromFolder(directoryName{i},'.mat',options);
        [groupingVar, groups] = get_FileGroupingInformation(Files(i).tbl,options);
        groupedFiles(i).tbl   = find_FilesBelongingToGroup(Files(i).tbl, groupingVar, groups);   
        
        fprintf('Folder %i. %d ''.mat'' Files found. %s. Group = %s \n',...
                           i,size(Files(i).tbl,1),directoryName{i},options.Trial.Group);
%         display(sprintf('%d ''.mat'' Files found',size(Files(i).tbl,1)));
    end
    
    if length(directoryName)>1
        matchedFiles = validate_AllFilesMatch(groupedFiles,options); 
    else
        matchedFiles = groupedFiles; 
    end

end

function gFiles = validate_AllFilesMatch(gFiles,options)

    for n=1:length(gFiles)
        ind       = get_ColumnsWithName(gFiles(n).tbl,options.Trial.MatchFilesBy);
        cellArray = gFiles(n).tbl{:,ind};
        
        for i=1:size(cellArray,1)
           fileID{i,n} = [cellArray{i,:}];
        end
    end
    
    for n=1:length(fileID)
       v(n) = isequal(fileID{n,:});
    end
    
    if sum(v)~=length(v)
       error('Not all files are matched') 
    end
end

function ind = get_ColumnsWithName(tbl,matchFileBy)

    for n=1:length(matchFileBy)
       ind(n) = find(ismember(tbl.Properties.VariableNames,matchFileBy{n}));
    end
end

function tbl_Group = find_FilesBelongingToGroup(tbl_File, groupingVariable, group)
    
    gList  = categorical(tbl_File.(groupingVariable)); 
    try
        g  = categorical(group);
    catch
        g  = categorical({group});
    end
        
    nFiles = size(tbl_File,1);
    ind    = false(nFiles,1);
    
    for n=1:length(group)
        ind = ind | (gList == g(n));
    end
    
    tbl_Group = tbl_File(ind,:);
end

function [groupingVariable, groups] = get_FileGroupingInformation(tbl_MATFile,options)
    groupingVariable = options.Trial.GroupingVariable;
    
    if strcmp(options.Trial.Group,'All')
        groups = unique(tbl_MATFile.(groupingVariable));
    else
        groups = options.Trial.Group;
    end
end

