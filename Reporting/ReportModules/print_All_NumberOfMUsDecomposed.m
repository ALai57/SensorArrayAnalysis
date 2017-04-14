 

function print_All_NumberOfMUsDecomposed(selection, allData)

    options.nArrays = 2;
    options.NewVariableNames = {'nMU'};
    options.TableVariables   = {'SID',...
                               'ArmType',...
                               'ArmSide',...
                               'Experiment',...
                               'TargetForce',...
                               'ID',...
                               'TrialName',...
                               'SensorArrayFile',...
                               'SingleDifferentialFile',...
                               'ArrayNumber',...
                               'ArrayLocation',...
                               'DecompChannels',...
                               'TargetForce_MVC',...
                               'TargetForce_N'};
      
    trialData{1} = @(arrayData_tbl,options)get_NumberOfMUsDecomposed(arrayData_tbl,options);
    data         = get_Data_FromTrial(allData,trialData,options);

    
    
    options.Plot = get_Plot_Options();
    print_MultipleFigures_FromTable(selection, data, options);
    
    options.Plot.XVar   = {'TargetForce_MVC'};
    options.Plot.XLabel = 'TargetForce (%MVC)';
    print_MultipleFigures_FromTable(selection, data, options);
end

function PlotOptions = get_Plot_Options()

    PlotOptions.PlotBy          = {'ArmType'};
    PlotOptions.SubplotBy       = {}; 
    PlotOptions.GroupBy         = {'ArrayNumber'};
    PlotOptions.ColorBy         = {'ArrayNumber'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;

    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [0 100];
    PlotOptions.YVar            = {'nMU'};
    PlotOptions.YLabel          = 'Number of Motor Units';
    PlotOptions.YLim            = [0 60];
    PlotOptions.Title           = @(inputdata,options)['All subjects: ' char(inputdata.(PlotOptions.PlotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end

%     figure; hold on;
%     arrayLoc = unique(decompData.ArrayLocation);
%     for n=1:length(arrayLoc)
%         ind = decompData.ArrayLocation == arrayLoc(n);
%         plot(decompData.TargetForce_MVC(ind),decompData.nMU(ind),'o','linewidth',2);  
%     end
%     ind = decompData.TargetForce == '100%MVC';
%     ind = find(ind);
%     MVC = decompData.TargetForce_N(ind(1));
%     ylim([0 60])
%     yL = get(gca,'ylim');
%     xL = get(gca,'xlim');
%     xlim([0 xL(2)]);
%     plot([MVC, MVC],yL,'k','linewidth',4);
%     hL = legend([char(arrayLoc(1)) ' Array'],[char(arrayLoc(2)) ' Array'],'MVC');
%     set(hL,'position',[0.1450    0.7492    0.2661    0.1690])
%     legend boxoff
%     set(gca,'fontsize',12)
%     SID = char(allData.SID(1));
%     xlabel('Steady Force (%MVC)'); ylabel('Number of MUs');
%     title(['All subjects'],'fontsize',16);
%     
%     print_FigureToWord(selection,['All Subjects' char(13)],'WithMeta')
%     close(gcf);
%     selection.InsertBreak;
