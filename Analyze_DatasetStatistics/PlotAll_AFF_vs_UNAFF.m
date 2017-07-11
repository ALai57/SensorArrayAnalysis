
import_StatisticalTable_V2;

figure;

% hA = tight_subplot(5,5,[0.01 0.01],[0.01 0.01],[0.01 0.01]);

cols = [3,4,5,6,7,8,...     % MVC
        11,12,13,14,15,...  % EMG v F
        34,35,36,37,...     % MU Amp
        38,39,40,41,...     % MU Dur
        42,43,44,...        % MU FR
        45];                % MU Threshold F 

for n=1:length(cols)
   figure;
   x = UNAFF{:,cols(n)};
   y = AFF{:,cols(n)};
   p = T_Test{:,cols(n)};
   
   i = p<0.05;
   m = isnan(p);
   plot(x(i),y(i),'ok','markerfacecolor','k','markersize',6); hold on;
   plot(x(~i),y(~i),'or','markerfacecolor','r','markersize',6); hold on;
   plot(x(m),y(m),'ok','markerfacecolor','k','markersize',6); hold on;
   
   
   
   title(AFF.Properties.VariableNames{cols(n)},...
         'interpreter','none');
   xlabel('UNAFF')
   ylabel('AFF')
   
   mn = min([x;y]);
   mx = max([x;y]);
   rng = mx-mn;
   
   
   xlim([mn-0.1*rng,mx+0.1*rng])
   ylim([mn-0.1*rng,mx+0.1*rng])
   plot([mn-0.1*rng, mx+0.1*rng],...
        [mn-0.1*rng, mx+0.1*rng],'k');
    set(gca,'fontsize',12)
    set(gcf,'position',[403   510   210   156])
    set(gca,'ticklength',[0.035 0.025])
    box off;
end