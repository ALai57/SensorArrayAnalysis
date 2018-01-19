
function print_Subject_SensorArray_SEMG_Statistics_Normalized(selection,allData,options)
   
    % For readability make temporary variables
    baseDir  = options.SensorArray.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Function to calculate Sensor Array SEMG
    calc_SA_EMG_Fcn = @(trial_Data,options)calculate_SensorArray_SEMG_FromTrial(trial_Data,options);
    
    % Get all trial information and calculate SEMG
    allData   = append_SensorArrayFullFile_2Array(allData,baseDir);
    [SEMG, ~] = apply_To_Trials_In_DataTable(allData,...
                                             calc_SA_EMG_Fcn,...
                                             options.Analysis(1)); 
    
    % Merge SEMG data with all trial information
    SEMG         = rename_StructFields(SEMG,varNames);
    allData      = merge_Data(allData,SEMG,options);
    SEMG         = reduce_RedundantData(allData,varNames);
    Norm_SEMG    = normalize_SEMG(SEMG,[5,7,8]);
    Norm_SEMG.AllData = Norm_SEMG{:,end-1:end};
    Norm_SEMG_NoMVC   = Norm_SEMG(~(Norm_SEMG.TargetForce=='100%MVC'),:);
    
    %Plot
    SID = char(SEMG.SID(1));
    options.Plot = get_Plot_Options();
    create_Figure_FromTable(Norm_SEMG,options)
    print_FigureToWord(selection,['Subject :' SID],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
   
end



function PlotOptions = get_Plot_Options()

    PlotOptions.SubplotBy       = []; 
    PlotOptions.GroupBy         = {'ArmType'};
    PlotOptions.ColorBy         = {'ArmType'};
    PlotOptions.Colors          = [1,0,0; 0,0,1];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7152    0.8236    0.1866    0.1012];   
    PlotOptions.LineWidth       = 2;
    PlotOptions.LineStyle       = 'none';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'Target Force (N)';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'AllData'};
    PlotOptions.YLabel          = 'RMS EMG (Sensor Arrays)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)[char(inputdata.SID(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function SEMG = normalize_SEMG(SEMG,ch)

    subjs = unique(SEMG.SID);
    armType = unique(SEMG.ArmType);
    for n=1:length(subjs)
        i_s = SEMG.SID == subjs(n);
        for i=1:length(armType)
            i_a = SEMG.ArmType == armType(i);
            i_m = SEMG.TargetForce == '100%MVC';
            MVC = max(SEMG{i_s&i_a&i_m,ch});
            nRows = sum(i_s&i_a);
            SEMG{i_s&i_a,ch} = SEMG{i_s&i_a,ch}./repmat(MVC,nRows,1);
        end 
    end

end

function SEMG = rename_StructFields(SEMG,varNames)
    for n=1:length(varNames) 
        name = varNames{n};
        SEMG.(name) = cell2mat(SEMG.(name));
    end
end

function allData = merge_Data(allData,SEMG,options)
    allData = append_FileID_Tag(allData,options);
    SEMG    = append_FileID_Tag(SEMG,options);
    
    if isequal(allData.FileID_Tag,SEMG.FileID_Tag)
    	allData = [allData,SEMG(:,[4,5])];
    end
end

function SEMG = reduce_RedundantData(allData,varNames)
    SEMG = varfun(@check_SEMG,allData,'InputVariables',varNames,'GroupingVariables',{'SID','ArmType','SensorArrayFile','TargetForce','TargetForce_N'});
    SEMG.Properties.VariableNames(end-1:end) = varNames;
end