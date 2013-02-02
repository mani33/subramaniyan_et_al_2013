function recreate_figure_3_sized(saveit,filename)
% RECREATE_FIGURE_3_SIZED
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-29
% Created in Matlab version: 8.0.0.783 (R2012b)


% 
if nargin < 1
    saveit = false;
end

% load saved results
load('pooled_data_humans')
load('fit_data_pooled_humans.mat')

%%

speedMarker = {'O','s'};
markFaceColor = {[0 0 0],'none'};
speedLineStyle = {'-','-'};
markSize = 2;
speed_ind = [1 3]; % plot lowest and highest speed
nSpeed = length(speed_ind);
fontSizeAxis = 7;
fontSizeLabel = 8;
lineWidth = 0.5;
fontName = 'Arial';

%% Panel A
close all
figure(3), clf
set(gcf,'Color','w')
all_subjects = {pooled_data_humans.subject};
subjects = {'AL','SP'};
nSub = length(subjects);
legLocs = {'Best','SouthEast'};
for iSub = 1:nSub
    subplot(2,2,iSub)
    subject = subjects{iSub};
    subInd = find(strcmp(all_subjects,subject));
    h = nan(1,nSpeed);
    speedStr = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        speed = pooled_data_humans(subInd).speed(speed_ind(iSpeed)).speed_deg_per_sec;
        speedStr{iSpeed} = sprintf('%0.0f %s/s',speed,degree);
        h(iSpeed) = plot_psych_fcn(pooled_data_humans(subInd).speed(speed_ind(iSpeed)).xyn,...
            fit_data_pooled_humans(subInd).speed(speed_ind(iSpeed)),'Marker',speedMarker{iSpeed},...
            'MarkerFaceColor',markFaceColor{iSpeed},'fitLineStyle',speedLineStyle{iSpeed},...
            'MarkerSize',markSize,'LineWidth',lineWidth);
    end
    set(gca,'Units','centimeters');
    p = get(gca,'Position');
    p([3 4]) = [3.75 4.25];
    set(gca,'Position',p,'FontSize',fontSizeAxis,'FontName',fontName);
    box off
    xlabel(sprintf('Spatial offset (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
    ylabel('Choices flash lag','FontSize',fontSizeLabel,'FontName',fontName)
    leg = legend(h,speedStr);
    set(leg,'Box','Off','Location',legLocs{iSub},'FontSize',fontSizeLabel,'FontName',fontName)
end


%% Panel B
% Spatial lag
subplot(2,2,3)
nSub = length(pooled_data_humans);
markSize = 5;
subj_mark_data = { 'AL'    'AT'    'JP'    'MS'    'SM'    'SP'    'SS'    'TS';
                   'ko-'   'kv-'   'kd-'   'ks-'   'k^-'   'k<-'   'k>-'   'kp-';
                   'none'  'none'  'none'  [0 0 0], 'none',[0 0 0],'none', 'none'};
h = nan(1,nSub);
%
for iSub = 1:nSub
    subject = pooled_data_humans(iSub).subject;
    subj_ind = strcmp(subj_mark_data(1,:),subject);
    speeds = [pooled_data_humans(iSub).speed.speed_deg_per_sec];
    lags = [fit_data_pooled_humans(iSub).speed.spatial_lag];
    ci = cat(1,fit_data_pooled_humans(iSub).speed.conf_int_spatial_lag);
    e_lb = lags - ci(:,1)';
    e_ub = ci(:,2)' - lags;
    h(iSub) = plot(speeds,lags,subj_mark_data{2,subj_ind}(1:end-1),'MarkerFaceCol',subj_mark_data{3,subj_ind},...
        'MarkerSize',markSize);
    hold on
    plot(speeds,lags,'k','LineWidth',lineWidth)
    errorbar(speeds,lags,e_lb,e_ub,'k','LineStyle','None','LineWidth',lineWidth);
    
end
axis([9 30 0 2])
xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel(sprintf('Spatial lag (%s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)

leg = legend(h,{pooled_data_humans.subject},'Location','NorthEast');
set(leg,'Box','Off','FontSize',fontSizeLabel,'FontName',fontName)

set(gca,'XTick',[0 10 15 20])
axis([9 30 0 2])
box off

set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [4.5 4.25];
set(gca,'Position',p,'FontSize',fontSizeAxis);

pos = get(leg,'Position');
pos(2) = pos(2) + 0.02;
set(leg,'Box','Off','Position',pos)

% Slopes of the psychometric functions
subplot(2,2,4)
for iSub = 1:nSub
    subject = pooled_data_humans(iSub).subject;
    subj_ind = strcmp(subj_mark_data(1,:),subject);
    speeds = [pooled_data_humans(iSub).speed.speed_deg_per_sec];
    slopes = [fit_data_pooled_humans(iSub).speed.slope];
    ci = cat(1,fit_data_pooled_humans(iSub).speed.conf_int_slope);
    e_lb = slopes - ci(:,1)';
    e_ub = ci(:,2)' - slopes;
    h(iSub) = plot(speeds,slopes,subj_mark_data{2,subj_ind},'MarkerFaceCol',subj_mark_data{3,subj_ind},...
        'MarkerSize',markSize);
    hold on
    errorbar(speeds,slopes,e_lb,e_ub,'k','LineStyle','None','LineWidth',lineWidth)
end
axis([9 30 0 2])
xlabel(sprintf('Speed (%s/s)',degree),'FontSize',fontSizeLabel,'FontName',fontName)
ylabel('Slope (deg^{-1})','FontSize',fontSizeLabel,'FontName',fontName)

set(gca,'XTick',[0 10 15 20])
box off
% leg = legend(h,{pooled_data_humans.subject},'Location','NorthEast','FontSize',fontSizeLabel,'FontName',fontName);

set(gca,'Units','centimeters');
p = get(gca,'Position');
p([3 4]) = [4.5 4.25];
set(gca,'Position',p,'FontSize',fontSizeAxis);

pos = get(leg,'Position');
pos(2) = pos(2) + 0.02;
set(leg,'Box','Off','Position',pos)

if saveit
    printeps(3,filename,fontName);
end






