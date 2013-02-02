function recreate_figure_5_sized(saveit,filename)
% RECREATE_FIGURE_5_SIZED
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-29
% Created in Matlab version: 8.0.0.783 (R2012b)

if nargin < 1
    saveit = false;
end

%%

speed_markers = {'kO','k^','ks'};
fontSizeAxis = 7;
fontSizeLabel = 8;
fontName = 'Arial';
markSize = 4;
lineWidth = 0.5;
size_xy_cm = [3.1 3.1];

%% Load saved data from current directory
load('data_monkeys_by_testing_day.mat')
load('data_humans_by_testing_day.mat')

dHum = data_humans_by_testing_day;
dMon = data_monkeys_by_testing_day;

%% Panel A Humans
% Plot spatial lag for four subjects AL, MS, SP and SS over testing day.
subjects = {'AL','MS','SP','SS'};
nSub = length(subjects);
all_subjects = {dHum.subject};

subj_axis_lim = {[-0.25 3.5 0.5 2.5],[-0.25 3.5 0.5 1.6],[-0.25 3.5 0.75 2.1],...
    [-0.25 3.5 0 1.25]};
nSpeed = 3;

close all
figure(5), clf
set(gcf,'Color','w','Position',[66   165   960   513])
speeds = [10 14 20];
for iSub = 1:nSub
    subplot(2,4,iSub)
    h = nan(1,3);
    sub_ind = strcmp(all_subjects,subjects{iSub});
    speedStr = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        speedStr{iSpeed} = sprintf('%u %s/s',speeds(iSpeed),degree);
        dd = dHum(sub_ind).speed(iSpeed).grouped_sess_fit_data;
        x = (1:length(dd))-1;
        spatial_lag = [dd.spatial_lag];
        lb = [dd.lag_errorbar_lb];
        ub = [dd.lag_errorbar_ub];
        h(iSpeed) = plot(x,spatial_lag,speed_markers{iSpeed},'MarkerFaceColor','none',...
            'MarkerSize',markSize);
        hold on
        plot(x,spatial_lag,'k','LineWidth',lineWidth)
        errorbar(x,spatial_lag,lb,ub,'LineStyle','none','Color','k','LineWidth',lineWidth)
    end
    set(gca,'YTick',0:0.5:2,'YTickLabel',0:0.5:2)
    axis(subj_axis_lim{iSub})
    if iSub == 1
        xlabel('Testing day','FontSize',fontSizeLabel,'FontName',fontName)
        ylabel(sprintf('Perceived spatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
    end
    box off
    if iSub==1
        leg = legend(h,speedStr,'FontSize',fontSizeLabel,'FontName',fontName,'Location','Best');
        set(leg,'Box','Off')
    end
    title(dHum(sub_ind).subject,'FontSize',fontSizeLabel,'FontName',fontName)
    set(gca,'FontSize',fontSizeAxis,'Units','centimeters');
    p = get(gca,'Position');
    p([3 4]) = size_xy_cm;
    set(gca,'Position',p);
end

%% Panel B Monkeys


nSub = length(dMon);
nSpeed = 3;
subj_axis_lim = {[-3 54 -0.25 0.6],[-3 54 -0.1 1.0]};

for iSub = 1:nSub
    subplot(2,4,4+iSub)
    h = nan(1,3);
    for iSpeed = 1:nSpeed
        dd = dMon(iSub).speed(iSpeed).grouped_sess_fit_data;
        x = [dd.relative_sess_time_day];
        spatial_lag = [dd.spatial_lag];
        lb = [dd.lag_errorbar_lb];
        ub = [dd.lag_errorbar_ub];
        h(iSpeed) = plot(x,spatial_lag,speed_markers{iSpeed},'MarkerFaceColor','none','MarkerSize',markSize);
        hold on
        plot(x,spatial_lag,'k','LineWidth',lineWidth)        
        errorbar(x,spatial_lag,lb,ub,'LineStyle','none','Color','k','LineWidth',lineWidth)
    end
    axis(subj_axis_lim{iSub})
    
    if iSub == 1
        xlabel('Testing day','FontSize',fontSizeLabel,'FontName',fontName)
        ylabel(sprintf('Perceived spatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
    end
    box off
    if iSub==1
        leg = legend(h,speedStr,'FontSize',fontSizeLabel,'FontName',fontName,'Location','Best');
        set(leg,'Box','Off')
    end
    set(gca,'FontSize',fontSizeAxis,'Units','centimeters');
    p = get(gca,'Position');
    p([3 4]) = size_xy_cm;
    set(gca,'Position',p);
end

%% Panel C - spatial lag and slope from the first testing day
nMon = length(dMon);
nHum = length(dHum);
nSpeeds = 3;

% Collect lag and slope data for monkeys
speeds_mon = nan(nMon,nSpeeds);
spatial_lags_mon = nan(nMon,nSpeeds);
slopes_mon = nan(nMon,nSpeeds);

for iMon = 1:nMon
    speeds_mon(iMon,:) = [dMon(iMon).speed.speed_deg_per_sec];
    % Pick first testing day data for each speed
    first_day = [dMon(iMon).speed(1).grouped_sess_fit_data(1) dMon(iMon).speed(2).grouped_sess_fit_data(1)...
        dMon(iMon).speed(3).grouped_sess_fit_data(1)];
    spatial_lags_mon(iMon,:) = [first_day.spatial_lag];
    slopes_mon(iMon,:) = [first_day.slope];
end

% Collect lag and slope data for humans
spatial_lags_hum = nan(nHum,nSpeeds);
slopes_hum = nan(nHum,nSpeeds);
speeds_hum = nan(nHum,nSpeeds);
for iHum = 1:nHum
    speeds_hum(iHum,:) = [dHum(iHum).speed.speed_deg_per_sec];
    % Pick first testing day data for each speed
    first_day = [dHum(iHum).speed(1).grouped_sess_fit_data(1) dHum(iHum).speed(2).grouped_sess_fit_data(1)...
        dHum(iHum).speed(3).grouped_sess_fit_data(1)];
    spatial_lags_hum(iHum,:) = [first_day.spatial_lag];
    slopes_hum(iHum,:) = [first_day.slope];
end

%% Panel C-Left Spatial lags
% Plot monkey data
subplot(2,4,7)
speeds_mon = mean(speeds_mon,1);
mean_lags = mean(spatial_lags_mon,1);
se_lags = std(spatial_lags_mon,[],1)/sqrt(nMon); % standard error
plot(speeds_mon,mean_lags,'kO-','MarkerFaceColor','none','LineWidth',lineWidth)
hold on
errorbar(speeds_mon,mean_lags,se_lags,'k','LineStyle','None','LineWidth',lineWidth)

% Plot human data
speeds_hum = mean(speeds_hum,1);
mean_lags = mean(spatial_lags_hum,1);
se_lags = std(spatial_lags_hum,[],1)/sqrt(nHum);
plot(speeds_hum,mean_lags,'kO-','MarkerFaceColor','k','LineWidth',lineWidth)
errorbar(speeds_hum,mean_lags,se_lags,'k','LineStyle','None','LineWidth',lineWidth)

% Format plot
axis([9 22 0 1.5])
box off
xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel(sprintf('Average perceived\nspatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName);
set(gca,'FontSize',fontSizeAxis,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = size_xy_cm;
set(gca,'Position',p);

%% Panel C-Right - Slopes
subplot(2,4,8)
% Monkeys
mean_slope = mean(slopes_mon,1);
se_slope = std(slopes_mon,[],1)/sqrt(nMon);
plot(speeds_mon,mean_slope,'kO-','MarkerFaceColor','none','LineWidth',lineWidth)
hold on
errorbar(speeds_mon,mean_slope,se_slope,'k','LineStyle','None','LineWidth',lineWidth)

% Humans
speeds_hum = mean(speeds_hum,1);
mean_slope = mean(slopes_hum,1);
se_slope = std(slopes_hum,[],1)/sqrt(nHum);
plot(speeds_hum,mean_slope,'kO-','MarkerFaceColor','k','LineWidth',lineWidth)
errorbar(speeds_hum,mean_slope,se_slope,'k','LineStyle','None','LineWidth',lineWidth)

% Format plot
axis([9 22 0 1])
box off
xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel('Average slope (deg^{-1})','FontSize',fontSizeLabel,'FontName',fontName);

set(gca,'FontSize',fontSizeAxis,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = size_xy_cm;
set(gca,'Position',p);

%% Save

if saveit
    printeps(5,filename,fontName)
end






