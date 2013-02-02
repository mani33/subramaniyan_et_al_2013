function recreate_figure_2
%--------------------------------------------------------------------------
% RECREATE_FIGURE_2
%
% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%--------------------------------------------------------------------------

% load saved results
load('pooled_data_monkeys.mat')
load('fit_data_pooled_monkeys.mat')
load('xyn_fig_2A.mat')
load('fit_data_fig_2A.mat')

nSub = 2;
fontSize = 10;
fontName = 'Arial';
%% Plot individual panels of Figure 2
figure(2), clf
set(gcf,'Color','w')
col = [0.5 0.5 0.5];



% Panel A
subplot(2,3,[1 4])
plot_psych_fcn(xyn_fig_2A,fit_data_fig_2A,'MarkerFaceColor','k')
hold on
plot(xlim,[0.5 0.5],'--','Color',col)
plot([0 0],ylim,'--','Color',col)
set(gca,'FontSize',fontSize,'FontName',fontName)
xlabel(['Spatial offset (' degree ')'])
ylabel('Choices flash lag')
title('Example session')
box off

% Panel B
speed_ind = [1 3]; % plot lowest and highest speed
markerFaceCol = {'k','none'};
markers = {'O','s'};
nSpeed = length(speed_ind);

% Monkey B & H
speed_str = {['10 ' degree '/s'], ['20 ' degree '/s']};
for iSub = 1:nSub
    subplot(2,3,1+iSub)
    h = nan(1,2);
    for iSpeed = 1:nSpeed
        h(iSpeed) = plot_psych_fcn(pooled_data_monkeys(iSub).speed(speed_ind(iSpeed)).xyn,...
            fit_data_pooled_monkeys(iSub).speed(speed_ind(iSpeed)),'MarkerFaceColor',...
            markerFaceCol{iSpeed},'Marker',markers{iSpeed});
    end
    hold on
    plot(xlim,[0.5 0.5],'--','Color',col)
    plot([0 0],ylim,'--','Color',col)
    set(gca,'FontSize',fontSize,'FontName',fontName)
    
    xlabel(['Spatial offset (' degree ')'])
    ylabel('Choices flash lag')
    title(sprintf('Monkey %s',pooled_data_monkeys(iSub).subject))
    box off
    leg = legend(h,speed_str,'Location','NorthWest');
    set(leg,'Box','Off')
end

% Panel C
% Spatial lag
subplot(2,3,5)
nSub = 2;
markerFaceCol = {'none','k'};
h = nan(1,nSub);
for iSub = 1:nSub
    speeds = [pooled_data_monkeys(iSub).speed.speed_deg_per_sec];  
    lags = [fit_data_pooled_monkeys(iSub).speed.spatial_lag];
    ci = cat(1,fit_data_pooled_monkeys(iSub).speed.conf_int_spatial_lag);
    e_lb = lags - ci(:,1)';
    e_ub = ci(:,2)' - lags;
    h(iSub) = plot(speeds,lags,'kO-','MarkerFaceCol',markerFaceCol{iSub});
    hold on
    errorbar(speeds,lags,e_lb,e_ub,'k','LineStyle','None')
end
axis([9 22 0 0.65])  
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel(['Perceived spatial lag (' degree ')'])
title('Spatial lag vs speed')
box off
leg = legend(h,{'B','H'},'Location','NorthWest');
set(leg,'Box','Off')

% Panel D
% Slopes of the psychometric functions
subplot(2,3,6)
nSub = 2;
markerFaceCol = {'none','k'};
for iSub = 1:nSub
    speeds = [pooled_data_monkeys(iSub).speed.speed_deg_per_sec];  
    slopes = [fit_data_pooled_monkeys(iSub).speed.slope];
    ci = cat(1,fit_data_pooled_monkeys(iSub).speed.conf_int_slope);
    e_lb = slopes - ci(:,1)';
    e_ub = ci(:,2)' - slopes;
    plot(speeds,slopes,'kO-','MarkerFaceCol',markerFaceCol{iSub})
    hold on
    errorbar(speeds,slopes,e_lb,e_ub,'k','LineStyle','None')
end
axis([9 22 0 1.1])  
set(gca,'FontSize',fontSize,'FontName',fontName)

xlabel(['Speed (' degree '/s)'])
ylabel('Slope (deg^{-1})')
title('Slope vs speed')
box off

