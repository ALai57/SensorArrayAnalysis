



function switch_Fx_Fz_AllFilesInFolder(theFolder)

    if isempty(theFolder)
        theFolder = uigetdir('C:\Users\Andrew\Box Sync\BicepsSensorArray\Data\Control');
    end
  
    theFiles = get_AllFilesWithExtension(theFolder,'.mat');
    
    for n=1:length(theFiles)
        fName = [theFolder '\' theFiles{n}];
        load(fName)
        
        % figure; 
        % subplot(1,2,1); plot(tbl.Time, tbl.Fx_N); title('Fx_Before','interpreter','none')
        % subplot(1,2,2); plot(tbl.Time, tbl.Fz_N); title('Fz_Before','interpreter','none')
        
        if size(tbl,2)==2
            tbl.Properties.VariableNames(2) = {'Fz_N'};
        else 
            Fx = tbl.Fz_N;
            Fz = tbl.Fx_N;

            tbl.Fx_N = Fx;
            tbl.Fz_N = Fz;
        end
        
        save(fName,'tbl');
        display(['Switched Fx and Fz for ' fName])
        
        % figure; 
        % subplot(1,2,1); plot(tbl.Time, tbl.Fx_N); title('Fx_After','interpreter','none')
        % subplot(1,2,2); plot(tbl.Time, tbl.Fz_N); title('Fz_After','interpreter','none')
    end

    display(['Finished folder: ' theFolder]);
end