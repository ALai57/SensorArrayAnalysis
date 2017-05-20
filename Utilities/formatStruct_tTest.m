
function  statOut2 = formatStruct_tTest(structIn)
    nSubjs = length(structIn);
    
    for n=1:nSubjs
       statOut{n,1} = structIn(n).SID;
       statOut{n,2} = structIn(n).fTest.p;
       statOut{n,3} = structIn(n).tTest(1).Estimate(1);
       statOut{n,4} = structIn(n).tTest(1).Estimate(2);
       statOut{n,5} = statOut{n,3}-statOut{n,4};
       statOut{n,6} = statOut{n,3}/statOut{n,4};
       statOut{n,7} = structIn(n).tTest(1).p;
       statOut{n,8} = structIn(n).tTest(1).DF;
%        statOut{n,9} = structIn(n).tTest(2).p;
%        statOut{n,10} = structIn(n).tTest(2).DF;
       try
           statOut{n,9} = structIn(n).tTest(1).VAF(1);
           statOut{n,10} = structIn(n).tTest(1).VAF(2);
           statOut{n,11} = structIn(n).tTest(1).beta_p(1);
           statOut{n,12} = structIn(n).tTest(1).beta_p(2);
       catch
           statOut{n,9}  = 0;
           statOut{n,10} = 0;
           statOut{n,11} = 1;
           statOut{n,12} = 1;
       end
    end
    header  = {'SID','F_pVal','b1_AFF','b1_UNAFF','b1_diff','b1_ratio','t_pVal','t_DF','VAF1','VAF2','b1_p','b2_p'};
%     header  = {'SID','F_pVal','b1_AFF','b1_UNAFF','b1_diff','b1_ratio','t_pVal','t_DF','t_pVal_Eq','t_DF_Eq','VAF1','VAF2'};
%     statOut = [header;statOut];
    
    statOut2 = cell2table(statOut);
    statOut2.Properties.VariableNames = header;
    
end
