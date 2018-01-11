%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Andrew Lai
%
%   DESCRIPTION: 
%   - Performs Spike Triggered Averaging (STA) on data from a single trial. 
%
%   BEFORE RUNNING, SETUP:
%   - Make sure that decomposition data is appended to sensor array files
%
%   INPUT: 
%   - Array = struct that contains all the decomposition info from dEMG
%    
%   OUTPUT: 
%   - STA_tbl = table containing ALL data
%
%   TO EDIT:
%   - N/A
%
%   VARIABLES:
%   - N/A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function STA_tbl = get_STA_FromArrayStruct(Array)

    nMU      = length(Array.Decomp);
    ArrayNum = Array.Number;
    
    EMG = load(char(Array.EMGfile),'tbl');
   
    c = cell(nMU,1);
    z = zeros(nMU,1);
    STA_tbl = table([1:nMU]',...
                    c,...
                    c,...
                      'VariableNames',...
                        {'MU',...
                         'FiringTimes',...
                         'STA_Template'});
    for n=1:nMU
        tic;
        STA_tbl.FiringTimes{n,1}  = Array.Decomp(n).FiringTimes;
        STA_tbl.STA_Template{n,1} = get_STA(Array.Decomp(n), EMG.tbl, Array.Number);
        toc;
    end 
    
    temp = table(repmat(ArrayNum,nMU,1),'VariableNames',{'ArrayNumber'});
    
    STA_tbl = [temp,STA_tbl];
end


function STA = get_STA(Decomp,EMG,arrayNumber)

    [t_New,MUAPs_20k] = downSample(Decomp.Templates.Time, Decomp.Templates{:,2:5}, 1/20000);
    
    Delsys_Template_20k = table(t_New,...
                                MUAPs_20k(:,1),...
                                MUAPs_20k(:,2),...
                                MUAPs_20k(:,3),...
                                MUAPs_20k(:,4),...
                                    'VariableNames',...
                                            {'Time',...
                                             'Ch1',...
                                             'Ch2',...
                                             'Ch3',...
                                             'Ch4'} );

    if arrayNumber == categorical({'1'})
       columnInd = [1,2:5];
    elseif arrayNumber == categorical({'2'})
       columnInd = [1,8:11]; 
    end

    [STA, ~, ~] = calculate_STA(Decomp.FiringTimes, EMG(:,columnInd), Delsys_Template_20k);

end