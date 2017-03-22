
% directoryName = 'Q:\Andrew\DelsysArray - Copy\Data\Control\AC\csv'
% options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
% options.Trial.Plot.GroupingVariable = 'ArmType';
% input_var = fName{n}

function fName = plot_AllTrialEMGdata_FromFolder(directoryName,options)
    
    theFiles = find_MatchingFilesInDifferentFolders(directoryName,options);
    
    allNames = {};
    for i=1:length(directoryName)
        col(i).Names  = get_PlottingVariableNames([directoryName{i} '\' theFiles(i).tbl.Files{end}]);
        nRow(i)       = size(theFiles(i).tbl,1);
        nCol(i)       = length(col(i).Names);
        allNames      = [allNames, col(i).Names];
    end
    
    %%%%%%% With multiple folders - match forces in future version %%%%%%%%%%%%
    
    
    allRow = max(nRow);
    allCol = sum(nCol);

    hax = tight_subplot(allRow,allCol,[0.01 0.01],[0.05 0.05],[0.1 0.01]);
    
    for n=1:size(theFiles(i).tbl,1)
        for i=1:length(directoryName)
            fName{n,i} = [directoryName{i} '\' theFiles(i).tbl.Files{n}];
            theAxes    = [1:nCol(i)]+(n-1)*allCol+sum(nCol(1:i-1));
            hP([1:nCol(i)],n)    = plot_EMGdata_FromMATLABtable(fName{n,i},hax(theAxes)); 
%             display(sprintf('Plotted %d/%d. File name = %s', n, size(tbl_MATFile,1),tbl_MATFile.Files{n}));
        end   
        if n==1  
            theAxes = [1:allCol]+(n-1)*allCol;
            add_Titles(allNames,hax(theAxes)); 
        end
        drawnow;
    end
    add_TrialNames(theFiles(1).tbl,hax(1:allCol:end),options)
    set(gcf,'position',[1 41 1920 1084])
end

function add_TrialNames(tbl,hax,options)

    ind       = get_ColumnsWithName(tbl,options.Plot.ShowID);
    cellArray = tbl{:,ind};

    for i=1:size(cellArray,1)
       fileID{i,1} = [cellArray{i,:}];
    end


    for n=1:length(fileID)
       axes(hax(n))
       xL = get(gca,'xlim');
       yL = get(gca,'ylim'); 
       text(0,mean(yL),[fileID{n} ' '],'horizontalalignment','right'); 
    end
    
end

function ind = get_ColumnsWithName(tbl,matchFileBy)

    for n=1:length(matchFileBy)
       ind(n) = find(ismember(tbl.Properties.VariableNames,matchFileBy{n}));
    end
end

function add_Titles(colNames,hax)
    for j=1:length(colNames)
        axes(hax(j));
        title(colNames{j},'interpreter','none','fontsize',8);
    end
end

function colNames = get_PlottingVariableNames(fName)

    load(fName)
    chNames = tbl.Properties.VariableNames;
    
    ind = ones(1,length(chNames));
    
    ind = ind - ismember(chNames,'TargetForce_Time');
    ind = ind - ismember(chNames,'TargetForce');
    ind = ind - ismember(chNames,'Time');
    
    ind = logical(ind);
    
    colNames = chNames(ind);
end

function hP = plot_EMGdata_FromMATLABtable(input_var,hax)  % PLOT EVERYTHING BUT CERTAIN CHANNELS *FOR INSTANCE FEEDBAKC AND FEEDBACK TIME
    
    if ischar(input_var)
        load(input_var)
    end

    ind = get_SignalChannels(tbl.Properties.VariableNames);
    ind = find(ind);
    
    for n=1:length(ind)
        axes(hax(n)) 
         
        signal = tbl{:,ind(n)};
        signal(signal==0) = NaN;
        hP(n) = plot(tbl.Time,signal);
        xlim([tbl.Time(1) max(tbl.Time)])
        box off
        set(gca,'yticklabel',[]);
        set(gca,'xticklabel',[]);
    end
    
end

function ind = get_SignalChannels(chNames)

    ind = ones(1,length(chNames));
    
    ind = ind - ismember(chNames,'TargetForce_Time');
    ind = ind - ismember(chNames,'TargetForce');
    ind = ind - ismember(chNames,'Time');
    
    ind = logical(ind);
end
