function recreate_figure_2_sized(saveit,filename)
%--------------------------------------------------------------------------
% RECREATE_FIGURE_2
%
% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%--------------------------------------------------------------------------

if nargin < 1
    saveit = false;
end

% load saved results
load('pooled_data_monkeys.mat')
load('fit_data_pooled_monkeys.mat')
load('xyn_fig_2A.mat')
load('fit_data_fig_2A.mat')

%% Common params
fontSizeAxis = 7;
fontSizeLabel = 8;
fontName = 'Arial';
nSub = 2;
speed_ind = [1 3]; % plot lowest and highest speed
markerFaceCol = {'k','none'};
nSpeed = length(speed_ind);

%% Plot individual panels of Figure 2
close all
figure(2), clf
set(gcf,'Position',[263   189   619   467])
subplot(2,3,1)

% Panel A
speedMarker = 'O';
speedLineStyle = '-';
markSize = 4;
lineWidth = 0.5;
plot_psych_fcn(xyn_fig_2A,fit_data_fig_2A,'Marker',speedMarker,...
    'MarkerFaceColor',[0 0 0],'fitLineStyle',speedLineStyle,...
    'MarkerSize',markSize,'FontSize',fontSizeAxis,'LineWidth',lineWidth,'FontName',fontName);
hold on
set(gca,'YTick',[0 0.25 0.5 0.75 1],'lineWidth',lineWidth,'FontSize',fontSizeAxis)

set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [4.75 5.25];
set(gca,'Position',p);
box off
xlabel(sprintf('Spatial offset (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel('Choices flash lag','FontSize',fontSizeLabel,'FontName',fontName)

%%
% Panel B

speedLineStyle = {'-','-','-'};
markSize = 2;
lineWidth = 0.5;
marker = {'O','s'};
for iSub = 1:nSub
    subplot(2,3,1+iSub)
    h = nan(1,nSpeed);
    speedStr = cell(1,nSpeed);
    
    for iSpeed = 1:nSpeed
        speed = pooled_data_monkeys(iSub).speed(speed_ind(iSpeed)).speed_deg_per_sec;
        speedStr{iSpeed} = sprintf('%0.0f %s/s',speed,degree);
        h(iSpeed) = plot_psych_fcn(pooled_data_monkeys(iSub).speed(speed_ind(iSpeed)).xyn,...
            fit_data_pooled_monkeys(iSub).speed(speed_ind(iSpeed)),'MarkerFaceColor',markerFaceCol{iSpeed},...
            'fitLineStyle',speedLineStyle{iSpeed},'MarkerSize',markSize,'FontSize',...
            fontSizeAxis,'LineWidth',lineWidth,'Marker',marker{iSpeed});
    end
    hold on
    set(gca,'Units','centimeters');
    p = get(gca,'Position');
    p([3 4]) = [3.75 3.75];
    set(gca,'Position',p,'FontSize',fontSizeAxis);
    box off
    xlabel(sprintf('Spatial offset (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
    ylabel('Choices flash lag','FontSize',fontSizeLabel,'FontName',fontName)
    leg = legend(h,speedStr);
    set(leg,'Box','Off','Location','SouthEast','FontSize',fontSizeLabel,'FontName',fontName)
end


%%
% Panel C
% Spatial lag
subplot(2,3,5)
hm = nan(1,nSub);
subjStr = cell(1,nSub);
markSize = 5;
monkStyle = {'-','-'};
mark = {'O','O'};
faceCol = {'none','k'};

for iSub = 1:nSub
    subjStr{iSub} = pooled_data_monkeys(iSub).subject(1);
    speeds = [pooled_data_monkeys(iSub).speed.speed_deg_per_sec];  
    lags = [fit_data_pooled_monkeys(iSub).speed.spatial_lag];
    ci = cat(1,fit_data_pooled_monkeys(iSub).speed.conf_int_spatial_lag);
    e_lb = lags - ci(:,1)';
    e_ub = ci(:,2)' - lags;
    hm(iSub) = plot(speeds,lags,'LineStyle',monkStyle{iSub},'Marker',mark{iSub},'Color',...
        'k','MarkerSize',markSize,'MarkerFaceColor',faceCol{iSub},'LineWidth',lineWidth);
    hold on
    errorbar(speeds,lags,e_lb,e_ub,'k','LineStyle','None','LineWidth',lineWidth)
end

xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel(sprintf('Perceived spatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
axis([9 22 0 0.65])
box off
leg = legend(hm,subjStr);
set(leg,'Box','Off','Location','NorthWest','FontSize',fontSizeLabel,'FontName',fontName)
set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [3.75 3.75];
set(gca,'Position',p,'FontSize',fontSizeAxis);


%% Panel D
% Slopes of the psychometric functions
subplot(2,3,6)
markSize = 5;
monkStyle = {'-','-'};
mark = {'O','O'};
faceCol = {'none','k'};
subjStr = cell(1,nSub);
hm = nan(1,nSub);
for iSub = 1:nSub
    subjStr{iSub} = pooled_data_monkeys(iSub).subject(1);
    speeds = [pooled_data_monkeys(iSub).speed.speed_deg_per_sec];  
    slopes = [fit_data_pooled_monkeys(iSub).speed.slope];
    ci = cat(1,fit_data_pooled_monkeys(iSub).speed.conf_int_slope);
    e_lb = slopes - ci(:,1)';
    e_ub = ci(:,2)' - slopes;
    hm(iSub) = plot(speeds,slopes,'LineStyle',monkStyle{iSub},'Marker',mark{iSub},'Color',...
        'k','MarkerSize',markSize,'MarkerFaceColor',faceCol{iSub},'LineWidth',lineWidth);
    hold on
    errorbar(speeds,slopes,e_lb,e_ub,'k','LineStyle','None')
end
xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel('Slope (deg^{-1})','FontSize',fontSizeLabel,'FontName',fontName)
axis([9 22 0 1.1])
box off
leg = legend(hm,subjStr);
set(leg,'Box','Off','Location','NorthEast','FontSize',fontSizeLabel,'FontName',fontName)
set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [3.75 3.75];
set(gca,'Position',p,'FontSize',fontSizeAxis);


% Save figure
if saveit
    printeps(gcf,filename,fontName)
end
