

function df = satterthwaite_DFapprox_regresssion_ttest2(s1,s2,ssx1,ssx2,n1,n2) 
    
    num   = (s1/ssx1+s2/ssx2)^2;
    denom = 1/n1*(s1/ssx1)^2+ 1/n2*(s2/ssx2)^2; 
    
    df = num/denom;
end