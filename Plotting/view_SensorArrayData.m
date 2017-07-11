
function view_SensorArrayData(tbl)

    if isempty(tbl)
       [fName,path] = uigetfile();
       load([path '\' fName]);
    end
    F = calculate_ForceMagnitude_FromTable(tbl);
    figure;
    set(gcf,'position',[680   150   892   948]);
    
    subplot(5,2,1); plot(tbl.Time,tbl.ArrayMedial_Ch1*1000); box off; add_TextLabel('Medial Array Ch1');
    subplot(5,2,2); plot(tbl.Time,tbl.ArrayMedial_Ch2*1000); box off; add_TextLabel('Medial Array Ch2');
    subplot(5,2,3); plot(tbl.Time,tbl.ArrayMedial_Ch3*1000); box off; add_TextLabel('Medial Array Ch3');
    subplot(5,2,4); plot(tbl.Time,tbl.ArrayMedial_Ch4*1000); box off; add_TextLabel('Medial Array Ch4');
    subplot(5,2,5); plot(tbl.Time,tbl.Fx_N); hold on; plot(tbl.Time, F, 'k'); add_TextLabel('Fx (N)')
    subplot(5,2,6); plot(tbl.Time,tbl.Fz_N); hold on; plot(tbl.Time, F, 'k'); add_TextLabel('Fz (N)')
    subplot(5,2,7); plot(tbl.Time,tbl.ArrayLateral_Ch1*1000); box off; add_TextLabel('Lateral Array Ch1');
    subplot(5,2,8); plot(tbl.Time,tbl.ArrayLateral_Ch2*1000); box off; add_TextLabel('Lateral Array Ch2');
    subplot(5,2,9); plot(tbl.Time,tbl.ArrayLateral_Ch3*1000); box off; add_TextLabel('Lateral Array Ch3');
    subplot(5,2,10); plot(tbl.Time,tbl.ArrayLateral_Ch4*1000); box off; add_TextLabel('Lateral Array Ch4');

    
end

function add_TextLabel(txt)
    
    yL = get(gca,'ylim');
    xL = get(gca,'xlim'); 
    text(xL(1),yL(2),[' ' txt],'HorizontalAlignment','Left','VerticalAlignment','Top')
    
end