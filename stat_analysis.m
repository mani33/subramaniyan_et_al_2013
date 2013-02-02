% STAT_ANALYSIS - Here we put together all the functions needed to get data for statistics reported in the
% behavior paper Subramaniyan_et_al_2013 PLOS one.
%
% Author: Mani Subramaniyan
% Date created: 2013-01-15
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%%

% The following data files are needed for the statistics. Please see
% 'compute_and_save_all_data.m' for details on how these files are created or to recreate
% them in case they are not available.

load data_monkeys_by_testing_day.mat
load data_humans_by_testing_day.mat
load data_humans_single_sess.mat

%% Write lag and slope data into Excel or csv file?
args.write_output_file = true;
args.file_format = 'txt'; % can be 'txt'(for mac and PC),'xls'/'xlsx' (for PC only)


%% Data for statistics associated with Figures 2, 3 and 4
[sdata1, column_headings] = get_lag_slope_single_sess_mon_hum(data_monkeys_by_testing_day,data_humans_single_sess);
filename = 'stat_data_for_fig_2_3_4';
write_output_file(filename,sdata1,column_headings,args)


%% Data for statistics associated with Figure 5 panels A and B
[sdata2, column_headings] = get_lag_slope_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day);
filename = 'stat_data_for_fig_5AB';
write_output_file(filename,sdata2,column_headings,args)


%% Data for statistics associated with Figure 5 panel C
% Write lag and slope data for the first session(s) to see if the monkey versus human
% lag difference remained significant.

[sdata3, column_headings] = get_lag_slope_first_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day);
filename = 'stat_data_for_fig_5C';
write_output_file(filename,sdata3,column_headings,args)
% From the excel files, we copied data to PASW.18 data files and did statistical tests
