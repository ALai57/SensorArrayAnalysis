

function print_Subject_ForceTraces(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SingleDifferential.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information and calculate SEMG
    allData   = append_SingleDifferentialFullFile_2Array(allData,baseDir);
    [F, ~]    = apply_To_Trials_In_DataTable(allData,options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    
    FName   = parse_FileName_Table(table(F{:,1},'VariableNames',{'Files'}),options.SingleDifferential);
    F = [FName,F];
%     F_NoMVC = F(~(F.TargetForce=='100%MVC'),:);

    F.ArmType = categorical(F.ArmType);
    F.ArmSide = categorical(F.ArmSide);
    F.TargetForce = categorical(F.TargetForce);
   
    Arm = unique(F.ArmType);
    dt = F.Time{1}(2)-F.Time{1}(1);
    CO = get(gca,'colororder'); 
    figure; 
    for s=1:length(Arm)
        ind = F.ArmType == Arm(s);
        F_Arm = F(ind,:);
        
        fLevel = unique(F_Arm.TargetForce);
        subplot(1,2,s);hold on;
        for n=1:length(fLevel)
            indF = F_Arm.TargetForce == fLevel(n);
            F_Force = F_Arm(indF,:);
            
            
            for i=size(F_Force,1):-1:1
                
                FX = F_Force.Fx{i};
                FZ = F_Force.Fz{i};
                T  = F_Force.Time{i};
                dPer100ms = round(0.2/dt);
                coeff = ones(1, dPer100ms)/dPer100ms;
                avgFX = filter(coeff, 1, FX);
                avgFZ = filter(coeff, 1, FZ);        
                plot(avgFX,avgFZ,'linewidth',0.5,'color',CO(n,:));
                
                indt = (T > 10) & (T < 15); 
                
                quiver(mean(avgFX(indt)),mean(avgFZ(indt)),'linewidth',5,'color',CO(n,:));
            end
        end
        title(['SID = ' F_Arm.SID{1} ' Arm = ' char(F_Arm.ArmType(1)) ])
    end
    
    
   
    
     %Plot
    SID = char(F.SID(1));
    print_FigureToWord(selection,['Subject :' SID],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
   
end


function PlotOptions = get_Plot_Options_AbsoluteUnits()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.8958    0.7427    0.1021    0.1539];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'BICM', 'BICL','TRI','BRD','BRA'};
    PlotOptions.YLabel          = 'RMS EMG (Single Differential)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end

function SEMG = rename_StructFields(SEMG,varNames)
    for n=1:length(varNames) 
        name = varNames{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
end

