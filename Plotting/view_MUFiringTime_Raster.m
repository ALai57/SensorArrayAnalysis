

function view_MUFiringTime_Raster(theFile)

    if ~exist(theFile)
       [theFile]=uigetfile(); 
    end

    load(theFile);
    
    figure; hold on;
    c = get(gca,'colororder'); 
    for a=1:2
        
       nUnits = length(Array(a).Decomp);
       i=1;
       for n=1:nUnits
           
           FT = Array(a).Decomp(n).FiringTimes;
           plot([FT, FT]',[ones(length(FT),1)+n, ones(length(FT),1)+n+1]','color',c(i,:),'linewidth',0.5); hold on;
           i=1+i;
           if i>size(c,1)
              i=1; 
           end
           drawnow;
       end
        
    end
end