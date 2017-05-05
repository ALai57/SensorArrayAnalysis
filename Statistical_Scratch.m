

[b1, sd_b1, sse1, df1] = regress_linear(x{1},y{1});
[b2, sd_b2, sse2, df2] = regress_linear(x{2},y{2});

effectSize = b1(2) - b2(2);
denom = sqrt(sd_b1(2).^2 + sd_b2(2).^2);
t_stat = effectSize/denom;

df = calc_DF(x{1}(:,2),x{2}(:,2),sse1,sse2);


b0 = 0;
b1 = 1;
x_sim = [-5:0.5:5];
nObs = length(x_sim);
for n=1:10000
    e = normrnd(zeros(size(x_sim)),ones(size(x_sim)));
    e_std(n,1)  = std(e);
    e_std2(n,1) = sqrt( (e*e')/(nObs-1) );
    e_avg(n,1)  = mean(e);
end

figure; 
subplot(3,1,1)
histogram(e_avg); hold on;
yL = get(gca,'yLim');
plot([mean(e_avg) mean(e_avg)],yL,'linewidth',4)
subplot(3,1,2)
histogram(e_std); hold on;
yL = get(gca,'yLim');
plot([mean(e_std) mean(e_std)],yL,'linewidth',4)
subplot(3,1,3)
histogram(e_std2); hold on;
yL = get(gca,'yLim');
plot([mean(e_std2) mean(e_std2)],yL,'linewidth',4)

    y_sim = b0+b1*x_sim + e;
    
    
    
    
    
    
    
    
    
load('C:\Users\Andrew\Lai_SMULab\Projects\BicepsSensorArray\test_RegressionComparison.mat')


regression{1}.model = 'MATLAB_regress';
regression{1}.predictor  = x{1};
regression{1}.response   = y{1};
regression{1}.beta       = [];
regression{1}.beta_covar = [];
regression{1}.beta_se    = [];
regression{1}.error_var  = [];
regression{1}.error_df   = [];
regression{1}.sse        = [];
[regression{1}.beta,bint,r,~,stats]  = regress(y{1},x{1});
regression{1}.error_var  = stats(4);
regression{1}.sse        = sum(r'*r);

regression{2} = regress_linear(x{1},y{1});
regression{2}.beta+regression{2}.beta_se*tinv(1-0.05/2,regression{2}.error_df);

regression{3} = regress_linear(x{2},y{2});

%Hypothesis testing
sse1 = regression{2}.sse;
df1  = regression{2}.error_df;
s1   = regression{2}.error_var;
x1   = regression{2}.predictor;
y1   = regression{2}.response;
b1   = regression{2}.beta;
n1   = length(x1);
ssx1 = (x1(:,2)-mean(x1(:,2)))'*(x1(:,2)-mean(x1(:,2)));

sse2 = regression{3}.sse;
df2  = regression{3}.error_df;
s2   = regression{3}.error_var;
x2   = regression{3}.predictor;
y2   = regression{3}.response;
b2   = regression{3}.beta;
n2   = length(x2);
ssx2 = (x2(:,2)-mean(x2(:,2)))'*(x2(:,2)-mean(x2(:,2)));


%Are variances equal?
if sse1>sse2
    Fstat = sse1/sse2;
    finv(1-0.05/2,df1,df2);
    p = fcdf(Fstat,df1,df2);
else
    Fstat = sse2/sse2;
    finv(1-0.05/2,df2,df1);
    p = fcdf(Fstat,df2,df1);
end

%Correct DF and pool error
if p>0.975
   t_df = satterthwaite_DFapprox_regresssion_ttest2(s1,s2,ssx1,ssx2,df1,df2)%n1,n2) 
   denom = sse1/(n1-2)/ssx1+sse2/(n2-2)/ssx2
else
   t_df = n1+n2-4;
   s_pool = ((n1-2)*s1 + (n2-2)*s2)/(n1+n2-4);
   s_pool = (sse1+sse2)/(n1+n2-4)
   denom = s_pool*(1/ssx1+1/ssx2);
   tstat = (b1(2)-b2(2))/sqrt(denom);
   tcdf(tstat,t_df);
end

figure; 
plot(x1(:,2),y1,'ob'); hold on;
plot([min(x1(:,2)) max(x1(:,2))],[min(x1(:,2)) max(x1(:,2))]*b1(2)+b1(1),'b')
hold on;
plot(x2(:,2),y2,'or');
plot([min(x2(:,2)) max(x2(:,2))],[min(x2(:,2)) max(x2(:,2))]*b2(2)+b2(1),'r')

xlabel('Target Force');
ylabel('SEMG');









