
% directoryName = 'Q:\Andrew\DelsysArray - Copy\Data\Control\AC\csv'
% options.Trial.FileNameConvention = {'SID','ArmType','ArmSide','Experiment','TargetForce','Rep','ID'};
% options.Trial.Plot.GroupingVariable = 'ArmType';
% input_var = fName{n}

function fName = plot_AllTrialForceTraces_FromFolder(directoryName,options)

    if ~exist(directoryName)
        directoryName = uigetdir('Q:\Andrew\DelsysArray - Copy\Data','Choose folder to plot from');
    end
    
    tbl_MATFile = parse_FileNames_In_Folder(directoryName,'.mat',options.Trial);
    
    fprintf('Folder = %s',directoryName);
    fprintf('%d Files found',size(tbl_MATFile,1));
    
    
    groupingVar = options.Trial.GroupingVariable;
    groups = unique(tbl_MATFile.(groupingVar));
    
    figure;
    for i=1:length(groups)
        subplot(1,length(groups),i); hold on;
        ind = categorical(tbl_MATFile.(groupingVar)) == categorical(groups(i));
        tbl_Group = tbl_MATFile(ind,:);
        
        for n=1:size(tbl_Group,1)
            [c,lineStyle] = determine_ForceTrace_Properties(tbl_Group.TargetForce{n});
            fName{n}      = [directoryName '\' tbl_Group.Files{n}];
            hP(n)         = plot_ForceTrace_FromMATLABtable(fName{n},c,lineStyle);

            fprintf('Plotted %d/%d. File name = %s', n, size(tbl_Group,1),tbl_Group.Files{n});
        end

        setup_Legend()
        title({['SID = ' tbl_MATFile.SID{1}], ['Condition: = ' groups{i}]})
    end
    set(gcf,'position',[680   678   560*length(groups)   420])
end

function setup_Legend()
    
    legend_Entries = {'100%MVC',...
                      '20%MVC',...
                      '30%MVC',...
                      '40%MVC',...
                      '50%MVC',...
                      '60%MVC',...
                      '10Newtons',...
                      '15Newtons',...
                      '20Newtons',...
                      '25Newtons',...
                      '30Newtons'};

    for n=1:length(legend_Entries)   
        [c, lineStyle]=determine_ForceTrace_Properties(legend_Entries{n});
        hP(n)=plot([0 0], [0 0],'Color',c,'LineStyle',lineStyle,'Linewidth',4,'Visible','off');
    end
    
    legend(hP,legend_Entries);
    legend boxoff
end

function [c, lineStyle]= determine_ForceTrace_Properties(targetForce)
    
    c_All = varycolor(30);

    switch targetForce
        case '100%MVC'
            c = [0 0 0];
            lineStyle='-';
        case '20%MVC'
            c=c_All(2,:);
            lineStyle='-';
        case '30%MVC'
            c=c_All(4,:);
            lineStyle='-';
        case '40%MVC'
            c=c_All(6,:);
            lineStyle='-';
        case '50%MVC'
            c=c_All(8,:);
            lineStyle='-';
        case '60%MVC'
            c=c_All(10,:);
            lineStyle='-';
        case '10Newtons'
            c=c_All(22,:);
            lineStyle='--';
        case '15Newtons'
            c=c_All(24,:);
            lineStyle='--';
        case '20Newtons'
            c=c_All(26,:);
            lineStyle='--';
        case '25Newtons'
            c=c_All(28,:);
            lineStyle='--';
        case '30Newtons'
            c=c_All(30,:);
            lineStyle='--';
    end
            

end


