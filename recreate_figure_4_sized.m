function recreate_figure_4_sized(saveit,filename)
% RECREATE_FIGURE_4_SIZED
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-29
% Created in Matlab version: 8.0.0.783 (R2012b)

if nargin < 1
    saveit = false;
end

%%
lineWidth = 0.5;
fontSizeAxis = 7;
fontSizeLabel = 8;
fontName = 'Arial';


%% Load saved fit data. 
load('fit_data_pooled_humans.mat')
load('fit_data_pooled_monkeys.mat')

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
h(1) = plot(speeds_mon,mean_lags,'kO-','LineWidth',lineWidth);
hold on
errorbar(speeds_mon,mean_lags,se_lags,'k','LineStyle','None','LineWidth',lineWidth)

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
h(2) = plot(speeds_hum,mean_lags,'kO-','MarkerFaceColor','k','LineWidth',lineWidth);
errorbar(speeds_hum,mean_lags,se_lags,'k','LineStyle','None','LineWidth',lineWidth)


% Format crap
axis([9 22 0 1.4])
box off
leg = legend(h,{'Mon','Hum'},'Location','NorthWest','FontSize',fontSizeLabel,'FontName',fontName);

set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [4.25 4.25];
set(gca,'Position',p,'FontSize',fontSizeAxis);

pos = get(leg,'Position');
pos(2) = pos(2) + 0;
set(leg,'Box','Off','Position',pos)

xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel(sprintf('Average perceived spatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)

set(gca,'XTick',[0 10 15 20],'YTick',[0 0.4 0.8 1.2])











%% Panel B - slopes
subplot(1,2,2)

% Plot monkey data
slopes_mon = [fit_data_pooled_monkeys(1).speed.slope;...
    fit_data_pooled_monkeys(2).speed.slope];

mean_slopes = mean(slopes_mon,1);
se_slopes = std(slopes_mon,[],1)/sqrt(nMon);

plot(speeds_mon,mean_slopes,'kO-','LineWidth',lineWidth)
hold on
errorbar(speeds_mon,mean_slopes,se_slopes,'k','LineStyle','None','LineWidth',lineWidth)

% Plot human data
slopes_hum = nan(nHum,nSpeeds);

for iHum = 1:nHum
    slopes_hum(iHum,:) = [fit_data_pooled_humans(iHum).speed.slope];
end

mean_slopes = mean(slopes_hum,1);
se_slopes = std(slopes_hum,[],1)/sqrt(nHum);
plot(speeds_hum,mean_slopes,'kO-','MarkerFaceColor','k','LineWidth',lineWidth)
errorbar(speeds_hum,mean_slopes,se_slopes,'k','LineStyle','None','LineWidth',lineWidth)
axis([9 22 0 1.1])
box off

leg = legend(h,{'Mon','Hum'},'Location','NorthWest','FontSize',fontSizeLabel,'FontName',fontName);

set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [4.25 4.25];
set(gca,'Position',p,'FontSize',fontSizeAxis);

pos = get(leg,'Position');
pos(2) = pos(2) + 0;
set(leg,'Box','Off','Position',pos)

xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel('Slope (deg^{-1})','FontSize',fontSizeLabel,'FontName',fontName)

set(gca,'XTick',[0 10 15 20],'YTick',[0 0.4 0.8 1.2])


if saveit
    printeps(4,filename,fontName)
end






