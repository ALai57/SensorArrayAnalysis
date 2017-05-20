% [b, sd_b, sse, df]
function regression = regress_linear(x,y)

    % Estimate beta using OLS estimators
    b = (x'*x)\(x'*y);
    
    % Estimate variance of regression
    df   = length(x)-size(b,1);
    e    = y-x*b;
    sse  = sum(e.*e);
    mse  = sse/df;
    
    b_cov = mse*inv(x'*x);
    sd_b = sqrt(abs(b_cov));
    sd_b = [sd_b(1,1); sd_b(2,2)];
    
    sst    = (y-mean(y))'*(y-mean(y));
    ss_exp = (y-x*b)'*(y-x*b);
    
    tstat = b./sqrt(diag(b_cov));
    try
        p = tcdf(tstat,df);
        p(p>0.5) = 1-p(p>0.5);
        p = p*2;
    catch
        p=[-1,-1]; 
    end
    regression.model      = 'OLSRegression';
    regression.predictor  = x;
    regression.response   = y;
    regression.beta       = b;
    regression.beta_covar = b_cov;
    regression.beta_p     = p;
    regression.beta_se    = sqrt(diag(b_cov));
    regression.error_var  = mse;
    regression.error_df   = df;
    regression.sse        = sse;
    regression.VAF        = 1-ss_exp/sst;
%     figure; plot(x(:,2),y,'o'); hold on; plot(x(:,2),x*b,'o');
%     b(1)+sd_b(1,1)*tinv(1-0.05/2,df);
end

%     ((x'*x)\(x'*e))*((x'*x)\(x'*e))' 
%     e'*e/df;