

function print_All_MU_Amplitude_vs_ThresholdForce_Normalized(selection,subjData,options)
    
    % Calculate MU Onset
    [MU_Onset, ~]             = apply_To_Trials_In_DataTable(subjData,options.Analysis(1));
    MU_Onset.MU_Onset_Time    = cell2mat(MU_Onset.MU_Onset_Time);
    MU_Onset.MU_Onset_Force_N = cell2mat(MU_Onset.MU_Onset_Force_N);
    
    % Calculate MU Amplitude
    [MU_PtP, ~]          = apply_To_Trials_In_DataTable(subjData,options.Analysis(2));
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
    
    % Create plot
    options.Plot = get_Plot_Options_RegressionComparison_AbsoluteUnits();
    options.Plot.Axis = axes();
    [stats] = create_ComparisonOfTwoRegressions(subjData,options);
    xlabel('\Delta Regression slope (MU Amplitude/Recruitment Force)')
    title({'All subjects: Difference in Regression Slopes',...
           '(Unaff-Aff). Mean and 95% CI'})
    print_FigureToWord(selection,'All Subjects','WithMeta');
    close(gcf);  
    
    % Print statistics
    statOut  = formatStruct_tTest(stats);
    selection.TypeText(['Statistics MU amplitude vs. Recruitment Force Regressions.' char(13)])  
    print_TableToWord(selection,statOut)
    selection.InsertBreak;
end

function PlotOptions = get_Plot_Options_RegressionComparison_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.CompareBy       = {'ArmType'};
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.Predictor       = {'MU_Onset_Force_N'};
    PlotOptions.XLabel          = 'Recruitment Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.Response        = {'MU_Amplitude'};
    PlotOptions.YLabel          = 'MU Amplitude';
    PlotOptions.YLim            = [];
    PlotOptions.CI.XLim         = [];
    PlotOptions.CI.Statistic    = 'Mean';
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
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
