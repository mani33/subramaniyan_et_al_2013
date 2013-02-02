function recreate_figure_3
% RECREATE_FIGURE_3
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-11
% Created in Matlab version: 8.0.0.783 (R2012b)


% load saved results
load('pooled_data_humans')
load('fit_data_pooled_humans.mat')

fontSize = 10;
fontName = 'Arial';
%% Panel A
figure(3), clf
set(gcf,'Color','w')

speed_ind = [1 3]; % plot lowest and highest speed
markerFaceCol = {'k','none'};
markers = {'O','s'};
nSpeed = length(speed_ind);
all_subjects = {pooled_data_humans.subject};


col = [0.5 0.5 0.5];

% Subject AL & SP
subjects = {'AL','SP'};
nSub = length(subjects);

for iSub = 1:nSub
    subplot(2,2,iSub)
    h = nan(1,2);
    for iSpeed = 1:nSpeed
        subj_ind = strcmp(all_subjects,subjects{iSub});
        h(iSpeed) = plot_psych_fcn(pooled_data_humans(subj_ind).speed(speed_ind(iSpeed)).xyn,...
            fit_data_pooled_humans(subj_ind).speed(speed_ind(iSpeed)),'MarkerFaceColor',...
            markerFaceCol{iSpeed},'Marker',markers{iSpeed});
    end
    box off
    plot(xlim,[0.5 0.5],'--','Color',col)
    plot([0 0],ylim,'--','Color',col)
    set(gca,'FontSize',fontSize,'FontName',fontName)
    
    xlabel(['Spatial offset (' degree ')'])
    ylabel('Choices flash lag')
    leg = legend(h,{['10 ' degree '/s'], ['20' degree '/s']});
    set(leg,'Box','Off','Location','NorthWest')
    title(sprintf('Human %s',subjects{iSub}))
end

%% Panel B
% Spatial lag
subplot(2,2,3)
nSub = length(pooled_data_humans);

subj_mark_data = {  'AL'    'AT'    'JP'    'MS'    'SM'    'SP'    'SS'    'TS';
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
    h(iSub) = plot(speeds,lags,subj_mark_data{2,subj_ind},'MarkerFaceCol',subj_mark_data{3,subj_ind});
    hold on
    errorbar(speeds,lags,e_lb,e_ub,'k','LineStyle','None')
end
axis([9 30 0 2])
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel(['Perceived spatial lag (' degree ')'])
title('Spatial lag vs speed')

box off
leg = legend(h,{pooled_data_humans.subject},'Location','NorthEast');
set(leg,'Box','Off','FontSize',7)

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
    h(iSub) = plot(speeds,slopes,subj_mark_data{2,subj_ind},'MarkerFaceCol',subj_mark_data{3,subj_ind});
    hold on
    errorbar(speeds,slopes,e_lb,e_ub,'k','LineStyle','None')
end
axis([9 30 0 2])
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel('Slope (deg^{-1})')
title('Slope vs speed')

box off
