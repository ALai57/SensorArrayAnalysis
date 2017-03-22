

function hP = plot_ForceTrace_FromMATLABtable(input_var,c,lineStyle)

    if ischar(input_var)
        load(input_var)
    end
    
    F = calculate_ForceMagnitude_FromTable(tbl);
    t = tbl.Time;
    t(t==0) = NaN;
    
    hP = plot(t,F,'Color',c,'LineStyle',lineStyle,'linewidth',2);
    xlabel('Time (s)');
    ylabel('Force (N)');
    set(gca,'fontsize',12);
end