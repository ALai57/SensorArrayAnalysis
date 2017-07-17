
function print_Subject_OnionSkin(selection,subjData,options)
      
     % For readability make temporary variables
    baseDir  = options.BaseDirectory;
    varNames = options.Analysis(1).Trial.OutputVariable;
    
    % Get all trial information 
    subjData   = append_SingleDifferentialFullFile_2Array(subjData,baseDir);
    [MU_Onion, ~] = loop_Over_Trials_FromTable(subjData,options.Analysis(1));
    
    SID = subjData.SID(1); 
    
    forces = unique(MU_Onion.TargetForce);
    
    for n=1:length(forces)
        i_tf = MU_Onion.TargetForce == forces(n);
        TF = MU_Onion(i_tf,:);
        
        i_aff = TF.ArmType == 'AFF';
        
        arm = unique(TF.ArmType);
        nArm = length(arm);
        nCol = max(sum(i_aff),sum(~i_aff));
        
        figure;
        for i=1:nArm
            i_A = TF.ArmType == arm(i);
            A = TF(i_A,:);
            for j=1:size(A,1)
               subplot(nArm,nCol,nCol*(i-1)+j); hold on;
               plot_Force(A(j,:),options.Analysis(1))
               plot_Rate(A(j,:),options.Analysis(1))
               xlim([0 23])
               ylim([0 40])
               title([char(A.ArmType(j)) ': ' char(A.TrialName(j))],'interpreter','none')
            end
        end
        set(gcf,'position',[ 1          41        1366         651]);
        print_FigureToWord(selection,['Subject :' SID],'WithMeta')
        close(gcf);
    end

    selection.InsertBreak;   
end

function plot_Rate(A,options)
    rate = A.Rate{1};
    rateTime = A.RateTime{1};
    
    for n=1:length(rate)
        r = rate{n};
        rT = rateTime{n};
        switch options.RateSmoothing
            case 'MAF'
                coeff = ones(1, options.MAF.Size)/options.MAF.Size;
                r = filter(coeff, 1, r);
        end
        plot(rT,r)
    end
    
end

function plot_Force(A,options)
    
    f = A.Force{1};
    fTime = A.ForceTime{1};
    
    % 
    switch options.ForceType
        case 'Magnitude'
            f = sqrt(f(:,1).^2+f(:,2).^2);
        case 'Fz'
            f(:,2);
        case 'Fx'
            f(:,1);
    end
    
    coeff = ones(1, 1000)/1000;
    f = filter(coeff, 1, f);
    
    plot(fTime,f*40/max(f), 'k','linewidth',2);
end