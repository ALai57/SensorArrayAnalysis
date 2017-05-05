
%When we don't assume the variance of both regressions is equal, we need to
%adjust our degrees of freedom in a t-test.

% var1 = variance estimate from dataset 1
% ssx1 = sum squared x variable from dataset 1
% df1  = degrees of freedom in estimating var1

function df = satterthwaite_DFapprox_regresssion_ttest2(var1,var2,ssx1,ssx2,df1,df2) 
    
    num   = (var1/ssx1+var2/ssx2)^2;
    denom = 1/df1*(var1/ssx1)^2+ 1/df2*(var2/ssx2)^2; 
    
    df = num/denom;
    
end