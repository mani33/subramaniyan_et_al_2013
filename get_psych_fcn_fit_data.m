function fit_data = get_psych_fcn_fit_data(xyn)
% fit_data = get_psych_fcn_fit_data(xyn)
%-----------------------------------------------------------------------------------------
% GET_PSYCH_FCN_FIT_DATA - Fit psychometric function for data sets using psignifit3.0.
%
% example: fit_data = get_psych_fcn_fit_data(xyn)
%
% This function is called by:
% This function calls: fit_psychometric_function
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-16
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------
fit_data = struct;
use_BCa = false; % should use Bias-Corrected and accelerated confidence interval estimation?

% Fit psychometric function
fitStat = fit_psychometric_function(xyn);

% Diagnostics of the point estimate
if fitStat.gammaislambda
    diag = Diagnostics ( fitStat.data, fitStat.params_estimate, ...
        'sigmoid', fitStat.sigmoid, 'core', fitStat.core, 'nafc', fitStat.nafc, 'cuts', fitStat.cuts, 'gammaislambda' );
else
    diag = Diagnostics ( fitStat.data, fitStat.params_estimate, ...
        'sigmoid', fitStat.sigmoid, 'core', fitStat.core, 'nafc', fitStat.nafc, 'cuts', fitStat.cuts );
end

fitStat2 = fitStat;

% Change sign of threshold so that when there is a flash-lag effect, the
% illusion magnitude or spatial lag is positive
fitStat.mcthres = -fitStat.mcthres;
fit_data.spatial_lag = -fitStat.thresholds;
fit_data.threshold = fitStat.thresholds;
fit_data.slope = fitStat.slopes;

% Get 95% bootstrap conf interval - use plugin estimates for confidence
% intervals.
cut = 1; % Threshold and slope estimate at a single point on the psychometric function
fit_data.conf_int_spatial_lag = getCI (fitStat, cut, 0.95,'threshold',use_BCa );
fit_data.conf_int_threshold = getCI (fitStat2, cut, 0.95,'threshold',use_BCa );
fit_data.conf_int_slope = getCI (fitStat, cut, 0.95,'slope',use_BCa );

% Parameter estimates of the psychometric function curve
fit_data.params_estimate = fitStat.params_estimate;

% Point estimates on the curve - for plotting purpose
fit_data.psych_curve_xy = diag.pmf;

% Calculate the location on the psychometric function to place the errorbar
if fitStat.nafc>1
    guess = 1./fitStat.nafc;
else
    guess = fitStat.params_estimate(end);
end
y = guess + fitStat.cuts(cut)*(1-guess-fitStat.params_estimate(3));
fit_data.errorbar_loc_y = y;



