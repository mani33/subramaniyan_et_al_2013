function recreate_figure_4
% RECREATE_FIGURE_4
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)

% Load saved fit data. 
load('fit_data_pooled_humans.mat')
load('fit_data_pooled_monkeys.mat')

fontSize = 10;
fontName = 'Arial';
%% Panel A - spatial lags
nMon = length(fit_data_pooled_monkeys);
nHum = length(fit_data_pooled_humans);

% Plot monkey data
speeds_mon = mean([fit_data_pooled_monkeys(1).speed.speed_deg_per_sec;...
    fit_data_pooled_monkeys(2).speed.speed_deg_per_sec],1);

spatial_lag_mon = [fit_data_pooled_monkeys(1).speed.spatial_lag;...
    fit_data_pooled_monkeys(2).speed.spatial_lag];

mean_lags = mean(spatial_lag_mon,1);
se_lags = std(spatial_lag_mon,[],1)/sqrt(nMon);

figure(4), clf
set(gcf,'Color','w')
subplot(1,2,1)

h = nan(1,2);
h(1) = plot(speeds_mon,mean_lags,'kO-');
hold on
errorbar(speeds_mon,mean_lags,se_lags,'k','LineStyle','None')

% Plot human data
nSpeeds = 3;
speeds_hum = nan(nHum,nSpeeds);
spatial_lag_hum = nan(nHum,nSpeeds);

for iHum = 1:nHum
    spatial_lag_hum(iHum,:) = [fit_data_pooled_humans(iHum).speed.spatial_lag];
    speeds_hum(iHum,:) = [fit_data_pooled_humans(iHum).speed.speed_deg_per_sec];
end

speeds_hum = mean(speeds_hum,1);
mean_lags = mean(spatial_lag_hum,1);
se_lags = std(spatial_lag_hum,[],1)/sqrt(nHum);
h(2) = plot(speeds_hum,mean_lags,'kO-','MarkerFaceColor','k');
errorbar(speeds_hum,mean_lags,se_lags,'k','LineStyle','None')
axis([9 22 0 1.4])
box off
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel(['Average perceived spatial lag (' degree ')'])
title('Perceived spatial lag - monkey vs human')
box off
leg = legend(h,{'Mon (n=2)',sprintf('Hum (n=%u)',nHum)},'Location','NorthWest','FontSize',fontSize,'FontName',fontName);
set(leg,'Box','Off')


%% Panel B - slopes
subplot(1,2,2)

% Plot monkey data
slopes_mon = [fit_data_pooled_monkeys(1).speed.slope;...
    fit_data_pooled_monkeys(2).speed.slope];

mean_slopes = mean(slopes_mon,1);
se_slopes = std(slopes_mon,[],1)/sqrt(nMon);

hs(1) = plot(speeds_mon,mean_slopes,'kO-');
hold on
errorbar(speeds_mon,mean_slopes,se_slopes,'k','LineStyle','None')

% Plot human data
slopes_hum = nan(nHum,nSpeeds);

for iHum = 1:nHum
    slopes_hum(iHum,:) = [fit_data_pooled_humans(iHum).speed.slope];
end

mean_slopes = mean(slopes_hum,1);
se_slopes = std(slopes_hum,[],1)/sqrt(nHum);
hs(2) = plot(speeds_hum,mean_slopes,'kO-','MarkerFaceColor','k');
errorbar(speeds_hum,mean_slopes,se_slopes,'k','LineStyle','None')
axis([9 22 0 1.1])
box off
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel('Average slope (deg^{-1})')
title('Slope - monkey vs human')
box off
