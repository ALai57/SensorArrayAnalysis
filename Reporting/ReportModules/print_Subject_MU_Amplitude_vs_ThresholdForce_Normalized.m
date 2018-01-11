

function print_Subject_MU_Amplitude_vs_ThresholdForce_Normalized(selection,subjData,options)
    
    % Calculate MU Onset
    [MU_Onset, ~] = apply_To_Trials_In_DataTable(subjData,options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
    
    % Calculate MU Amplitude
    [MU_PtP, ~] = apply_To_Trials_In_DataTable(subjData,options.Analysis(2));
    MU_PtP.MU_Amplitude  = cell2mat(MU_PtP.MU_Amplitude);
    MU_PtP.MU_Amplitude  = 1000*MU_PtP.MU_Amplitude;
    
    % Merge tables
    subjData      = append_FileID_Tag(subjData,options);
    MU_Onset      = append_FileID_Tag(MU_Onset,options);
    MU_PtP        = append_FileID_Tag(MU_PtP,options);
    
    if isequal(subjData.FileID_Tag,MU_Onset.FileID_Tag,MU_PtP.FileID_Tag)
    	subjData = [subjData, MU_Onset(:,[4,5]),MU_PtP(:,4)];
    end
    
%     subjData = normalize_PtP(subjData,[35]);
    subjData = normalize_F(subjData,34);
    
    %Plot
    options.Plot = get_Plot_Options_AbsoluteUnits();
    create_Figure_FromTable(subjData, options);
    SID = subjData.SID(1);
    
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'TargetForce'};
    PlotOptions.ColorBy         = {'TargetForce'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.1450    0.7492    0.2661    0.1690];
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'MU Onset Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1)) ': ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end



function PtP = normalize_PtP(PtP,ch)

    subjs = unique(PtP.SID);
    armType = unique(PtP.ArmType);
    for n=1:length(subjs)
        i_s = PtP.SID == subjs(n);
        for i=1:length(armType)
            i_a = PtP.ArmType == armType(i);
            i_m = PtP.TargetForce == '60%MVC';
            norm_PtP = mean(PtP{i_s&i_a&i_m,ch});
            nRows = sum(i_s&i_a);
            PtP{i_s&i_a,ch} = PtP{i_s&i_a,ch}./repmat(norm_PtP,nRows,1);
        end 
    end

end

function F = normalize_F(F,ch)

    subjs = unique(F.SID);
    armType = unique(F.ArmType);
    for n=1:length(subjs)
        i_s = F.SID == subjs(n);
        for i=1:length(armType)
            i_a = F.ArmType == armType(i);
            i_m = F.TargetForce == '100%MVC';
            a = find(i_a,1,'first');
            norm_PtP = sqrt(F.MVC(a,:)*F.MVC(a,:)');
            nRows = sum(i_s&i_a);
            F{i_s&i_a,ch} = F{i_s&i_a,ch}./repmat(norm_PtP,nRows,1);
        end 
    end

end



