function compute_and_save_all_data
% compute_and_save_all_data
%-----------------------------------------------------------------------------------------
% COMPUTE_AND_SAVE_ALL_DATA - Computes all the data needed for plotting figures and
% performing statistics. This can take several minutes.
%
% example: compute_and_save_all_data()
%
% This function is called by:
% This function calls:
% MAT-files required 'raw_data_monkey.mat', 'raw_data_human.mat'
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2013-01-17
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

%% Data used in Figure 2 and Figure 4

% Load raw data
load('raw_data_monkey.mat')

% Pool data across all the test sessions
pooled_data_monkeys = get_xyn_pooled(raw_data_monkey);
save('pooled_data_monkeys.mat','pooled_data_monkeys')

% Fit psychometric functions. This requires psignifit3.0
fit_data_pooled_monkeys = collect_psych_fcn_fit_data(pooled_data_monkeys); %#ok
save('fit_data_pooled_monkeys.mat','fit_data_pooled_monkeys')

% Psychometric function for panel A
% Data for panel-A. This requires psignifit3.0
% Example session from monkey B, speed 20 deg/sec
xyn_fig_2A = get_xyn(raw_data_monkey(1).speed(3).session(1).trial_data);
fit_data_fig_2A = get_psych_fcn_fit_data(xyn_fig_2A); %#ok
save('xyn_fig_2A','xyn_fig_2A')
save('fit_data_fig_2A','fit_data_fig_2A')

%% Data used in Figure 3 and Figure 4
% Load raw data
load('raw_data_human.mat')

% Pool across all the test sessions
pooled_data_humans = get_xyn_pooled(raw_data_human);
save('pooled_data_humans.mat','pooled_data_humans')

% Fit psychometric functions. This requires psignifit3.0
fit_data_pooled_humans = collect_psych_fcn_fit_data(pooled_data_humans); %#ok
save('fit_data_pooled_humans.mat','fit_data_pooled_humans')

%% Data used in Figure 5 and statistical tests
% Monkeys
data_monkeys_by_testing_day = get_fit_data_testing_day_monkey(raw_data_monkey); %#ok
save('data_monkeys_by_testing_day','data_monkeys_by_testing_day')

% Humans: sessions within a day are combined for a given speed.
data_humans_by_testing_day = get_fit_data_testing_day_humans(raw_data_human);%#ok
save('data_humans_by_testing_day','data_humans_by_testing_day')

% Humans: fit psychometric function for each session separately; used for statistics
data_humans_single_sess = get_fit_data_individual_sess_humans(raw_data_human); %#ok
save('data_humans_single_sess','data_humans_single_sess')


