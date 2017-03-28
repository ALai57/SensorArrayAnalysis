
function [t_New, signal_New] = downSample(t_Old, signal_Old, dt_new)


dt_old = t_Old(2)-t_Old(1);
t_New_Full  = 0:dt_new:dt_old*length(t_Old)-dt_old;

%remove NaN and zero in Delsys template vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inNaN = or(isnan(signal_Old(:,1)),isnan(t_Old(:,1))); % find NaN
t_Old(inNaN)        = []; 
signal_Old(inNaN,:) = [];

inzero = find(signal_Old(1:end,1) == 0);  % find zeros
t_Old(inzero)        = []; 
signal_Old(inzero,:) = [];

t_Old = t_Old-t_Old(1);
t_New = [0:dt_new:t_Old(end)]'; %new template time is shortened too

signal_New = zeros(length(t_New), 1);

for n=1:size(signal_Old,2)
    signal_New(:,n) = interp1(t_Old,signal_Old(:,n),t_New,'spline'); % always 4 chs
end