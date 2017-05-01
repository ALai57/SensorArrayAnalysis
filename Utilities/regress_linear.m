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
    
    regression.model      = 'OLSRegression';
    regression.predictor  = x;
    regression.response   = y;
    regression.beta       = b;
    regression.beta_covar = b_cov;
    regression.beta_se    = sqrt(diag(b_cov));
    regression.error_var  = mse;
    regression.error_df   = df;
    regression.sse        = sse;
    
%     b(1)+sd_b(1,1)*tinv(1-0.05/2,df);
end

%     ((x'*x)\(x'*e))*((x'*x)\(x'*e))' 
%     e'*e/df;